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

app.use('/client', express.static(__dirname + "/client"));

app.post('/search', function (req, res) {
  console.log("Request for search result");
  var search = req.body.search;
  console.log("Search param : " + search);
  res.end(search);
});

app.get('/', function (req, res) {
  console.log("Request for home page");
  res.sendFile(path.join(__dirname, "client", "index.html"));
});

var server = app.listen(8081, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log("Haskell-Search is listening at http://%s:%s", host, port);
});
