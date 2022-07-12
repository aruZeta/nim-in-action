import threadpool
import locks

var counterLock: Lock
counterLock.initLock()
var counter {.guard: counterLock.} = 0

proc increment(x: int) =
  for i in 0 ..< x:
    var value = counter
    value.inc()
    counter = value

spawn increment(10_000)
spawn increment(10_000)
sync()

echo(counter)
