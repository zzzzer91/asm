;用7ch中断完成loop功能
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

		mov ax,0b800h
		mov es,ax
		mov di,160*12

		mov bx,offset s - offset se
		mov cx,80
s:		mov byte ptr es:[di],'i'
		add di,2
		int 7ch
se:		nop

		mov ax,4c00h
		int 21h
;================================================
doStart:	push bp
		dec cx
		jcxz doRet
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