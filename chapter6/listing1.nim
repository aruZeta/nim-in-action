var data = "Hello World"

proc showData(param: string) {.thread.} =
  echo(param)

var thread: Thread[string]
createThread[string](thread, showData, data)
joinThread(thread)
