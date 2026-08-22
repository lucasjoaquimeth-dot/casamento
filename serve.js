const http = require("http");
const fs   = require("fs");
const path = require("path");

const PORT = 3000;
const ROOT = path.join(__dirname, "convite");

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css":  "text/css",
  ".js":   "application/javascript",
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
  var url  = decodeURIComponent(req.url.split("?")[0]);
  if(url === "/") url = "/index.html";

  /* assets ficam um nível acima de convite/ */
  var filePath;
  if(url.startsWith("/assets/")){
    filePath = path.join(__dirname, url);
  } else {
    filePath = path.join(ROOT, url);
  }

  fs.readFile(filePath, function(err, data){
    if(err){
      res.writeHead(404); res.end("Not found: " + url); return;
    }
    var ext  = path.extname(filePath).toLowerCase();
    var mime = MIME[ext] || "application/octet-stream";
    res.writeHead(200, {
      "Content-Type": mime,
      "Access-Control-Allow-Origin": "*",
    });
    res.end(data);
  });
}).listen(PORT, "127.0.0.1", function(){
  console.log("Convite rodando em http://127.0.0.1:" + PORT);
});
