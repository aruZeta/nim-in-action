import times
import db_sqlite
import strutils

type
  Database* = ref object
    db: DbConn

  User* = object
    username*: string
    following*: seq[string]

  Message* = object
    username*: string
    time*: Time
    msg*: string

# ------------------------------------------------------
proc newDB*(filename: string = "Tweeter.db"): Database =
  Database(db: open(filename, "", "", ""))

# -------------------------
proc setup*(db: Database) =
  db.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS User(
      username text PRIMARY KEY
    );
  """)

  db.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Following(
      follower text,
      followed_user text,
      PRIMARY KEY (follower, followed_user),
      FOREIGN KEY (follower) REFERENCES User(username),
      FOREIGN KEY (followed_user) REFERENCES User(username)
    );
  """)

  db.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Message(
      username text,
      time integer,
      msg text NOT NULL,
      FOREIGN KEY (username) REFERENCES User(username)
    );
  """)

# -------------------------
proc close*(db: Database) =
  db.db.close()

# --------------------------------------
proc post*(db: Database, msg: Message) =
  if msg.msg.len() > 140:
    raise newException(
      ValueError,
      "Message has to be less than 140 characteres."
    )

  db.db.exec(
    sql"INSERT INTO Message VALUES (?, ?, ?);",
    msg.username, $msg.time.toUnix, msg.msg
  )

# ------------------------------------------------------
proc follow*(db: Database, follower: var User, user: User) =
  db.db.exec(
    sql"INSERT INTO Following VALUES (?, ?);",
    follower.username, user.username
  )

  follower.following.add(user.username)

# --------------------------------------
proc create*(db: Database, user: User) =
  db.db.exec(
    sql"INSERT INTO User VALUES (?);",
    user.username
  )

# --------------------------------------------------------------------
proc findUser*(db: Database, username: string, user: var User): bool =
  let row = db.db.getRow(
    sql"SELECT username FROM User WHERE username = ?;",
    username
  )

  if row[0].len() == 0:
    return false
  else:
    user.username = row[0]

  let following = db.db.getAllRows(
    sql"SELECT followed_user FROM Following WHERE follower = ?;",
    username
  )
  user.following = @[]
  for row in following:
    if row[0].len() != 0:
      user.following.add(row[0])

  return true

# ----------------------------------------
proc findMessages*(db: Database,
                   usernames: seq[string],
                   limit: int = 10
                  ): seq[Message] =
  result = @[]

  if usernames.len() == 0:
    return

  var whereClause = " WHERE "
  for i in 0 ..< usernames.len():
    whereClause.add("username = ? ")
    if i != usernames.len() - 1:
      whereClause.add("or ")

  let msgs = db.db.getAllRows(
    sql(
      "SELECT username, time, msg FROM Message" &
      whereClause &
      "ORDER BY time DESC LIMIT " & $limit
    ),
    usernames
  )
  for row in msgs:
    result.add(Message(
      username: row[0],
      time: row[1].parseInt.fromUnix(),
      msg: row[2]
    ))
