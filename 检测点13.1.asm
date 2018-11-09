;7ch完成 jmp near ptr s 指令功能
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
		mov ax,0b800h
		mov es,ax
		mov di,160*12

		mov bx,offset s - offset ok
s:		cmp byte ptr ds:[si],0
		je ok
		mov al,ds:[si]
		mov es:[di],al
		inc si
		add di,2
		int 7ch

ok:		mov ax,4c00h
		int 21h
;================================================
doStart:	push bp
		mov bp,sp
		add ss:[bp+2],bx
doRet:		pop bp
		iret
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