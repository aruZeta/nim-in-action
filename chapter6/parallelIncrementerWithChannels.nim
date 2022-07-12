import threadpool

var resultChan: Channel[int]
resultChan.open()

proc increment(x: int) =
  var counter = 0
  for i in 0 ..< x:
    counter.inc()
  resultChan.send(counter)

spawn increment(10_000)
spawn increment(10_000)
sync()

var total = 0
for i in 0 ..< resultChan.peek:
  total.inc resultChan.recv()

echo(total)
