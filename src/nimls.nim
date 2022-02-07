import
  # standard libraries
  os,
  strutils,
  parseopt,
  # original libraries for nimls
  nimlsutils,
  nimlsoptions


proc failureMessage(errorCause: string, errorCase: string): string =
  case errorCase:
    of "path":
      return "nimls : '" & $errorCause & "' file or directory is not found."
    of "option":
      return "nimls : '" & $errorCause & "' option is not defined."
    else:
      return "nimls : Quit because an error occurred due to '" & $errorCause & "'."

proc nimlsHelp(): string =
  return "nimls"

proc nimlsVersion(): string =
  return "Nimls : 0.0.1"

proc debugShowInputArguments(kind: CmdLineKind, key, value: string): bool =
  echo "kind : ", kind
  echo "key : ", key
  echo "value : ", value

proc getArguments(): Arguments =
  var arguments: Arguments = initArguments()
  var parserOption = initOptParser(commandLineParams().join(" "))
  for kind, key, value in parserOption.getOpt():
    discard debugShowInputArguments(kind, key, value)
    case kind:
      of cmdArgument:
        if fileExists(key) or dirExists(key):
          arguments.path = key
        else:
          quit(failureMessage(key, "path"), QuitFailure)
      of cmdShortOption, cmdLongOption:
        case key:
          of "?", "help":
            quit(nimlsHelp(), QuitSuccess)
          of "!", "version":
            quit(nimlsVersion(), QuitSuccess)
          of "a", "all":
            arguments.isShowAll = false
          of "d", "dir":
            arguments.isShowDir = true
          of "f", "file":
            arguments.isShowFile = true
          of "r", "recurse":
            arguments.isRecurse = false
          of "i", "info":
            arguments.isShowInfo = false
          of "p", "permission":
            arguments.isShowPermission = false
          of "s", "size":
            arguments.isShowSize = false
          of "t", "time":
            arguments.isShowTime = false
          else:
            quit(failureMessage(key, "option"), QuitFailure)
      else:
        discard
  return arguments

proc echoPath(arguments: Arguments) =
  for kindAndPath in walkDir(arguments.path):
  #==== filter options ====
    if not arguments.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.isShowFile and kindAndPath.kind == pcFile:
      continue
    if arguments.isRecurse and kindAndPath.kind == pcDir:
      let nextDieArguments: Arguments = initArguments(kindAndPath.path)
      echo "\n d: " & $kindAndPath.path
      echoPath(nextDieArguments)
      continue
  #==== display options ====
    var info, permission, size, created_at, access_at, modified_at: string
    if arguments.isShowInfo:
      info = getInfoString(kindAndPath.path)
    if arguments.isShowPermission:
      permission = getPermissionsString(kindAndPath.path)
    if arguments.isShowSize and kindAndPath.kind == pcFile:
      size = getFileSizeString(kindAndPath.path)
    if arguments.isShowTime:
      created_at = getCreationTimeString(kindAndPath.path)
      access_at = getLastAccessTimeString(kindAndPath.path)
      modified_at = getLastModificationTimeString(kindAndPath.path)
    echo displayFormat($kindAndPath.kind, $kindAndPath.path, info, permission, size, created_at, access_at, modified_at)

when isMainModule:
  let arguments: Arguments = getArguments()
  echo arguments

  var arguments: Arguments = initArguments("./testFile")
  arguments.isShowAll= true
  arguments.isShowAll= true
  arguments.isShowPermission = true
  arguments.isShowSize= true
  arguments.isShowTime= true

  echo "file"
  echoPath(arguments) #---> cmdから直接ファイルを受け取った場合反応がない（waldDir(filePath)で止まるので)
  echo "\n"

  arguments.path = "./testDir"
  echo "Dir"
  echoPath(arguments)
  echo "\n"

  arguments.isRecurse = true
  echo "Dir"
  echoPath(arguments)
  echo "\n"
