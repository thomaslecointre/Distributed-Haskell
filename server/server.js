// Imports
var express = require("express");
var fs      = require("fs");
var imdb    = require("imdb-api");
var app     = express();

app.get('/', function (request, res) {
    res.sendFile(__dirname + "../client/index.html"); // Needs fixing
});

app.get('/search', function (request, res) {
    response = {
        title : "Game of Thrones",
        description : "L'histoire de la série, située sur les continents fictifs de Westeros et Essos à la fin d'un été d'une dizaine d'années, entrelace plusieurs intrigues. La première intrigue suit l'histoire des membres de plusieurs familles nobles, dans une guerre civile pour conquérir le Trône de Fer du Royaume des Sept Couronnes. La deuxième intrigue couvre l'histoire de Jon Snow et de la future menace croissante de l'hiver approchant, des créatures mythiques et légendaires venues du Nord du Mur de Westeros. La troisième raconte la démarche de Daenerys Targaryen au sud d'Essos, la dernière représentante en exil de la dynastie déchue en vue de reprendre le Trône de Fer. À travers ces personnages « moralement ambigus », la série explore les sujets liés au pouvoir politique, à la hiérarchie sociale, la religion, la guerre civile, la sexualité, et à la violence en général."
    };
    console.log(response);
    res.end(JSON.stringify(response));
});


var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log("Haskell-Search is listening at http://%s:%s", host, port);
    console.log(__dirname);
});
