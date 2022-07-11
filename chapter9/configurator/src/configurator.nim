import macros

proc createRefType(ident: NimIdent, indentDefs: seq[NimNode]): NimNode =
  result = newTree(
    nnkTypeSection,
    newTree(
      nnkTypeDef,
      newIdentNode(ident),
      newEmptyNode(),
      newTree(
        nnkRefTy,
        newTree(
          nnkObjectTy,
          newEmptyNode(),
          newEmptyNode(),
          newTree(nnkRecList, indentDefs)
        )
      )
    )
  )

proc toIdentDefs(stmtList: NimNode): seq[NimNode] =
  expectKind(stmtList, nnkStmtList)
  result = @[]
  for child in stmtList:
    expectKind(child, nnkCall)
    result.add(
      newIdentDefs(
        child[0],
        child[1][0]
      )
    )

template constructor(ident: untyped): untyped =
  proc `new ident`(): `ident` =
    new result

proc createLoadProc(typeName: NimIdent, identDefs: seq[NimNode]): NimNode =
  var cfgIdent = newIdentNode("cfg")
  var filenameIdent = newIdentNode("filename")
  var objIdent = newIdentNode("obj")

  var body = newStmtList()
  body.add quote do:
    var `objIdent` = parseFile(`filenameIdent`)

  for identDef in identDefs:
    let fieldNameIdent = identDef[0]
    let fieldName = $fieldNameIdent.ident
    case $identDef[1].ident
    of "string":
      body.add quote do:
        `cfgIdent`.`fieldNameIdent` = `objIdent`[`fieldName`].getStr
    of "int":
      body.add quote do:
        `cfgIdent`.`fieldNameIdent` = `objIdent`[`fieldName`].getNum().int
    else:
      doAssert(false, "Not implemented")

  return newProc(
    newIdentNode("load"),
    [newEmptyNode(),
     newIdentDefs(cfgIdent, newIdentNode(typeName)),
     newIdentDefs(filenameIdent, newIdentNode("string"))
    ],
    body
  )

macro config*(typeName: untyped, fields: untyped): untyped =
  result = newStmtList()
  let identDefs = toIdentDefs(fields)
  result.add createRefType(typeName.ident, identDefs)
  result.add getAst(constructor(typeName.ident))
  result.add createLoadProc(typeName.ident, identDefs)

dumpTree:
  proc sum(a: int, b: int): int =
    a + b
