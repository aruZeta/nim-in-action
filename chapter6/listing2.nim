var data = "Hello World"

type ThreadData = tuple[param: string, param2: int]

proc showData(data: ThreadData) {.thread.} =
  echo(data.param)

var thread: Thread[ThreadData]
createThread[ThreadData](thread, showData, (param: data, param2: 10))
joinThread(thread)
