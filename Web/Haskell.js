module.exports = {
  function() {
    const spawn = require("child_process").spawn;

    const haskell = spawn("Haskell/main.exe");

    haskell.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });

    haskell.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });

    haskell.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
    });
  }
}
