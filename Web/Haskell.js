module.exports = {
  launch : function(arguments) {
    const spawnSync = require("child_process").spawnSync;
    const spawn = require("child_process").spawn;
    const fs = require("fs");
    const path = require("path");

    const cmd = spawn(path.join(__dirname, "Haskell", "main.cmd"), ["Game_of_Thrones", "10", "10", "10", "10", "10", "10"]);
      
    cmd.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    cmd.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    cmd.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
    });

    /*
    const haskell = spawn(path.join(__dirname, "Haskell", "main.exe"), ["Game_of_Thrones", "10", "10", "10", "10", "10", "10"]);
    
    haskell.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    haskell.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    haskell.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
    });
    */
  }
}
