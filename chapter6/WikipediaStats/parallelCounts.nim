import os
import parseutils
import strutils
import threadpool

type
  Stats = ref object
    domainCode, pageTitle: string
    countViews, totalSize: int

proc newStats(): Stats =
  Stats(
    domainCode: "",
    pageTitle: "",
    countViews: 0,
    totalSize: 0
  )

proc `$`(stats: Stats): string =
  "($#, $#, $#, $#)" % [
    stats.domainCode, stats.pageTitle, $stats.countViews, $stats.totalSize
  ]

proc parse(line: string,
           domainCode, pageTitle: var string,
           countViews, totalSize: var int) =
  var i = 0

  domainCode.setLen(0)
  i.inc line.parseUntil(domainCode, {' '}, i)
  i.inc()

  pageTitle.setLen(0)
  i.inc line.parseUntil(pageTitle, {' '}, i)
  i.inc

  countViews = 0
  i.inc line.parseInt(countViews, i)
  i.inc

  totalSize = 0
  i.inc line.parseInt(totalSize, i)

proc parseChunk(chunk: string): Stats =
  result = newStats()
  var domainCode, pageTitle: string
  var countViews, totalSize: int
  for line in chunk.splitLines():
    line.parse(domainCode, pageTitle, countViews, totalSize)
    if domainCode == "en" and countViews > result.countViews:
      result = Stats(
        domainCode: domainCode,
        pageTitle: pageTitle,
        countViews: countViews,
        totalSize: totalSize
      )

proc readPageCounts(filename: string, chunkSize = 1_000_000) =
  var file = open(filename)
  var responses = newSeq[FlowVar[Stats]]()
  var buffer = newString(chunkSize)
  var oldBufferLen = 0

  while not endOfFile(file):
    let reqSize = chunkSize - oldBufferLen
    let readSize = file.readChars(buffer, oldBufferLen, reqSize) + oldBufferLen
    var chunkLen = readSize

    while chunkLen >= 0 and buffer[chunkLen - 1] notin NewLines:
      chunkLen.dec()

    responses.add(spawn parseChunk(buffer[0 .. < chunkLen]))
    oldBufferLen = readSize - chunkLen
    buffer[0 .. < oldBufferLen] = buffer[readSize - oldBufferLen .. ^1]

  var mostPopular = newStats()
  for resp in responses:
    let statistic = ^resp
    if statistic.countViews > mostPopular.countViews:
      mostPopular = statistic

  echo("Most popular is: ", mostPopular)
  file.close()

when isMainModule:
  const file = "pagecounts-20160101-050000"
  let filename = getCurrentDir() / file
  readPageCounts(filename)
