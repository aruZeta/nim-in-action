import os
import threadpool
import asyncdispatch
import asyncnet
import protocol

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
  echo("Connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, " said ", parsed.message)

echo("ChatApp started")

if paramCount() == 0:
  quit("Please specify the server address, e.g. ./client localhost")
let serverAddr = paramStr(1)
var socket = newAsyncSocket()
asyncCheck connect(socket, serverAddr)

var messageFlowVar = spawn stdin.readLine
while true:
  if messageFlowVar.isReady():
    let message = createMessage("Anonymous", ^messageFlowVar)
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()
  asyncdispatch.poll()
