import
  os,
  times,
  strformat

const readPermission = 4
const writePermission = 2
const execPermission = 1

proc displayFormat*(kind, path, info, permission, size, created_at, access_at, modified_at: string): string =
  return fmt"{kind} {path} {info} {permission} {size} {created_at} {access_at} {modified_at}"

proc convertPermissionToNumber*(permissions: set[FilePermission]): int =
  var user, group, others: int
  for permission in permissions:
    case permission:
      of fpUserRead:
        user = user or readPermission
      of fpUserWrite:
        user = user or writePermission
      of fpUserExec:
        user = user or execPermission
      of fpGroupRead:
        group = group or readPermission
      of fpGroupWrite:
        group = group or writePermission
      of fpGroupExec:
        group = group or execPermission
      of fpOthersRead:
        others = others or readPermission
      of fpOthersWrite:
        others = others or writePermission
      of fpOthersExec:
        others = others or execPermission
  return user * 100 +  group * 10 + others

proc getInfoString*(path: string): string =
  let info = getFileInfo(path)
  return fmt"{$info.linkCount}, {$info.blockSize}"

proc getPermissionsString*(path: string): string =
  let permissions = getFilePermissions(path)
  return $convertPermissionToNumber(permissions)

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


when isMainModule:
  echo "test format: ", displayFormat("kind", "path", "info", "permission", "size", "created_at", "access_at", "modified_at")
  echo "dir  info: ", getInfoString("./testDir")
  echo "file info: ", getInfoString("./testFile")
  echo "dir  permission: ", getPermissionsString("./testDir")
  echo "file permission: ", getPermissionsString("./testFile")
  echo "file size: ", getFileSizeString("./testFile")
  echo "dir  created_at: ", getCreationTimeString("./testDir")
  echo "file created_at: ", getCreationTimeString("./testFile")
  echo "dir  access_at: ", getLastAccessTimeString("./testDir")
  echo "file access_at: ", getLastAccessTimeString("./testFile")
  echo "dir  modified_at: ", getLastModificationTimeString("./testDir")
  echo "file modified_at: ", getLastModificationTimeString("./testFile")
