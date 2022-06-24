import os
import threadpool
import asyncdispatch
import asyncnet
import protocol

var username: string

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
  stdout.write("Username: ")
  username = stdin.readLine
  echo("Connecting to ", serverAddr)
  await socket.connect(serverAddr, 7687.Port)
  echo("Connected!")

  while true:
    let line = await socket.recvLine()
    let parsed = parseMessage(line)
    echo(parsed.username, ": ", parsed.message)

if paramCount() == 0:
  quit("Please specify the server address, e.g. ./client localhost")

echo("ChatApp started")

let serverAddr = paramStr(1)
let socket = newAsyncSocket()
asyncCheck connect(socket, serverAddr)

var messageFlowVar = spawn stdin.readLine
while true:
  if messageFlowVar.isReady():
    let message = createMessage(username, ^messageFlowVar)
    asyncCheck socket.send(message)
    messageFlowVar = spawn stdin.readLine()
  asyncdispatch.poll()
