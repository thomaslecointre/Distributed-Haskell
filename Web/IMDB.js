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

        var title = things['title'];
        var urlTitle = title.toLowerCase().split(' ').join('_');
        var path = require('path');
        var seriesPath = path.join(__dirname, 'public', urlTitle);

        var fs = require('fs');
        if (!fs.existsSync(seriesPath))  {
          fs.mkdirSync(seriesPath);
        }

        things.episodes((err, moreThings) => {

          moreThings.forEach(function(item, index) {

            imdb.getById(item['imdbid'], {apiKey: '46e82526'}, (err, idThings) => {

              var season = idThings['season'].toString();
              var episode = idThings['episode'].toString();

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

            });
            

          });
          var haskell = require('./haskell');
          var args = [keyword, urlTitle];
          var items = fs.readdirSync(seriesPath);
          for(var i = 0; i < items.length; i++) {
            var seasonPath = path.join(seriesPath, (i + 1).toString());
            var moreItems = fs.readdirSync(seasonPath);
            args.push(moreItems.length);
          }

          haskell.launch(args);
        });
      }
    });
  }
}
