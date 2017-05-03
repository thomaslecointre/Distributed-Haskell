@ECHO OFF

set location=%1
set main=%2
set main_trimmed=%main:~0,-3%
cd %location%
del %main_trimmed%.o %main_trimmed%.hi %main_trimmed%.exe
ghc --make %main_trimmed%.hs -o %main_trimmed%.exe