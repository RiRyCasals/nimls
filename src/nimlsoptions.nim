import
  os,
  times,
  strutils

import nimlsutils


proc debugGetFileInfo(path: string) =
  let info = getFileInfo(path)
  echo path
  echo "getFileInfo type: ", info.type
  echo info

proc getFileInfoString(path: string): string =
  let info = getFileInfo(path)
  return $info

proc debugGetFilePermissions(path: string) =
  let permission = getFilePermissions(path)
  echo path
  echo "getFilePermissions type: ", permission.type
  echo permission

proc getFilePermissionsString(path: string): string =
  let permissions = getFilePermissions(path)
  var userBit: uint8 = 0
  var groupBit: uint8 = 0
  var othersBit: uint8 = 0
  for permission in permissions:
    case permission:
      of fpUserRead:
        userBit = userBit or 4
      of fpUserWrite:
        userBit = userBit or 2
      of fpUserExec:
        userBit = userBit or 1
      of fpGroupRead:
        groupBit = groupBit or 4
      of fpGroupWrite:
        groupBit = groupBit or 2
      of fpGroupExec:
        groupBit = groupBit or 1
      of fpOthersRead:
        othersBit = othersBit or 4
      of fpOthersWrite:
        othersBit = othersBit or 2
      of fpOthersExec:
        othersBit = othersBit or 1
  return $userBit & $groupBit & $othersBit

proc debugGetFileSize(path: string) =
  let size = getFileSize(path)
  echo path
  echo "getFileSize type: ", size.type
  echo size

proc debugGetCreationTime(path: string) =
  let creationTime = getCreationTime(path)
  echo path
  echo "getLastAccessTime type: ", creationTime.type
  echo creationTime

proc debugGetLastAccessTime(path: string) =
  let lastAccessTime = getLastAccessTime(path)
  echo path
  echo "getLastAccessTime type: ", lastAccessTime.type
  echo lastAccessTime

proc debugGetLastModificationTime(path: string) =
  let lastModificationTime = getLastModificationTime(path)
  echo path
  echo "getLastAccessTime type: ", lastModificationTime.type
  echo lastModificationTime

proc echoPath(arguments: Arguments) =
  for kindAndPath in walkDir(arguments.path):
  #==== filter options ====
    if arguments.isRecurse and kindAndPath.kind == pcDir:
      let nextDieArguments: Arguments = initArguments(kindAndPath.path)
      echo "\n d: " & $kindAndPath.path
      echoPath(nextDieArguments)
      continue
    if not arguments.isShowAll and kindAndPath.path.contains("/."):
      continue
    if not arguments.isShowDir and kindAndPath.kind == pcDir:
      continue
    if not arguments.isShowFile and kindAndPath.kind == pcFile:
      continue
  #==== display options ====
    var info, permission, created_at, access_at, modified_at: string
    if arguments.isShowInfo:
      # getFileInfo(kindAndPath.path) を整形するproc
      echo "test"
    if arguments.isShowPermission:
      permission = getFilePermissionsstring(kindAndPath.path)
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
  echo "\n"

#[
  debugGetFileInfo("./testFile")
  echo "\n"

  debugGetFileInfo("./testDir")
  echo "\n"

  debugGetFilePermissions ("./testFile")
  echo "\n"
  debugGetFilePermissions ("./testDir")
  echo "\n"
  
  echo "file"
  echo getFilePermissionsString("./testFile")
  echo "\n"

  echo "dir"
  echo getFilePermissionsString("./testDir")
  echo "\n"

  debugGetFileSize("./testFile") # can not directory
  echo "\n"

  debugGetCreationTime("./testFile")
  echo "\n"
  debugGetCreationTime("./testDir")
  echo "\n"

  debugGetLastAccessTime("./testFile")
  echo "\n"
  debugGetLastAccessTime("./testDir")
  echo "\n"

  discard debugGetLastModificationTime("./testFile")
  echo "\n"
  debugGetLastModificationTime("./testDir")
  echo "\n"
]#

  var arguments: Arguments = initArguments("./testFile")
  arguments.isShowPermission = true

  echo "file"
  echoPath(arguments) #---> cmdから直接ファイルを受け取った場合反応がない（waldDir(filePath)で止まるので)
  echo "\n"

  arguments.path = "./testDir"
  echo "Dir"
  echoPath(arguments)
  echo "\n"
#[
]#
