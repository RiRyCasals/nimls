import
  os,
  times,
  strutils,
  strformat

import nimlsutils


proc getInfoString(path: string): string =
  let info = getFileInfo(path)
  return fmt"{$info.linkCount}, {$info.blockSize}"


proc getPermissionsString(path: string): string =
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

# can not get directory size
proc getFileSizeString(path: string): string =
  let size = getFileSize(path)
  return $size

proc getCreationTimeString(path: string): string =
  let creationTime = getCreationTime(path)
  return $creationTime

proc getLastAccessTimeString(path: string): string =
  let lastAccessTime = getLastAccessTime(path)
  return $lastAccessTime

proc getLastModificationTimeString(path: string): string =
  let lastModificationTime = getLastModificationTime(path)
  return $lastModificationTime

proc echoStringFormat(kind, path, info, permission, size, created_at, access_at, modified_at: string): string =
  return fmt"{kind} {path} {info} {permission} {size} {created_at} {access_at} {modified_at}"

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
    echo echoStringFormat($kindAndPath.kind, $kindAndPath.path, info, permission, size, created_at, access_at, modified_at)


when isMainModule:
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
