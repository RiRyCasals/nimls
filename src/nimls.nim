import
  os,
  strutils,
  strformat,
  parseopt,
  nimlsutils,
  nimlsoptions


proc failureMessage(errorCause: string, errorCase: string): string =
  case errorCase:
    of "path":
      return fmt"nimls : '{$errorCause}' file or directory is not found."
    of "option":
      return fmt"nimls : '{$errorCause}' option is not defined."
    else:
      return fmt"nimls : Quit because an error occurred due to '{$errorCause}'."

proc nimlsHelp(): string =
  return """
  What is nimls :
      nimls implementation of the ls command in the Nim programming language.
      You can get files and directories name.

  Useage :
      nimls [option] [path]
  
  Default command:
      nimls ./

  Meta options :
      -?, --help      Show nimls document.

  Display options :
      -i, --info        Show file and directory detail.
      -p, --permission  Show file and directory permission.
      -r, --recurse     Recursively get files and directories name.
      -s, --size        Show file size.
      -t, --time        Show file and directory timestamp.

  Filtering options :
      -A, --all       Get hidden file and directory name.
      -D, --dir       Get directories name.
      -F, --file      Get files name.
  """

proc nimlsVersion(): string =
  return "Nimls : 0.1.0"

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
        if dirExists(key) or fileExists(key):
          arguments.path = key
        else:
          quit(failureMessage(key, "path"), QuitFailure)
      of cmdShortOption, cmdLongOption:
        case key:
          of "?", "help":
            quit(nimlsHelp(), QuitSuccess)
          of "!", "version":
            quit(nimlsVersion(), QuitSuccess)
          of "A", "all":
            arguments.isShowAll = true
          of "D", "dir":
            arguments.isShowDir = false
          of "F", "file":
            arguments.isShowFile = false
          of "i", "info":
            arguments.isShowInfo = true
          of "p", "permission":
            arguments.isShowPermission = true
          of "r", "recurse":
            arguments.isRecurse = true
          of "s", "size":
            arguments.isShowSize = true
          of "t", "time":
            arguments.isShowTime = true
          else:
            quit(failureMessage(key, "option"), QuitFailure)
      else:
        discard
  return arguments

# kindAndPath -> 名前変えたい
proc showPath(arguments: Arguments) =
  for kindAndPath in walkDir(arguments.path):
    if not arguments.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.isShowFile and kindAndPath.kind == pcFile:
      continue
    var info, permission, size, created_at, access_at, modified_at: string
    if arguments.isRecurse and kindAndPath.kind == pcDir:
      echo "\n", displayFormat(fmt"{$kindAndPath.kind}", $kindAndPath.path, info,
                         permission, size, created_at, access_at, modified_at)
      let nextDirArguments: Arguments = inheritanceArguments(kindAndPath.path,
                                                             arguments)
      showPath(nextDirArguments)
      echo ""
      continue
    if arguments.isShowInfo:
      info = getInfoString(kindAndPath.path)
    elif not arguments.isShowInfo:
      if arguments.isShowPermission:
        permission = getPermissionsString(kindAndPath.path)
      if arguments.isShowSize and kindAndPath.kind == pcFile:
        size = getFileSizeString(kindAndPath.path)
      if arguments.isShowTime:
        created_at = getCreationTimeString(kindAndPath.path)
        access_at = getLastAccessTimeString(kindAndPath.path)
        modified_at = getLastModificationTimeString(kindAndPath.path)
    echo displayFormat($kindAndPath.kind, $kindAndPath.path, info,
                       permission, size, created_at, access_at, modified_at)

when isMainModule:
  echo "==== getArguments test ===="
  var arguments: Arguments = getArguments()
  arguments.isShowAll= true
  arguments.isShowPermission = true
  arguments.isShowSize= true
  arguments.isShowTime= true
  echo arguments

  echo "==== current dir test ===="
  showPath(arguments)

  echo "==== file start test ===="
  arguments.path = "./testTest"
  #---> cmdから直接ファイルを受け取った場合反応がない(walkDir(path)のところ)
  showPath(arguments)

  arguments.path = "./testDir"
  echo "==== dir start test ===="
  showPath(arguments)

  arguments.isRecurse = true
  echo "==== dir start recurse test ===="
  showPath(arguments)
