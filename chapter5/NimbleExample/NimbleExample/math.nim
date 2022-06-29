import bigints

proc add*(a, b: int): int = a + b
proc add*(a, b: BigInt): BigInt = a + b

when isMainModule:
  block:
    doAssert add(1, 2) == 3
    doAssert add(1, -1) == 0
    doAssert add(-2, 1) == -1

  block:
    doAssert add(
      initBigInt("99999999999999999999"),
      initBigInt("99999999999999999999")
    ) == initBigInt("199999999999999999998")
