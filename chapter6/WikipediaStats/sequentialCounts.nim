import os
import parseutils

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

proc readPageCounts(filename: string) =
  var domainCode, pageTitle: string
  var countViews, totalSize: int
  var mostPopular = ("", "", 0, 0)
  for line in filename.lines:
    line.parse(domainCode, pageTitle, countViews, totalSize)
    if domainCode == "en" and countViews > mostPopular[2]:
      mostPopular = (domainCode, pageTitle, countViews, totalSize)
  echo("Most popular is: ", mostPopular)

when isMainModule:
  const file = "pagecounts-20160101-050000"
  let filename = currentSourcePath.parentDir() / file
  readPageCounts(filename)
