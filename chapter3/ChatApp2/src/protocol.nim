import json

type
  Message* = object
    username*: string
    message*: string

proc parseMessage*(msg: string): Message =
  let msgJson = parseJson(msg)
  result.username = msgJson["username"].getStr()
  result.message = msgJson["message"].getStr()

proc createMessage*(username, message: string): string =
  result = $(%{
    "username": %username,
    "message": %message
  }) & "\c\l"

export JsonParsingError
