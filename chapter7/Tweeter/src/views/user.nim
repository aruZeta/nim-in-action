#? stdtmpl(subsChar = '$', metaChar = '#', toString = "xmltree.escape")
#import "../database"
#import times
#import xmltree
#
#proc renderUser*(user: User): string =
#  result = ""
<div id="user">
  <h1>${user.username}</h1>
  <span>Following: ${$user.following.len}</span>
</div>
#end proc
#
#proc renderUser*(user: User, currentUser: User): string =
#  result = ""
<div id="user">
  <h1>${user.username}</h1>
  <span>Following: ${$user.following.len}</span>
  #if user.username notin currentuser.following:
  <form action="follow" method="post">
    <input type="hidden" name="follower" value="${currentUser.username}">
    <input type="hidden" name="target" value="${user.username}">
    <input type="submit" value="Follow">
  </form>
  #end if
</div>
#end proc
#
#proc renderMessages*(messages: seq[Message]): string =
#  result = ""
<div id="messages">
  #for message in messages:
    <div>
      <a href="/${message.username}">${message.username}</a>
      <span>${message.time.getGMTime().format("HH:mm MMMM d',' yyyy")}</span>
      <h3>${message.msg}</h3>
    </div>
  #end for
</div>
#end proc
#
#when isMainModule:
#  echo renderUser(User(username: "<aru>", following: @[]))
#  echo renderMessages(@[
#    Message(username: "aru", time: getTime(), msg: "Hello World!"),
#    Message(username: "aru", time: getTime(), msg: "Testing")
#  ])
#end when
