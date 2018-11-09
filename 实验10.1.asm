
assume cs:code

data segment
		db 'welcome to masm!',0
data ends

stack segment stack
		dw 128 dup (0)
stack ends

code segment
start:		mov dh,23
		mov dl,3
		mov ax,data
		mov ds,ax
		mov si,0

		call _showStr

		mov ax,4c00h
		int 21h
;===============================================
_showStr:
		mov ax,0b800h
		mov es,ax

		mov al,160
		mul dh
		mov di,ax
		mov al,2
		mul dl
		add di,ax

showStr:	mov cx,0
		mov cl,ds:[si]
		jcxz showStrRet
		mov ch,2
		mov es:[di],cx
		inc si
		add di,2
		jmp showStr

showStrRet:	ret
code ends

end start