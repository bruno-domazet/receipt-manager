import { createWorker } from "tesseract.js";
import * as fs from 'fs'
import pino from "pino";

const log = pino({
  prettyPrint: {
    levelFirst: true,
    colorize: true,
  },
});

const worker = createWorker();

(async () => {
  await worker.load();
  await worker.loadLanguage("eng");
  await worker.initialize("eng");
  // https://www.nutemplates.com/wp-content/uploads/starbucks-receipt-img.jpg
  const {data:{lines}} = await worker.recognize(fs.readFileSync("assets/receipt.jpg"));
  log.info({lines});
  await worker.terminate()
})();
