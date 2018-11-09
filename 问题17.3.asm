
assume cs:code,ds:data

stack segment stack
		db 128 dup (0)
stack ends

data segment
STRING		db 128 dup (0)
data ends

code segment
start:
		call _regInit
testA:		call _showStr
		nop
		nop
		nop
		jmp testA

		mov ax,4c00h
		int 21h
;==================================================
_show:
		mov si,0
		mov di,160*20
showLoop:	cmp STRING[si],0
		je showRet
		mov al,STRING[si]
		mov es:[di],al
		inc si
		add di,2
		jmp showLoop

showRet:	ret
;==================================================
_showStr:
		mov ah,0
		int 16h

		cmp al,32
		jb noChar
		cmp bx,100
		je showStrRet
		mov STRING[bx],al
		inc bx
		call _show

showStrRet:	ret
;==================================================
noChar:		cmp ah,0eh
		je backSpace
		cmp ah,1ch
		je enter

		jmp showStrRet
;==================================================
backSpace:	cmp bx,0
		je showStrRet

		dec bx
		mov STRING[bx],0
		mov byte ptr es:[di-2],0
		call _show

		jmp showStrRet
;==================================================
enter:		mov STRING[bx],0

		jmp showStrRet
;==================================================
_regInit:
		mov bx,data
		mov ds,bx
		mov si,0
		mov bx,0b800h
		mov es,bx
		mov di,160*20

		mov bx,0

		ret
code ends

end start