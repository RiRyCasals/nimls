import
  os,
  times,
  strformat,
  nimlsutils

const readPermission = 4
const writePermission = 2
const execPermission = 1


proc displayFormat*(kind: PathComponent, path, information: string = ""): string =
  var displayKind: string
  #kindの種類ごとに表示用文字に変換
  case kind:
    of pcFile:
      displayKind = " f"
    of pcDir:
      displayKind = " d"
    of pcLinkToFile:
      displayKind = "lf"
    of pcLinkToDir:
      displayKind = "ld"
  return &"{displayKind}:{path} \t {information}"

proc convertPermission*(permissions: set[FilePermission]): string =
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
  return fmt"{user}{group}{others}"

proc getInfoString*(path: string): string =
  let info = getFileInfo(path)
  return fmt"{$info.linkCount}, {$info.blockSize}"

# getFileInfo から取得に変更？ -> 変更決定
proc getPermissionsString*(path: string): string =
  let permissions = getFilePermissions(path)
  return $convertPermission(permissions)

# getFileInfo から取得に変更？ -> 変更決定
# can not get directory size
proc getFileSizeString*(path: string): string =
  let size = getFileSize(path)
  return $size

# getFileInfo から取得に変更？ -> 変更決定
proc getCreationTimeString*(path: string): string =
  let creationTime = getCreationTime(path)
  return $creationTime

# getFileInfo から取得に変更？ -> 変更決定
proc getLastAccessTimeString*(path: string): string =
  let lastAccessTime = getLastAccessTime(path)
  return $lastAccessTime

# getFileInfo から取得に変更？ -> 変更決定
proc getLastModificationTimeString*(path: string): string =
  let lastModificationTime = getLastModificationTime(path)
  return $lastModificationTime

proc getInformation*(arguments: Arguments): string =
  let information = getFileInfo(arguments.path)
  var info, permission, size, modified_at, access_at, created_at: string
  if arguments.isShowInfo:
    #id?, linkCount, blockSize
    info = $information.blockSize
    modified_at = $information.lastWriteTime.format("yy/MM/dd-HH:mm")
  if arguments.isShowpermission:
    permission = convertPermission(information.permissions)
  if arguments.isShowsize:
    size = $information.size
  if arguments.isShowtime:
    modified_at = $information.lastWriteTime.format("yy/MM/dd(ddd)-HH:mm:ss")
    access_at = $information.lastAccessTime.format("yy/MM/dd(ddd)-HH:mm:ss")
    created_at = $information.creationTime.format("yy/MM/dd(ddd)-HH:mm:ss")
  return fmt"{permission}  {size}  {info}  {modified_at}  {access_at}  {created_at}"


when isMainModule:
  let arguments: Arguments = initArguments(path="./testFile",
                                           isShowInfo=true,
                                           isShowpermission=true,
                                           isShowsize=true,
                                           isShowTime=true)
  echo displayFormat(pcFile, "./testFile", getInformation(arguments))
