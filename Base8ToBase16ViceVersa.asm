.model small
.stack 0100h
.data
        msg1 db "CONVERSION$"
        msg2a db "[1] BASE 8 TO BASE 16$"
        msg2b db "[2] BASE 16 TO BASE 8$"
        msg3 db "INPUT CHOICE: $"
        msg4a db "INPUT A NUMBER [00.00 - 77.77]: $"
        msg4b db "INPUT A NUMBER [00.00 - FF.FF]: $"
        msg5 db "CONVERTED VALUE: $"
        msg6 db "INPUT ANOTHER [Y/N]: $"
        er db "ERROR: INVALID INPUT!$"
        num dw 0
        dci dw 0
        tmp dw 0
        th dw 1000
        chc db 0
        mlt dw 0
        ten dw 10
        b1a db 0
        b1b dw 0
        b1c dw 0
        b2a db 0
        b2b dw 0
        lmt db 0
        
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
        mov dx, 0723h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg1
        int 21h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 091eh
        int 10h
        
        mov ah, 09h
        mov dx, offset msg2a
        int 21h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0a1eh
        int 10h
        
        mov ah, 09h
        mov dx, offset msg2b
        int 21h
        
        mov ah, 02h
        mov bh, 00h
        mov dx, 0c21h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg3
        int 21h
        
        mov ah, 01h
        int 21h
        mov chc, al
        cmp chc, 31h
        je _8to16
        cmp chc, 32h
        je _16to8
        jmp err0r
        

_8to16: 
        mov ah, 02h
        mov bh, 00h
        mov dx, 0e17h
        int 10h
       
        mov ah, 09h
        mov dx, offset msg4a
        int 21h
        
        mov b1a, 8
        mov b1b, 8
        mov b1c, 64
        mov b2a, 16
        mov b2b, 16
        mov lmt, 37h
        
        jmp cnv
        
_16to8:
        mov ah, 02h
        mov bh, 00h
        mov dx, 0e17h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg4b
        int 21h
        
        mov b1a, 16
        mov b1b, 16
        mov b1c, 256
        mov b2a, 8
        mov b2b, 8
        mov lmt, 39h
        
        jmp cnv
        
ask:
        mov ah, 01h
        int 21h
        cmp al, 59h
        je st4rt
        cmp al, 79h
        je st4rt
        jmp exit

        
st4rt:  jmp start        
        
ques:        
        mov ah, 02h
        mov bh, 00h
        mov dx, 111dh
        int 10h
        
        mov ah, 09h
        mov dx, offset msg6
        int 21h
        
        jmp ask
        
err0r:
        mov ah, 02h
        mov bh, 00h
        mov dx, 0f1eh
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
        cmp al, lmt
        jg ltr1a
        sub al, 30h
        jmp tens
ltr1a:
        cmp al, 41h
        jl error
        cmp al, 46h
        jg ltr1b
        sub al, 37h
        jmp tens
ltr1b:  
        cmp al, 61h
        jl error
        cmp al, 66h
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
        cmp al, lmt
        jg ltr2a
        sub al, 30h
        jmp ones
ltr2a:
        cmp al, 41h
        jl error
        cmp al, 46h
        jg ltr2b
        sub al, 37h
        jmp ones
ltr2b:  
        cmp al, 61h
        jl error
        cmp al, 66h
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
        cmp al, lmt
        jg ltr3a
        sub al, 30h
        jmp tenths
ltr3a:
        cmp al, 41h
        jl error
        cmp al, 46h
        jg ltr3b
        sub al, 37h
        jmp tenths
ltr3b:  
        cmp al, 61h
        jl error
        cmp al, 66h
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
        cmp al, lmt
        jg ltr4a
        sub al, 30h
        jmp hunths
ltr4a:
        cmp al, 41h
        jl error
        cmp al, 46h
        jg ltr4b
        sub al, 37h
        jmp hunths
ltr4b:  
        cmp al, 61h
        jl error
        cmp al, 66h
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
        mov dx, 0f17h
        int 10h
        
        mov ah, 09h
        mov dx, offset msg5
        int 21h
        
        mov cx, 0
        mov mlt, 1
        mov tmp, 0
        mov ax, num
        cmp chc, 31h
        je cnv2
        cmp chc, 32h
        je lp1
    
cnv2:
        div b2a
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
        
        jmp prt2   

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
        mul mlt
        add tmp, ax
        
        mov ax, tmp
lp2:        
        div mlt
        mov tmp, dx
        add al, 30h
        mov ah, 02h
        mov dl, al
        int 21h
        mov ax, tmp
        mul ten
        mov tmp, ax
        loop lp2
        
        jmp prt2
        
prt2:        
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
        cmp ax, 9
        jg gtr2
        add bl, 30h
        jmp prt3
        
gtr2:
        add bl, 37h
        jmp prt3        
        
prt3:
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
