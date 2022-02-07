import
  os,
  times,
  strutils,
  strformat

import nimlsutils


proc getInfoString*(path: string): string =
  let info = getFileInfo(path)
  return fmt"{$info.linkCount}, {$info.blockSize}"

proc getPermissionsString*(path: string): string =
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
proc getFileSizeString*(path: string): string =
  let size = getFileSize(path)
  return $size

proc getCreationTimeString*(path: string): string =
  let creationTime = getCreationTime(path)
  return $creationTime

proc getLastAccessTimeString*(path: string): string =
  let lastAccessTime = getLastAccessTime(path)
  return $lastAccessTime

proc getLastModificationTimeString*(path: string): string =
  let lastModificationTime = getLastModificationTime(path)
  return $lastModificationTime

proc displayFormat*(kind, path, info, permission, size, created_at, access_at, modified_at: string): string =
  return fmt"{kind} {path} {info} {permission} {size} {created_at} {access_at} {modified_at}"


when isMainModule:
