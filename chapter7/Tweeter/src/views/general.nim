import htmlgen
import "../database"
import user

proc renderMain*(body: string): string =
  result = html(
    head(
      title("Tweeter written in Nim"),
      link(rel="stylesheet", `type`="text/css", href="style.css")
    ),
    body(
      `div`(id="main", body)
    )
  )

proc renderLogin*(): string =
  result = `div`(
    id="login",
    span("Login"),
    span(class="small", "Please type in you username..."),
    form(
      action="login",
      `method`="post",
      input(`type`="text", name="username"),
      input(`type`="submit", value="Login")
    )
  )

proc renderTimeline*(username: string, messages: seq[Message]): string =
  result = `div`(
    id="user",
    h1(username & "'s timeline"),
  ) & `div`(
    id="newMessage",
    span("New message"),
    form(
      action="createMessage",
      `method`="post",
      input(`type`="text", name="message"),
      input(`type`="hidden", name="username", value=username),
      input(`type`="submit", value="Tweet")
    )
  ) & renderMessages(messages)
