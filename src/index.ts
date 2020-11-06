import { createWorker, createScheduler } from "tesseract.js";
import express, { NextFunction, Request, Response } from "express";
import multer, { FileFilterCallback } from "multer";
import fs from "fs";
import pino from "pino";
import { SignalConstants } from "os";
const webPort = process.env.WEB_PORT || 8080;

// handle process termination
const onTerm = (signal: SignalConstants) => {
  log.info(`${signal}: Bye now!`);
  process.exit(0);
};
process.on("SIGINT", onTerm);
process.on("SIGTERM", onTerm);

// app stuff
const log = pino({
  prettyPrint: {
    translateTime: true,
    ignore: "hostname",
    levelFirst: true,
    colorize: true,
  },
});

const m = multer({
  dest: "/tmp",
  fileFilter: (
    req: Request,
    file: Express.Multer.File,
    cb: FileFilterCallback
  ) => {
    console.log("fileFilter:file", file);
    // reject
    // cb(null, false);
    // accept
    cb(null, true);
    // fail
    // cb(new Error("I don't have a clue!"));
  },
});
const app = express();

const processSingleUpload = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (!req.file) {
    next(new Error("No file(s) provided!"));
  }
  console.log("req.file", req.file.originalname);
  log.info("Incoming!");

  const scheduler = createScheduler();
  const worker = createWorker({
    logger: (m) => log.info(m),
    errorHandler: (err) => log.error(err),
  });
  await worker.setParameters({
    tessjs_create_hocr: "0",
    tessjs_create_tsv: "0",
  });

  await worker.load();
  await worker.loadLanguage("dan+eng");
  await worker.initialize("dan+eng");
  scheduler.addWorker(worker);
  const { data } = await scheduler.addJob(
    "recognize",
    "/tmp/" + req.file.filename
  );
  scheduler.terminate();
  // debugging output
  fs.writeFileSync(`./${req.file.originalname}.json`, JSON.stringify(data));
  // respond
  res.json(true);
  log.info("Done!");
};

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  log.error(err, "Something broke!");
  res.status(500).json(err.message);
});

app.get("/", (req: Request, res: Response, next: NextFunction) => {
  res.json({ hi: "there" });
});
app.post("/", m.single("img"), processSingleUpload);

app.listen(webPort, () => log.info(`Listening on port: ${webPort}`));
