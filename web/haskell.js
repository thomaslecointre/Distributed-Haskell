module.exports = {
  launch : function(arguments, res, request) {
    const spawnSync = require('child_process').spawnSync;
    const spawn = require('child_process').spawn;
    const fs = require('fs');
    const path = require('path');
    const ejs = require('ejs');


    const haskell = path.join(__dirname, 'haskell');
    
    const cmd = spawn(path.join(haskell, 'Messenger.exe'), arguments);
      
    cmd.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    cmd.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    cmd.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
      
      switch (request) {
        case "chronological":
          var obj = JSON.parse(fs.readFileSync(path.join(__dirname, 'public', 'views', 'json', 'chronological.json')));
          res.render(path.join(__dirname, 'public', 'views', 'chronological.ejs'), {data: obj});
          break;
        case "per-season":
          var obj = JSON.parse(fs.readFileSync(path.join(__dirname, 'public', 'views', 'json', 'per-season.json')));
          res.render(path.join(__dirname, 'public', 'views', 'per-season.ejs'), {data: obj});
          break;
        case "pertinence":
          var obj = JSON.parse(fs.readFileSync(path.join(__dirname, 'public', 'views', 'json', 'pertinence.json')));
          res.render(path.join(__dirname, 'public', 'views', 'pertinence.ejs'), {data: obj});
          break;
        case "statistics":
          res.end("Statistics not currently functioning. Please try a different request.");
          break;
      }
      
    });
  }
}
