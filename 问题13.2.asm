;将一个全是字母，以0结尾的字符串，转化为大写
assume cs:code

data segment
		db 'conversation',0
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt7ch

		mov ax,data
		mov ds,ax
		mov si,0
		int 7ch

		mov ax,4c00h
		int 21h
;================================================
doStart:	cmp byte ptr ds:[si],0
		je doRet
		and byte ptr ds:[si],11011111b
		inc si
		jmp doStart

doRet:		iret
doEnd:		nop
;================================================
_copyInt7ch:
		mov ax,cs
		mov ds,ax
		mov si,offset doStart
		mov ax,0
		mov es,ax
		mov di,7e00h

		mov cx,offset doEnd - offset doStart
		cld
		rep movsb

		ret
;================================================
_newInt7ch:
		call _copyInt7ch

		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],7e00h
		mov word ptr es:[7ch*4+2],0

		ret
code ends

end start