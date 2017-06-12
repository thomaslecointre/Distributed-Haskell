// Imports
var express = require('express');
var bodyParser = require('body-parser');
var fs = require('fs');
var path = require('path');
var app = express();
var imdb = require('./imdb');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use('/public', express.static(path.join(__dirname, 'public')));
app.use('/client', express.static(path.join(__dirname, 'public', 'client')));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'public', 'views'));

app.get('/search/:series/:keyword/:request', function (req, res) {
  console.log('Request made for search result');
  var series = req.params.series;
  var keyword = req.params.keyword;
  if(keyword === "N_A") {
    keyword = "N/A";
  }
  var request = req.params.request;
  imdb.query(series, keyword, res, request);
});

app.get('/', function (req, res) {
  console.log('Request made for home page');
  res.sendFile(path.join(__dirname, 'public', 'client', 'index.html'));
});

app.get('/public/:series/:season/:episode', function(req, res) {
  console.log('Request made for JSON : ' + req.params.season + '/' + req.params.episode);
  res.sendFile(path.join(__dirname, 'public', req.params.series, req.params.season, req.params.episode, 'episode.json'));
});

app.get('/tryejs', function(req, res) {
  console.log('Request made for ejs');
  res.render('chronological', { episodes : 50 });
});

var server = app.listen(8081, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('Haskell-Search is listening at http://%s:%s', host, port);
});
