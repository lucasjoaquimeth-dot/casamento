/* Servidor estático de desenvolvimento.
   Serve a raiz do repositório, exatamente como o GitHub Pages faz.

   Uso: node serve.js   →   http://127.0.0.1:3000
*/
const http = require("http");
const fs   = require("fs");
const path = require("path");

const PORT = 3000;
const ROOT = __dirname;

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css":  "text/css; charset=utf-8",
  ".js":   "application/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".m4a":  "audio/mp4",
  ".mp3":  "audio/mpeg",
  ".ogg":  "audio/ogg",
  ".png":  "image/png",
  ".jpg":  "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif":  "image/gif",
  ".svg":  "image/svg+xml",
  ".ico":  "image/x-icon",
};

http.createServer(function(req, res){
  var url = decodeURIComponent(req.url.split("?")[0]);

  /* diretório → index.html (/, /carta/, /convite/) */
  if(url.endsWith("/")) url += "index.html";

  /* resolve dentro da raiz e bloqueia path traversal (../../) */
  var filePath = path.normalize(path.join(ROOT, url));
  if(!filePath.startsWith(ROOT)){
    res.writeHead(403); res.end("Forbidden"); return;
  }

  fs.readFile(filePath, function(err, data){
    if(err){
      res.writeHead(404, {"Content-Type": "text/plain; charset=utf-8"});
      res.end("Not found: " + url);
      return;
    }
    var ext  = path.extname(filePath).toLowerCase();
    var mime = MIME[ext] || "application/octet-stream";
    res.writeHead(200, {
      "Content-Type": mime,
      "Cache-Control": "no-cache",
      "Access-Control-Allow-Origin": "*",
    });
    res.end(data);
  });
}).listen(PORT, "127.0.0.1", function(){
  console.log("Convite rodando em http://127.0.0.1:" + PORT);
  console.log("  carta   -> http://127.0.0.1:" + PORT + "/carta/");
  console.log("  convite -> http://127.0.0.1:" + PORT + "/convite/");
});
