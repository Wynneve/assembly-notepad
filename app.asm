option casemap:none

; requirements
include include/lib.asm
include include/extern.asm

; data includes
.data
    include data/constants.asm
    include data/types.asm

    include data/structs/wndclass.asm
    include data/structs/point.asm
    include data/structs/msg.asm
    include data/structs/rect.asm
    include data/structs/scrollinfo.asm
    include data/structs/textmetric.asm
    include data/structs/openfilename.asm
    include data/structs/logfont.asm
    include data/structs/choosefont.asm
    include data/global.asm

; procedures
include code/countdigits.asm
include code/calculatelines.asm
include code/resizecontrols.asm
include code/numbertostring.asm
include code/filllines.asm
include code/updatecontrols.asm
include code/changefont.asm
include code/readfiletoedit.asm
include code/writefilefromedit.asm
include code/updatewindowname.asm

include code/editwndproc.asm
include code/wndproc.asm

; main procedure
include code/winmain.asm

end