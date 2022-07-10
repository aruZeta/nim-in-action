type
  CTime = int64
  TM {.importc: "struct tm",
       header: "<time.h>".} = object
    tm_min: cint
    tm_hour: cint

proc time(arg: ptr CTime): CTime {.importc,
                                   header: "<time.h>".}

proc localtime(time: ptr CTime): ptr TM {.importc,
                                           header: "<time.h>".}

var seconds = time(nil)
let tm = localtime(addr seconds)
echo(tm.tm_hour, ":", tm.tm_min)
