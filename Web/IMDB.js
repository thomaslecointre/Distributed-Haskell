module.exports = {
  query : function (query) {
    var fs = require("fs");
    var path = require("path");
    var episodes = [];
    var imdb = require("imdb-api");
    imdb.get(query, (err, things) => {
      if (err) {
        console.error("Query failed");
      } else {
        // console.log(things);
        var title = things["title"];
        var urlTitle = title.split(' ').join('_');
        var seasonPath = path.join("Public", urlTitle);

        if(!fs.existsSync(seasonPath)) {
          fs.mkdirSync(seasonPath);
        }

        var seasonCount = things["totalseasons"];

        for(var seasonNumber = 0; seasonNumber < seasonCount; seasonNumber++) {
          console.log("Iterating...");
          if(!fs.existsSync(path.join(seasonPath, seasonNumber))) {
            console.log("Creating directory...");
            fs.mkdir(path.join(seasonPath, seasonNumber));
            console.log("Directory created");
          }
        }
      }
      // console.log(things);
      /*
      if (!fs.existsSync(seasonPath))  {
        fs.mkdirSync(seasonPath);
        things.episodes((err, moreThings) => {
          moreThings.forEach(function(item, index) {
            imdb.getById(item["imdbid"]).then(offload);
            function offload(idThings) {
              console.log(idThings);
              var season = idThings["season"].toString();
              var episode = idThings["episode"].toString();
              if(!fs.existsSync(path.join(seasonPath, season))) {
                fs.mkdirSync(path.join(seasonPath, season));
                if(!fs.existsSync(path.join(seasonPath, season, episode))) {
                  fs.mkdirSync(path.join(seasonpath, season, episode));
                }
              }
              var episodePath = path.join(seasonPath, season, episode, "episode.json");
              if(!fs.existsSync(episodePath)) {
                fs.appendFileSync(episodePath, JSON.stringify(idThings));
              }
            }
          });
        });

      }
      */
    });
  }
}
