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


proc defaultArguments*(): Arguments =
  let arguments: Arguments = (path: "./",
                              isShowAll: false,
                              isShowDir: true,
                              isShowFile: true,
                              isRecurse: false,
                              isShowInfo: false,
                              isShowPermission: false,
                              isShowSize: false,
                              isShowTime: false)
  return arguments

when isMainModule:
  let arguments: Arguments = defaultArguments()
  echo "type: ", arguments.type
  echo "default arguments: ", arguments
