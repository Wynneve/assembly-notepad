.code

UpdateWindowName proc
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

    ; if(*currentPath != '\0')
    mov al, byte ptr [currentPath]
    cmp al, 0
    je  updatewindowname__path_cond_else
    
    ; char* srcPtr = currentPath
    mov r12, offset currentPath
    ; char* dstPtr = prefix3 + 10
    mov r13, offset prefix3
    add r13, 10
    ; char ch = '\0'
    mov al, 0
    
    ; while(ch = *(srcPtr++))
    updatewindowname__copy_loop_begin:
        mov al, byte ptr [r12]
        inc r12

        cmp al, 0
        je updatewindowname__copy_loop_end

        ; *(dstPtr++) = ch
        mov byte ptr [r13], al
        inc r13

        jmp updatewindowname__copy_loop_begin
    updatewindowname__copy_loop_end:
    
    ; if(!saved)
    mov r14d, [saved]
    cmp r14d, FALSE
    jne updatewindowname__not_saved_cond_else

    ; *(dstPtr++) = '*'
    mov byte ptr [r13], "*"
    inc r13
updatewindowname__not_saved_cond_else:
    ; do
    mov r14, offset prefix3
    add r14, sizeof prefix3
    updatewindowname__zero_loop_begin:
        ; *(dstPtr++) = '\0'
        mov byte ptr [r13], 0
        inc r13

        ; while(dstPtr < prefix3 + sizeof(prefix3))
        cmp r13, r14
        jl updatewindowname__zero_loop_begin

    ; SetWindowTextA(hWindow, prefix3)
    mov rcx, [hWindow]
    mov rdx, offset prefix3

    call SetWindowTextA

    jmp updatewindowname__path_cond_end
    ; else
updatewindowname__path_cond_else:
    ; if(saved) SetWindowTextA(hWindow, prefix1)
    ; else SetWindowTextA(hWindow, prefix2)

    mov rcx, [hWindow]
    mov rdx, offset prefix2

    mov r14d, [saved]
    cmp r14d, TRUE
    mov r14, offset prefix1
    cmove rdx, r14

    call SetWindowTextA
updatewindowname__path_cond_end:

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
UpdateWindowName endp