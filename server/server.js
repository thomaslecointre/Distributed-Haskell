// Imports
var express = require("express");
var fs      = require("fs");
var imdb    = require("imdb-api");
var path    = require("path");
var app     = express();


app.get('/', function (request, res) {
    res.sendFile(path.join(__dirname, "..", "client", "index.html")); // Needs fixing
});

app.get('/?search=*', function (request, res) {
    response = {
        title : "Game of Thrones",
        description : "Set on the fictional continents of Westeros and Essos, Game of Thrones has several plot lines and a large ensemble cast. The first story arc follows a dynastic conflict among competing claimants for succession to the Iron Throne of the Seven Kingdoms, with other noble families fighting for independence from the throne. The second covers attempts to reclaim the throne by the exiled last scion of the realm's deposed ruling dynasty; the third chronicles the threat of the impending winter and the legendary creatures and fierce peoples of the North."
    };
    console.log(response);
    res.end(JSON.stringify(response));
});


var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log("Haskell-Search is listening at http://%s:%s", host, port);
});
