@echo off
call settings

IF "%test_rsync%" EQU "off" (
  set _t_norsync=TRUE
) ELSE (
  set _t_norsync=FALSE
)
IF "%test_pause%" EQU "off" (
  set _t_pause=FALSE
) ELSE (
  set _t_pause=TRUE
)

:parse
if "%1" EQU "" (
    goto :eof
)

IF "%1" EQU "norsync" (
  set _t_norsync=TRUE
  goto :parse_next
)

IF "%1" EQU "rsync" (
  set _t_norsync=FALSE
  goto :parse_next
)

IF "%1" EQU "nopause" (
  set _t_pause=FALSE
  goto :parse_next
)

IF "%1" EQU "pause" (
  set _t_pause=TRUE
  goto :parse_next
)

:parse_next
shift
goto :parse