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
      -i, --info        Show file and directory detail. (Detail: -ps options and edit date time)
      -p, --permission  Show file and directory permission.
      -r, --recurse     Recursively get files and directories name.
      -s, --size        Show file byte size.
      -t, --time        Show file and directory timestamp. (edit, access and create date time)

  Filtering options :
      -A, --all       Get hidden file and directory name.
      -D, --dir       Get directories name.
      -F, --file      Get files name.
  """

proc nimlsVersion(): string =
  return "Nimls : 0.1.0"

proc getArguments(): Arguments =
  var optionStatements: OptionStatements = initOptionStatements()
  var path: string = "./"
  var parserOption = initOptParser(commandLineParams().join(" "))
  for kind, key, value in parserOption.getOpt():
    case kind:
      of cmdArgument:
        if dirExists(key) or fileExists(key):
          path = key
        else:
          quit(failureMessage(key, "path"), QuitFailure)
      of cmdShortOption, cmdLongOption:
        case key:
          of "?", "help":
            quit(nimlsHelp(), QuitSuccess)
          of "!", "version":
            quit(nimlsVersion(), QuitSuccess)
          of "A", "all":
            optionStatements.isShowAll = true
          of "D", "dir":
            optionStatements.isShowDir = true
          of "F", "file":
            optionStatements.isShowFile = true
          of "i", "info":
            optionStatements.isShowInfo = true
            optionStatements.isShowPermission = true
            optionStatements.isShowSize = true
          of "p", "permission":
            optionStatements.isShowPermission = true
          of "r", "recurse":
            optionStatements.isRecurse = true
          of "s", "size":
            optionStatements.isShowSize = true
          of "t", "time":
            optionStatements.isShowTime = true
          else:
            quit(failureMessage(key, "option"), QuitFailure)
      else:
        discard
  if not(optionStatements.isShowFile or optionStatements.isShowDir):
    optionStatements.isShowFile = true
    optionStatements.isShowDir = true
  let arguments: Arguments = initArguments(path, optionStatements)
  return arguments

# kindAndPath -> 名前変えたい
proc nimls(arguments: Arguments) =
  for kindAndPath in walkDir(arguments.path):
    if not arguments.statements.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.statements.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.statements.isShowFile and kindAndPath.kind == pcFile:
      continue
    if arguments.statements.isRecurse and kindAndPath.kind == pcDir:
      echo displayFormat(kindAndPath.kind, kindAndPath.path & ":", "")
      let nextDirArguments = initArguments(kindAndPath.path, arguments.statements)
      nimls(nextDirArguments)
      echo ""
      continue
    let information: string = getInformation(arguments)
    echo displayFormat(kindAndPath.kind, kindAndPath.path, information)

when isMainModule:
  let arguments: Arguments = getArguments()
  nimls(arguments)
