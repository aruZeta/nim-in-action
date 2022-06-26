import asyncdispatch
import asyncnet
import protocol

type
  Client = ref object
    socket: AsyncSocket
    netAddr: string
    username: string
    id: int
    connected: bool

  Server = ref object
    socket: AsyncSocket
    port: int
    clients: seq[Client]

proc disconnect(client: Client) =
  client.connected = false
  client.socket.close()

proc `$`(client: Client): string =
  client.username & "#" & $client.id & " (" & client.netAddr & ")"

proc newServer(port: int = 6262): Server =
  Server(
    socket: newAsyncSocket(),
    port: port,
    clients: @[]
  )

proc connect(server: Server) =
  server.socket.bindAddr(server.port.Port)
  server.socket.listen()

proc sendMessage(server: Server, client: Client, line: string) {.async} =
  let msg = createMessage(client.username, line)
  for c in server.clients:
    if c.id != client.id and c.connected:
      await c.socket.send(msg)

proc sendServerMessage(server: Server, line: string) {.async} =
  let msg = createMessage("server", line)
  for c in server.clients:
    if c.connected:
      await c.socket.send(msg)

proc processMessages(client: Client, server: Server) {.async.} =
  while true:
    let line = await client.socket.recvLine()
    if line.len() == 0:
      echo(client, " disconnected")
      client.disconnect()
      asyncCheck server.sendServerMessage(client.username & " disconnected!")
      return
    echo(client, " sent: ", line)
    asyncCheck server.sendMessage(client, line)

proc acceptConnections(server: Server) {.async.} =
  while true:
    let (netAddr, clientSocket) = await server.socket.acceptAddr()
    echo("Accepted connection from ", netAddr)
    let username = await clientSocket.recvLine()
    echo("Username: ", username)
    let client = Client(
      socket: clientSocket,
      netAddr: netAddr,
      username: username,
      id: server.clients.len(),
      connected: true
    )
    server.clients.add(client)
    asyncCheck client.processMessages(server)

let server = newServer()

proc endConnection() {.noconv.} =
  for c in server.clients:
    if c.connected:
      c.disconnect()
  server.socket.close()
  echo()
  quit("Server connection ended")

setControlCHook(endConnection)

server.connect()
waitFor server.acceptConnections()
