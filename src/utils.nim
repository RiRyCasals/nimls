type
  OptionStatements* = tuple
    isShowAll: bool
    isShowDir: bool
    isShowFile: bool
    isRecurse: bool
    isShowInfo: bool
    isShowPermission: bool
    isShowSize: bool
    isShowTime: bool

  Arguments* = object
    path*: string
    statements*: OptionStatements

  ErrorCase* = enum
    notFoundPath,
    notDefinedOption


proc initOptionStatements*(): OptionStatements =
  let optionStatements: OptionStatements = (
    isShowAll: false,
    isShowDir: false,
    isShowFile: false,
    isRecurse: false,
    isShowInfo: false,
    isShowPermission: false,
    isShowSize: false,
    isShowTime: false
  )
  return optionStatements

proc initArguments*(path: string, optionStatements: OptionStatements): Arguments =
  var arguments: Arguments
  arguments.path = path
  arguments.statements = optionStatements
  return arguments

when isMainModule:
  let optionStatements: OptionStatements = initOptionStatements()
  echo "type: ", optionStatements.type
  echo "default statements: ", optionStatements 

  let arguments: Arguments = initArguments("./", optionStatements)
  echo "type: ", arguments.type
  echo "default arguments: ", arguments 
