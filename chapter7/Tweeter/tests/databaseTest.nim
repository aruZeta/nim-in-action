import database
import os
import times

when isMainModule:
  removeFile("Tweeter_test.db")

  var db = newDB("Tweeter_test.db")
  db.setup()

  db.create(User(username: "aruZeta"))
  db.create(User(username: "nim_lang"))

  let
    msg1 = "Hello Nim in Action readers"
    msg2 = "99.9% off Nim in Action for everyone, for the next minute only!"
  db.post(Message(
    username: "nim_lang",
    time: getTime() - 4.seconds,
    msg: msg1
  ))
  db.post(Message(
    username: "nim_lang",
    time: getTime(),
    msg: msg2
  ))

  var aru: User
  doAssert db.findUser("aruZeta", aru)

  var nim: User
  doAssert db.findUser("nim_lang", nim)

  db.follow(aru, nim)

  let messages = db.findMessages(aru.following)
  echo messages

  doAssert(messages[0].msg == msg2)
  doAssert(messages[1].msg == msg1)

  echo "All tests finished succesfully!"
