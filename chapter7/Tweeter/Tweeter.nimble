# Package

version       = "0.1.0"
author        = "aruZeta"
description   = "A twitter clone made with nim"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["Tweeter"]

# Dependencies

requires("nim 1.6.6",
         "jester 0.5.0",
         "httpbeast 0.4.0",
         "tagger 0.2.0")
