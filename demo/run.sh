#!/bin/bash

ghc Interpreter.hs -o interpreter
ghc Dispatcher.hs -o dispatcher
gnome-terminal -x bash -c "./interpreter 9090"
gnome-terminal -x bash -c "./interpreter 9091"
./dispatcher [9090,9091]
