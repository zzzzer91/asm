
assume cs:code

data segment
		dw 123,12666,1,8,3,38,0
data ends

stack segment stack
		dw 128 dup (0)
stack ends

code segment
start:
		mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax

		call _clearScreen
		call _showNumber

		mov ax,4c00h
		int 21h
;===============================================
_showNumber:
		mov si,0
		mov di,160*5+2*40

		mov bx,10 ;除数

		mov cx,7 ;循环次数
showNumber:	call _divNumber
		add si,2
		add di,160
		loop showNumber

		ret
;===============================================
_divNumber:
		push di
		push cx

		mov ax,ds:[si] ;被除数
		mov cx,0
		mov es:[di+2],cx

divNumber:	mov dx,0
		div bx
		add dl,48
		mov es:[di],dl
		mov cx,ax
		jcxz divNumberRet
		sub di,2
		jmp divNumber

divNumberRet:	pop cx
		pop di
		ret
;===============================================
_clearScreen:
		mov bx,0700h
		mov di,0

		mov cx,1999
clearScreen:	mov es:[di],bx
		add di,2
		loop clearScreen

		ret
code ends

end start