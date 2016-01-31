@echo off

nodemcu-uploader upload files\*.*

cd src
nodemcu-uploader upload init.lua
nodemcu-uploader upload services\*.lua --compile
nodemcu-uploader upload lib\*.lua --compile

cd ..
nodemcu-uploader terminal
