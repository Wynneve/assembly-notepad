.code

ResizeControls proc
    enter 80h, 0

    ; save variables
    mov [rsp+40h], rcx
    mov [rsp+48h], rdx
    mov [rsp+50h], r8
    mov [rsp+58h], r9
    mov [rsp+60h], r12
    mov [rsp+68h], r13
    mov [rsp+70h], r14
    mov [rsp+78h], r15

    ; digitsCount = CountDigits(editLastLine)
    mov ecx, [editLastLine]
    call CountDigits
    mov [digitsCount], eax

    ; digitsPrevWidth = digitsWidth
    mov eax, [digitsWidth]
    mov [digitsPrevWidth], eax

    ; digitsWidth = digitsCount * editLineWidth + 6
    mov r12d, [digitsCount]
    mov r13d, [editLineWidth]
    imul r12d, r13d
    add r12d, 6
    mov [digitsWidth], r12d

    ; if(digitsPrevWidth == digitsWidth && windowPrevWidth == windowWidth && windowPrevHeight == windowHeight) return
    mov r12d, [digitsPrevWidth]
    mov r13d, [digitsWidth]
    cmp r12d, r13d
    jne resizecontrols__cond_continue

    mov r12d, [windowPrevWidth]
    mov r13d, [windowWidth]
    cmp r12d, r13d
    jne resizecontrols__cond_continue

    mov r12d, [windowPrevHeight]
    mov r13d, [windowHeight]
    cmp r12d, r13d
    jne resizecontrols__cond_continue

    jmp resizecontrols__cond_return

resizecontrols__cond_continue:
    ; SetWindowPos(hLines, NULL, 0, 0, digitsWidth, windowHeight, SWP_NOZORDER)
    mov rcx, [hLines]
    mov rdx, NULL
    mov r8,  0
    mov r9,  0
    mov eax, [digitsWidth]
    mov dword ptr [rsp+20h], eax
    mov eax, [windowHeight]
    mov dword ptr [rsp+28h], eax
    mov dword ptr [rsp+30h], SWP_NOZORDER
    
    call SetWindowPos

    ; SetWindowPos(hEdit, NULL, digitsWidth + 5, 0, windowWidth - digitsWidth - 5, windowHeight, SWP_NOZORDER)
    mov rcx, [hEdit]
    mov rdx, NULL
    mov eax, [digitsWidth]
    add eax, 5
    mov r8, rax
    mov r9, 0
    mov eax, [windowWidth]
    mov ebx, [digitsWidth]
    sub eax, ebx
    sub eax, 5
    mov dword ptr [rsp+20h], eax
    mov eax, [windowHeight]
    mov dword ptr [rsp+28h], eax
    mov dword ptr [rsp+30h], SWP_NOZORDER

    call SetWindowPos

resizecontrols__cond_return:
    ; restore variables
    mov rcx, [rsp+40h]
    mov rdx, [rsp+48h]
    mov r8,  [rsp+50h]
    mov r9,  [rsp+58h]
    mov r12, [rsp+60h]
    mov r13, [rsp+68h]
    mov r14, [rsp+70h]
    mov r15, [rsp+78h]

    leave
    ret
ResizeControls endp