module.exports = {
  query : function (series, keyword, res) {
    var imdb = require('imdb-api');

    imdb.get(series, {apiKey: '46e82526'}, (err, things) => {

      if(!things || err) {
        console.log('An error has occurred. Please try again.');
        res.end('An error has occurred. Please try again.');
      } else {
        console.log('Processing request...');
        res.end('Processing request...');

        var title = things.title;
        var urlTitle = title.toLowerCase().split(' ').join('_');
        var path = require('path');
        var seriesPath = path.join(__dirname, 'public', urlTitle);

        var fs = require('fs');
        if (!fs.existsSync(seriesPath))  {
          fs.mkdirSync(seriesPath);
        }

        things.episodes((err, moreThings) => {

          moreThings.forEach(function(item, index) {

            imdb.getById(item.imdbid, {apiKey: '46e82526'}, (err, idThings) => {
			
              if(!idThings || err) {
                console.log('An error has occurred. Please try again.');
                res.end('An error has occurred. Please try again.');
              } else {

                var season = idThings.season;
                var episode = idThings.episode;

                if(!fs.existsSync(path.join(seriesPath, season))) {
                  fs.mkdirSync(path.join(seriesPath, season));
                }

                if(!fs.existsSync(path.join(seriesPath, season, episode))) {
                  fs.mkdirSync(path.join(seriesPath, season, episode));
                }

                var episodePath = path.join(seriesPath, season, episode, 'episode.json');
                if(!fs.existsSync(episodePath)) {
                  fs.appendFileSync(episodePath, JSON.stringify(idThings), { flag : 'a+' });
                }
              }
            });
          });

          var haskell = require('./haskell');
          var args = [keyword, urlTitle];
          console.log("Arguments sent to messenger : " + args);
          haskell.launch(args);
        });
      }
    });
  }
}
