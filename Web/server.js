// Imports
var express = require("express");
var bodyParser = require("body-parser");
var fs = require("fs");
var path = require("path");
var app = express();
var imdb = require("./IMDB");

imdb.query("game of thrones");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/Public', express.static(path.join(__dirname, "Public")));
app.use('/Client', express.static(path.join(__dirname, "Public", "Client")));

app.post('/search', function (req, res) {
  console.log("Request made for search result");
  var search = req.body.search;
  res.end(search);
});

app.get('/', function (req, res) {
  console.log("Request made for home page");
  res.sendFile(path.join(__dirname, "Public", "Client", "index.html"));
});

app.get('/Public/:series/:season/:episode', function(req, res) {
  console.log("Request made for JSON");
  res.sendFile(path.join(__dirname, "Public", req.params.series, req.params.season, req.params.episode, "episode.json"));
});

var server = app.listen(8081, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log("Haskell-Search is listening at http://%s:%s", host, port);
});
