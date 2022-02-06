import
  os,
  strutils,
  parseopt

import nimlsutils

when isMainModule:
  let arguments: Arguments = defaultArguments()
  echo arguments
