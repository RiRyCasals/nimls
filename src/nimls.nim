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
  return "Nimls : 0.0.0-develop"

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
            optionStatements.isShowDir = false
          of "F", "file":
            optionStatements.isShowFile = false
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
  let arguments: Arguments = initArguments(path, optionStatements)
  return arguments

# kindAndPath -> 名前変えたい
proc nimls(arguments: Arguments) =
  echo $arguments
  for kindAndPath in walkDir(arguments.path):
    echo $kindAndPath
    if not arguments.statements.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.statements.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.statements.isShowFile and kindAndPath.kind == pcFile:
      continue
    if arguments.statements.isRecurse and kindAndPath.kind == pcDir:
      echo displayFormat(kindAndPath.kind, kindAndPath.path, "")
      let nextDirArguments = initArguments(kindAndPath.path, arguments.statements)
      nimls(nextDirArguments)
      continue
    let information: string = getInformation(arguments)
    echo displayFormat(kindAndPath.kind, kindAndPath.path, information)

when isMainModule:
  let arguments: Arguments = getArguments()
  nimls(arguments)
