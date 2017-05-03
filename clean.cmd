@ECHO OFF

set location=%1
set main=%2
cd %location%
del %main%.o %main%.hi %main%.exe
ghc --make %main%.hs -o %main%.exe