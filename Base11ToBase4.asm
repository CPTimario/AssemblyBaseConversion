.model small
.stack 0100h
.data
        msg1 db "CONVERSION$"
        msg2 db "BASE 11 TO BASE 4$"
        msg3 db "INPUT A NUMBER [00.00 - AA.AA]: $"
        msg4 db "CONVERTED VALUE: $"
        msg5 db "INPUT ANOTHER [Y/N]: $"
        er db "ERROR: INVALID INPUT!$"
        num dw 0
        dci dw 0
        tmp dw 0
        th dw 1000
        mlt dw 1
        ten dw 10
        b1a db 11
        b1b dw 11
        b1c dw 121
        b2a db 4
        b2b dw 4
        
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
        
err0r:
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
        cmp al, 39h
        jg ltr1a
        sub al, 30h
        jmp tens
ltr1a:
        cmp al, 41h
        jl error
        cmp al, 41h
        jg ltr1b
        sub al, 37h
        jmp tens
ltr1b:  
        cmp al, 61h
        jl error
        cmp al, 61h
        jg error
        sub al, 57h
        jmp tens
        
tens:
        mul b1a
        mov bx, ax
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 39h
        jg ltr2a
        sub al, 30h
        jmp ones
ltr2a:
        cmp al, 41h
        jl error
        cmp al, 41h
        jg ltr2b
        sub al, 37h
        jmp ones
ltr2b:  
        cmp al, 61h
        jl error
        cmp al, 61h
        jg error
        sub al, 57h
        jmp ones
ones:
        mov ah, 00h
        add bx, ax
        mov num, bx
        
        mov ah, 01h
        int 21h
        cmp al, 2eh
        jne error
        jmp deci
        
error:  jmp err0r  
      
deci:        
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 39h
        jg ltr3a
        sub al, 30h
        jmp tenths
ltr3a:
        cmp al, 41h
        jl error
        cmp al, 41h
        jg ltr3b
        sub al, 37h
        jmp tenths
ltr3b:  
        cmp al, 61h
        jl error
        cmp al, 61h
        jg error
        sub al, 57h
        jmp tenths
        
tenths:
        mov ah, 00h
        mul th
        div b1b
        mov bx, ax
        mov ah, 01h
        int 21h
        cmp al, 30h
        jl error
        cmp al, 39h
        jg ltr4a
        sub al, 30h
        jmp hunths
ltr4a:
        cmp al, 41h
        jl error
        cmp al, 41h
        jg ltr4b
        sub al, 37h
        jmp hunths
ltr4b:  
        cmp al, 61h
        jl error
        cmp al, 61h
        jg error
        sub al, 57h
        jmp hunths
hunths:
        mov ah, 00h
        mul th
        div b1c
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
        
        mov mlt, 1
        mov tmp, 0
        mov cx, 00
        mov ax, num
lp1:        
        div b2a
        add cx, 1
        mov bx, ax
        mov ah, 00h
        mov al, bh
        mul mlt
        add tmp, ax
        mov ax, mlt
        mul ten
        mov mlt, ax
        mov ah, 00h
        mov al, bl
        cmp al, b2a
        jge lp1
        add cx, 1
        mov ah, 00h
        mul th
        add tmp, ax
        
        mov ax, tmp
lp2:        
        div th
        mov tmp, dx
        add al, 30h
        mov ah, 02h
        mov dl, al
        int 21h
        mov ax, tmp
        mul ten
        mov tmp, ax
        loop lp2
        
        mov ah, 02h
        mov dl, 2eh
        int 21h
        
        mov cx, 3
        mov ax, dci
lp3:
        mul b2b
        div th
        mov tmp, dx
        mov bx, ax
        add bl, 30h
        
prt2:
        mov ah, 02h
        mov dl, bl
        int 21h
        mov ax, tmp
        loop lp3
        
        jmp ques
        
exit:
        mov ax, 4c00h
        int 21h

end start
