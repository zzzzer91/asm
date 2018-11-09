;求一个数平方
assume cs:code

data segment
		db 'Divide error!',0
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt7ch

		mov ax,3456
		int 7ch
		add ax,ax
		adc dx,dx

		mov ax,4c00h
		int 21h
;================================================
doStart:	mul ax

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