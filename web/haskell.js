module.exports = {
  launch : function(arguments) {
    const spawnSync = require('child_process').spawnSync;
    const spawn = require('child_process').spawn;
    const fs = require('fs');
    const path = require('path');

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
    });
  }
}
