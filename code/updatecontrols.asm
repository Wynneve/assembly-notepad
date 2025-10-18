.code

UpdateControls proc
    enter 20h, 0

    ; CalculateLines()
    call CalculateLines
    ; ResizeControls()
    call ResizeControls
    ; FillLines()
    call FillLines

    leave
    ret
UpdateControls endp