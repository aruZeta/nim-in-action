import os
import threadpool
import asyncdispatch
import asyncnet
import protocol
import std/parseopt
import std/parseutils

type
  UserClient = ref object
    username: string
    socket: AsyncSocket
    serverAddr: string
    serverPort: int
    messageFlow: FlowVar[string]

proc newUserClient(serverPort: int = 6262): UserClient =
  UserClient(
    socket: newAsyncSocket(),
    serverPort: serverPort
  )

proc askUsername(userClient: UserClient) =
  stdout.write("Username: ")
  let username: string = stdin.readLine()
  userClient.username = username

proc startConnection(userClient: UserClient) {.async.} =
  echo("Connecting to: ", userClient.serverAddr)
  await userClient.socket.connect(
    userClient.serverAddr,
    userClient.serverPort.Port
  )
  echo("Connected!")

proc connect(userClient: UserClient) {.async.} =
  waitFor userClient.startConnection()
  waitFor userClient.socket.send(userClient.username & "\c\l")

proc recvMessages(userClient: UserClient) {.async.} =
  while true:
    let line = await userClient.socket.recvLine()
    try:
      let parsed = parseMessage(line)
      echo(parsed.username, ": ", parsed.message)
    except JsonParsingError:
      if line.len() == 0:
        echo()
        quit("The server ended the connection")

proc createInputThread(userClient: UserClient) =
  userClient.messageFlow = spawn stdin.readLine()

proc sendMessages(userClient: UserClient) =
  while true:
    if userClient.messageFlow.isReady():
      asyncCheck userClient.socket.send(^userClient.messageFlow & "\c\l")
      userClient.createInputThread()
    asyncdispatch.poll()

if paramCount() == 0:
  quit("Please specify the server address, e.g. ./client localhost")

let userClient = newUserClient()

var params: OptParser = initOptParser(
  commandLineParams(),
  shortNoVal = {'0'}, # Need to pass a
  longNoVal = @["0"]  # non-empty array
)

for kind, key, val in params.getopt():
  case kind
  of cmdEnd: discard
  of cmdShortOption:
    if key == "p":
      discard parseInt(val, userClient.serverPort)
  of cmdLongOption:
    if key == "port":
      discard parseInt(val, userClient.serverPort)
  of cmdArgument:
    userClient.serverAddr = key

proc endConnection() {.noconv.} =
  echo()
  quit("Connection ended")

setControlCHook(endConnection)

userClient.askUsername()
asyncCheck userClient.connect()
asyncCheck userClient.recvMessages()
userClient.createInputThread()
userClient.sendMessages()
