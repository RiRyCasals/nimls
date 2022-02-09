import
  os,
  times,
  strformat,
  utils

const readPermission = 4
const writePermission = 2
const execPermission = 1


proc displayFormat*(kind: PathComponent, path, information: string = ""): string =
  var displayKind: string
  case kind:
    of pcFile:
      displayKind = " f"
    of pcDir:
      displayKind = " d"
    of pcLinkToFile:
      displayKind = "lf"
    of pcLinkToDir:
      displayKind = "ld"
  return fmt"{displayKind} {information} {path}"

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

proc getInformation*(arguments: Arguments): string =
  let information = getFileInfo(arguments.path)
  var info, permission, size, modified_at, access_at, created_at: string
  if arguments.statements.isShowInfo:
    #id?, linkCount, blockSize
    info = $information.blockSize
    modified_at = $information.lastWriteTime.format("yy/MM/dd-HH:mm")
  if arguments.statements.isShowpermission:
    permission = convertPermission(information.permissions)
  if arguments.statements.isShowsize:
    size = $information.size
  if arguments.statements.isShowtime:
    modified_at = $information.lastWriteTime.format("yy/MM/dd(ddd)-HH:mm:ss")
    access_at = $information.lastAccessTime.format("yy/MM/dd(ddd)-HH:mm:ss")
    created_at = $information.creationTime.format("yy/MM/dd(ddd)-HH:mm:ss")
  return fmt"{permission}  {size}  {info}  {modified_at}  {access_at}  {created_at}"


when isMainModule:
  var optionStatements: OptionStatements = initOptionStatements()
  optionStatements.isShowInfo = true
  optionStatements.isShowpermission = true
  optionStatements.isShowsize = true
  optionStatements.isShowTime = true
  let arguments: Arguments = initArguments(path="./testFile", optionStatements)
  echo displayFormat(pcFile, arguments.path, getInformation(arguments))
