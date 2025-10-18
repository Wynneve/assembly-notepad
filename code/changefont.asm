.code

ChangeFont proc
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

    ; if(!ChooseFontA(&chooseFont)) return

    mov rcx, offset chooseFont
    call ChooseFontA

    cmp rax, 0
    je changefont__return

    ; hFont = CreateFontIndirectA(&logFont)

    mov rcx, offset logFont
    call CreateFontIndirectA
    mov r12, rax

    ; SendMessageA(hLines, WM_SETFONT, hFont, TRUE)

    mov rcx, [hLines]
    mov rdx, WM_SETFONT
    mov r8, r12
    mov r9, TRUE

    call SendMessageA

    ; SendMessageA(hEdit, WM_SETFONT, hFont, TRUER)

    mov rcx, [hEdit]
    mov rdx, WM_SETFONT
    mov r8, r12
    mov r9, TRUE

    call SendMessageA

changefont__return:
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
ChangeFont endp