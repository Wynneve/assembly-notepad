.code

; rcx (1) = HWND hwnd,
; rdx (2) = UINT msg,
; r8  (3) = WPARAM wParam,
; r9  (4) = LPARAM lParam
EditWndProc proc
    enter 20h, 0

    cmp rdx, WM_VSCROLL
    je editwndproc__switch_wm_vscroll

    jmp editwndproc__switch_end

    editwndproc__switch_wm_vscroll:
        call UpdateControls
        jmp editwndproc__switch_end
    editwndproc__switch_end:
    
    call [baseEditProc]
    
    leave
    ret
EditWndProc endp