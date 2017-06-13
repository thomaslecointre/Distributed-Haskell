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
          var template = fs.readFileSync(path.join(public, views, 'chronological.ejs'));
          var obj = JSON.parse(fs.readFileSync(path.join(public, views, json, 'chronological.json')));
          res.end(ejs.render(template, {data: obj}));
          break;
        case "per-season":
          res.end(ejs.render());
          break;
        case "pertinence":
          res.end(ejs.render());
          break;
        case "statistics":
          res.end(ejs.render());
          break;
      }
      
    });
  }
}
