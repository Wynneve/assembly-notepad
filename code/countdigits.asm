.code

; rcx (1) = (int) number
; rax = (int) result
CountDigits proc
    enter 20h, 0                    ; form stack frame
    
    mov [rsp],     rbx              ; save variables
    mov [rsp+8h],  rcx
    mov [rsp+10h], rdx
    mov [rsp+18h], r8

    mov rax, rcx                    ; rax = number
    mov rdx, 0

    mov rcx, 0                      ; int digits = 0
    
    mov r8, 10
    countdigits__div_loop:          ; do
        div r8                      ; number /= 10 (=rax)
        mov rdx, 0
        
        inc rcx                     ; digits++
        
        cmp rax, 0                  ; while(number > 0)
        jg countdigits__div_loop

    mov rax, rcx                    ; return digits

    mov rbx, [rsp]                  ; restore variables
    mov rcx, [rsp+8h]
    mov rdx, [rsp+10h]
    mov r8,  [rsp+18h]

    leave
    ret
CountDigits endp