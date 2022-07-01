import threadpool

proc crash(): string =
  raise newException(Exception, "Crash")

let crashFlowVar: FlowVar[string] = spawn crash()
sync()
