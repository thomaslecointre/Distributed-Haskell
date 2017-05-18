module.exports = {
  query : function (query) {
    var fs = require("fs");
    var path = require("path");
    var episodes = [];
    var imdb = require("imdb-api");
    imdb.get(query, (err, things) => {
      if(!things || !things.hasOwnProperty("title")) {
        console.log(JSON.stringify(things));
      } else {
        var title = things["title"];

        var urlTitle = title.split(' ').join('_');
        // var seasonPath = path.join(__dirname, "Web", "Public", urlTitle);
        var seriesPath = path.join(__dirname, "Public", urlTitle);

        if (!fs.existsSync(seriesPath))  {
          fs.mkdirSync(seriesPath);
        }

        things.episodes((err, moreThings) => {
          moreThings.forEach(function(item, index) {
            imdb.getById(item["imdbid"]).then(offload);
            function offload(idThings) {
              var season = idThings["season"].toString();
              var episode = idThings["episode"].toString();
              if(!fs.existsSync(path.join(seriesPath, season))) {
                fs.mkdirSync(path.join(seriesPath, season));
              }
              if(!fs.existsSync(path.join(seriesPath, season, episode))) {
                fs.mkdirSync(path.join(seriesPath, season, episode));
              }
              var episodePath = path.join(seriesPath, season, episode, "episode.json");
              if(!fs.existsSync(episodePath)) {
                fs.appendFileSync(episodePath, JSON.stringify(idThings), { flag : "a+" });
              }
            }
          });
        });
        
      }

    });
  }
}
