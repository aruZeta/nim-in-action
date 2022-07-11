import os
import configurator
import json

config configTest:
  address: string
  port: int

var myConf = newConfigTest()
myConf.load(currentSourcePath.parentDir() / "configTest.json")
echo("Adress: ", myConf.address)
echo("Port: ", myConf.port)
