.model small
.stack 0100h
.data
        msg1 db "CONVERSION$"
        msg2 db "BASE 6 TO BASE 16$"
        msg3 db "INPUT A NUMBER [00.00 - 55.55]: $"
        msg4 db "CONVERTED VALUE: $"
        msg5 db "INPUT ANOTHER [Y/N]: $"
        er db "ERROR: INVALID INPUT!$"
        num dw 0
        dci dw 0
        tmp dw 0
        th dw 1000
        b1 db 6
        b1a dw 6
        b1b dw 36
        b2 db 16
        b2a dw 16
        
.code
start:
        mov ax, @data
        mov ds, ax
       
        mov ax, 0600h
        mov bh, 07h
        mov cx, 0000h
        mov dx, 184fh
        int 10h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0823h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg1
        int 21h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0a20h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg2
        int 21h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0c17h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg3
        int 21h
        
        jmp cnv
        
ask:
        mov ah, 01h
        int 21h
        cmp al, 59h
        je start
        cmp al, 79h
        je start
        jmp exit        
        
ques:        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0f1dh
        int 10h
        
        mov ah, 09h
        mov dx, offset msg5
        int 21h
        
        jmp ask
        
error:
        mov ah, 02h
        mov bh, 00h
        mov dx, 0d17h
        int 10h
        
        mov ah, 09h
        mov dx, offset er
        int 21h
        
        jmp ques
        
cnv:
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 35h
        jg error
        sub al, 30h
        mul b1
        mov bx, ax
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 35h
        jg error
        sub al, 30h
        mov ah, 00h
        add bx, ax
        mov num, bx
        
        mov ah, 01h
        int 21h
        cmp al, 2eh
        jne error
        
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 35h
        jg error
        sub al, 30h
        mov ah, 00h
        mul th
        div b1a
        mov bx, ax
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 35h
        jg error
        sub al, 30h
        mov ah, 00h
        mul th
        div b1b
        add bx, ax
        mov dci, bx
              
prnt:        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0d17h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg4
        int 21h
       
cnv2:
        mov ax, num
        div b2
        cmp ah, 9
        jg gtr1
        add ax, 3030h
        mov bh, al
        mov bl, ah
        
        jmp prt1
        
gtr1:    
        mov bh, al
        mov bl, ah
        mov al, bl
        mov ah, 00h
        mov cl, 10
        div cl
        mov bl, ah
        add bx, 3041h
        
        
prt1:        
        mov ah, 02h
        mov dl, bh
        int 21h
        mov dl, bl
        int 21h
        mov dl, 2eh
        int 21h
        
        mov cl, 3h
        mov ax, dci
        
lp:
        mul b2a
        div th
        mov tmp, dx
        mov bl, al
        cmp bl, 9
        jg gtr2
        add bl, 30h
        
        jmp prt2

gtr2:
        mov ah, 00h
        mov al, bl
        mov dl, 10
        div dl
        mov bl, ah
        add bl, 41h
       
prt2:
        mov ah, 02h
        mov dl, bl
        int 21h
        mov ax, tmp
        
        loop lp        
        jmp ques
        
exit:
        mov ax, 4c00h
        int 21h

end start
