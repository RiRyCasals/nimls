import
  os,
  times,
  strutils

import nimlsutils


proc debugGetFileInfo(path: string): bool =
  let info = getFileInfo(path)
  echo path
  echo "getFileInfo type: ", info.type
  echo info

proc debugGetFilePermissions(path: string): bool =
  let permission = getFilePermissions(path)
  echo path
  echo "getFilePermissions type: ", permission.type
  echo permission

proc debugGetFileSize(path: string): bool =
  let size = getFileSize(path)
  echo path
  echo "getFileSize type: ", size.type
  echo size

proc debugGetCreationTime(path: string): bool =
  let creationTime = getCreationTime(path)
  echo path
  echo "getLastAccessTime type: ", creationTime.type
  echo creationTime

proc debugGetLastAccessTime(path: string): bool =
  let lastAccessTime = getLastAccessTime(path)
  echo path
  echo "getLastAccessTime type: ", lastAccessTime.type
  echo lastAccessTime

proc debugGetLastModificationTime(path: string): bool =
  let lastModificationTime = getLastModificationTime(path)
  echo path
  echo "getLastAccessTime type: ", lastModificationTime.type
  echo lastModificationTime

proc echoPath(arguments: Arguments): bool =
  for kindAndPath in walkDir(arguments.path):
  #==== filter options ====
    if arguments.isRecurse and kindAndPath.kind == pcDir:
      let nextDieArguments: Arguments = initArguments(kindAndPath.path)
      echo "\n d: " & $kindAndPath.path
      discard echoPath(nextDieArguments)
      continue
    if not arguments.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.isShowFile and kindAndPath.kind == pcFile:
      continue
  #==== display options ====
    var info, permission, created_at, access_at, modified_at = ""
    if arguments.isShowInfo:
      # getFileInfo(kindAndPath.path) を整形するproc
      echo "test"
  #== isShowInfo が true の場合 -p -s -t はパスする
    elif not arguments.isShowInfo:
      if arguments.isShowPermission:
        #getFilePermissions(kindAndPath.path) を整形するproc
        echo "test"
      if arguments.isShowSize and kindAndPath.kind != pcDir:
        #getFileSize(kindAndPath.path) を整形するproc
        echo "test"
      if arguments.isShowTime:
        #getCreationTime(kindAndPath.path) を整形するproc
        #getLastAccessTime(kindAndPath.path) を整形するproc
        #getLastModificationTime(kindAndPath.path) を整形するproc
        echo "test"
    echo $kindAndPath.kind & $kindAndPath.path & $info & $permission & $created_at & $access_at & $modified_at


when isMainModule:
  #[
  discard debugGetFileInfo("./testFile")
  echo "\n"
  discard debugGetFileInfo("./testDir")
  echo "\n"

  discard debugGetFilePermissions ("./testFile")
  echo "\n"
  discard debugGetFilePermissions ("./testDir")
  echo "\n"
  
  discard debugGetFileSize("./testFile") # can not directory
  echo "\n"

  discard debugGetCreationTime("./testFile")
  echo "\n"
  discard debugGetCreationTime("./testDir")
  echo "\n"

  discard debugGetLastAccessTime("./testFile")
  echo "\n"
  discard debugGetLastAccessTime("./testDir")
  echo "\n"

  discard debugGetLastModificationTime("./testFile")
  echo "\n"
  discard debugGetLastModificationTime("./testDir")
  echo "\n"
  ]#
  var arguments: Arguments = initArguments("./testFile")

  echo "file"
  discard echoPath(arguments) #---> cmdから直接ファイルを受け取った場合反応がない（waldDir(filePath)で止まるので)
  echo "\n"

  arguments.path = "./testDir"
  echo "Dir"
  discard echoPath(arguments)
  echo "\n"
