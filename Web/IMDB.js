module.exports = {
  query : function (query) {
    var imdb = require("imdb-api");
    imdb.get(query).then(console.log);
  }
}
