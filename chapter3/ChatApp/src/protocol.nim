import json

type
  Message* = object
    username*: string
    message*: string

proc parseMessage*(data: string): Message =
  let dataJson = parseJson(data)
  result.username = dataJson["username"].getStr()
  result.message = dataJson["message"].getStr()

proc createMessage*(username, message: string): string =
  result = $(%{
    "username": %username,
    "message": %message
  }) & "\c\l"

when isMainModule:
  block:
    let data = """{"username": "Jhon", "message": "Hi!"}"""
    let parsed = parseMessage(data)
    doAssert parsed.username == "Jhon"
    doAssert parsed.message == "Hi!"

  block:
    let data = """foobar"""
    try:
      let parsed = parseMessage(data)
      echo("This won't run")
    except JsonParsingError:
      doAssert true
    except:
      doAssert false

  block:
    let expected = """{"username":"dom","message":"hello"}""" & "\c\l"
    doAssert createMessage("dom", "hello") == expected

  echo("All tests passed")
