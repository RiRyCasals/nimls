import
  os,
  strutils,
  parseopt

import nimlsutils


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
  var arguments: Arguments = defaultArguments()
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

when isMainModule:
  let arguments: Arguments = getArguments()
  echo arguments
