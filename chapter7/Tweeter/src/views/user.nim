import "../database"
import times
import htmlgen

proc renderUser*(user: User): string =
  result = `div`(
    id="user",
    h1(user.username),
    span("Following: " & $user.following.len)
  )

proc renderUser*(user: User, currentUser: User): string =
  var followButton: string
  if user.username notin currentUser.following:
    followButton = form(
      action="follow",
      `method`="post",
      input(`type`="hidden", name="follower", value=currentUser.username),
      input(`type`="hidden", name="target", value=user.username),
      input(`type`="submit", value="Follow"),
    )
  result = `div`(
    id="user",
    h1(user.username),
    span("Following: " & $user.following.len),
    followButton
  )

proc renderMessages*(messages: seq[Message]): string =
  var msgs: string
  for message in messages:
    msgs.add `div`(
      a(href="/" & message.username, message.username),
      span(message.time.utc().format("HH:mm MMMM d',' yyyy")),
      h3(message.msg)
    )
  result = `div`(
    id="messages",
    msgs
  )

when isMainModule:
  echo renderUser(User(username: "<aru>", following: @[]))
  echo renderMessages(@[
    Message(username: "aru", time: getTime(), msg: "Hello World!"),
    Message(username: "aru", time: getTime(), msg: "Testing")
  ])
