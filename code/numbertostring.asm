.code

; rcx (1) = (char*) buffer
; rdx (2) = (int) number
; rax = (char*) result
NumberToString proc
    enter 40h, 0

    mov [rsp],     rcx
    mov [rsp+8h],  rdx
    mov [rsp+10h], r8
    mov [rsp+18h], r9
    mov [rsp+20h], r12
    mov [rsp+28h], r13
    mov [rsp+30h], r14
    mov [rsp+38h], r15

    ; char* ptr = buffer
    mov r12, rcx
    
    mov rax, rdx
    mov r14, 10
    ; do
    numbertostring__div_loop: 
        ; int rem = number % 10 (=rdx)
        ; number /= 10          (=rax)
        mov rdx, 0
        div r14

        ; *(ptr++) = 0x30 + rem
        add dl, 30h
        mov byte ptr [r12], dl
        inc r12

        cmp rax, 0
        jne numbertostring__div_loop

    ; char* end = ptr
    mov r13, r12
    ; ptr--
    dec r12

    ; do
    numbertostring__reverse_loop:
        ; char tmp = *ptr
        mov dl, byte ptr [r12]
        
        ; *(ptr--) = *buffer
        mov al, byte ptr [rcx]
        mov byte ptr [r12], al
        dec r12

        ; *(buffer++) = tmp
        mov byte ptr [rcx], dl
        inc rcx

        cmp r12, rcx
        jg numbertostring__reverse_loop

    ; return end
    mov rax, r13

    ; restore variables
    mov rcx, [rsp]
    mov rdx, [rsp+8h]
    mov r8,  [rsp+10h]
    mov r9,  [rsp+18h]
    mov r12, [rsp+20h]
    mov r13, [rsp+28h]
    mov r14, [rsp+30h]
    mov r15, [rsp+38h]

    leave
    ret
NumberToString endp