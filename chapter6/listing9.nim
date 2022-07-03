import parseutils

var line = "en Nim_(programming_language) 1 70231"

var i = 0

var domainCode = ""
i.inc line.parseUntil(domainCode, {' '}, i)
i.inc()

var pageTitle = ""
i.inc line.parseUntil(pageTitle, {' '}, i)
i.inc()

var countViews = 0
i.inc line.parseInt(countViews, i)
i.inc()

var totalSize = 0
i.inc line.parseInt(totalSize, i)

doAssert domainCode == "en"
doAssert pageTitle == "Nim_(programming_language)"
doAssert countViews == 1
doAssert totalSize == 70231
echo("Parsed successfully!")

