import threadpool
import os

let lineFlowVar: FlowVar[string] = spawn stdin.readLine()
while not lineFlowVar.isReady():
  echo("No input received.")
  echo("Will check again in 3 seconds.")
  sleep(3000)

echo("Input received: ", ^lineFlowVar)
