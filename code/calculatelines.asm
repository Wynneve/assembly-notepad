.code

CalculateLines proc
    ; form stack frame
    enter 60h, 0

    ; save variables
    mov [rsp+20h], rcx ; volatile
    mov [rsp+28h], rdx
    mov [rsp+30h], r8
    mov [rsp+38h], r9
    mov [rsp+40h], r12 ; saved
    mov [rsp+48h], r13
    mov [rsp+50h], r14
    mov [rsp+58h], r15

    ; editPrevFirstLine = editFirstLine
    mov eax, [editFirstLine]
    mov [editPrevFirstLine], eax

    ; GetScrollInfo(hEdit, SB_VERT, &editScrollInfo)
    mov rcx, [hEdit]
    mov rdx, SB_VERT
    mov r8, offset editScrollInfo

    call GetScrollInfo

    ; editFirstLine = editScrollInfo.nTrackPos + 1
    mov eax, [editScrollInfo.nTrackPos]
    add eax, 1
    mov [editFirstLine], eax

    ; hFont = SendMessageA(hEdit, WM_GETFONT, 0, 0)
    mov rcx, [hEdit]
    mov rdx, WM_GETFONT
    mov r8, 0
    mov r9, 0

    call SendMessageA
    mov r12, rax ; r12 = hFont
    
    ; hdc = GetDC(hEdit)
    mov rcx, [hEdit]

    call GetDC
    mov r13, rax ; r13 = hdc

    ; SelectObject(hdc, hFont)
    mov rcx, r13
    mov rdx, r12

    call SelectObject

    ; GetTextMetricsA(hdc, &editTextMetric)
    mov rcx, r13
    mov rdx, offset editTextMetric

    call GetTextMetricsA

    ; editLineWidth = editTextMetric.tmAveCharWidth
    mov eax, [editTextMetric.tmAveCharWidth]
    mov [editLineWidth], eax
    
    ; editLineHeight = editTextMetric.tmHeight
    mov eax, [editTextMetric.tmHeight]
    mov [editLineHeight], eax 

    ; ReleaseDC(hEdit, hdc)
    mov rcx, hEdit
    mov rdx, r13

    call ReleaseDC

    ; SendMessageA(hEdit, EM_GETRECT, 0, &editClientArea)
    mov rcx, [hEdit]
    mov rdx, EM_GETRECT
    mov r8, 0
    mov r9, offset editClientArea

    call SendMessageA

    ; int editHeight = editClientArea.bottom - editClientArea.top
    mov r14d, [editClientArea.bottom]
    mov r15d, [editClientArea.top]
    sub r14d, r15d

    ; (rax) = linesCount = ceil(editHeight / editLineHeight)
    mov rdx, 0
    mov rax, r14
    div [editLineHeight]
    
    cmp rdx,     0
    mov edx,     1
    mov r15d,    0
    cmovne r15d, edx
    add eax, r15d
    mov [linesCount], eax

    ; editPrevLastLine = editLastLine
    mov r14d, [editLastLine]
    mov [editPrevLastLine], r14d

    ; editLastLine = editFirstLine + linesCount - 1
    mov r15d, [editFirstLine]
    add r15d, eax
    sub r15d, 1
    mov [editLastLine], r15d

    ; restore variables
    mov rcx, [rsp+20h] ; volatile
    mov rdx, [rsp+28h]
    mov r8,  [rsp+30h]
    mov r9,  [rsp+38h]
    mov r12, [rsp+40h] ; saved
    mov r13, [rsp+48h]
    mov r14, [rsp+50h]
    mov r15, [rsp+58h]

    leave
    ret
CalculateLines endp