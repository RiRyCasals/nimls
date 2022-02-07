type
  Arguments* = tuple
    path: string
    isShowAll: bool
    isShowDir: bool
    isShowFile: bool
    isRecurse: bool
    isShowInfo: bool
    isShowPermission: bool
    isShowSize: bool
    isShowTime: bool


proc initArguments*(path: string = "./",
                    isShowAll: bool = false,
                    isShowDir: bool = true,
                    isShowFile: bool = true,
                    isRecurse: bool = false,
                    isShowInfo: bool = false,
                    isShowPermission: bool = false,
                    isShowSize: bool = false,
                    isShowTime: bool = false): Arguments =
  let arguments: Arguments = (path: path,
                              isShowAll: isShowAll,
                              isShowDir: isShowDir,
                              isShowFile: isShowFile,
                              isRecurse: isRecurse,
                              isShowInfo: isShowInfo,
                              isShowPermission: isShowPermission,
                              isShowSize: isShowSize,
                              isShowTime: isShowTime)
  return arguments

# 親ディレクトリの arguments.path を保持したまま 再起できるようにするため
proc inheritanceArguments*(path: string = "./",
                           arguments: Arguments): Arguments =
  let arguments: Arguments = (path: path,
                              isShowAll: arguments.isShowAll,
                              isShowDir: arguments.isShowDir,
                              isShowFile: arguments.isShowFile,
                              isRecurse: arguments.isRecurse,
                              isShowInfo: arguments.isShowInfo,
                              isShowPermission: arguments.isShowPermission,
                              isShowSize: arguments.isShowSize,
                              isShowTime: arguments.isShowTime)
  return arguments


when isMainModule:
  let arguments: Arguments = initArguments()
  echo "type: ", arguments.type
  echo "default arguments: ", arguments

  let newArguments: Arguments = inheritanceArguments("./testFile", arguments)
  echo "type new : ", newArguments.type
  echo "default arguments new: ", newArguments
