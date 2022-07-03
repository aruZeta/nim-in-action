import strutils

var line = "en Nim_(programming_language) 1 70231"
var matches = line.split()

doAssert matches[0] == "en"
doAssert matches[1] == "Nim_(programming_language)"
doAssert matches[2] == "1"
doAssert matches[3] == "70231"
echo("Parsed successfully!")
