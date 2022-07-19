import "../database"
import user
import tagger/tagMacro

createTag html
createTag head
createTag title
createTag link, closed = false
createTag body
createTag h1
createTag hdiv, tagName = "div"
createTag span
createTag form
createTag input, closed = false

proc renderMain*(content: string): string =
  result = html:
    head:
      title:
        "Tweeter written in Nim"
      link:
        rel = "stylesheet"
        "type" = "text/css"
        href = "style.css"
    body:
      hdiv:
        id = "main"
        content

proc renderLogin*(): string =
  result = hdiv:
    id = "login"
    span:
      "Login"
    span:
      class = "small"
      "Please type in your username..."
    form:
      action = "login"
      "method" = "post"
      input:
        "type" = "text"
        name = "username"
      input:
        "type" = "submit"
        value = "Login"

proc renderTimeline*(username: string, messages: seq[Message]): string =
  result = hdiv:
    id = "user"
    h1:
      username
      "'s timeline"

  result.add hdiv do:
    id = "newMessage"
    span:
      "New message"
    form:
      action = "createMessage"
      "method" = "post"
      input:
        "type" = "text"
        name = "message"
      input:
        "type" = "hidden"
        name = "username"
        value = username
      input:
        "type" = "submit"
        value = "Tweet"

  result.add renderMessages messages
