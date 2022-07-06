# Package

version       = "0.1.0"
author        = "aru-hackZ"
description   = "A twitter clone made with nim"
license       = "GPL-3.0"
srcDir        = "src"
bin           = @["Tweeter"]

# Dependencies

requires("nim 1.0.6",
         "jester 0.5.0",
         "httpbeast 0.4.0")
