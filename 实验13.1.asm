
assume cs:code

data segment
		db 'Welcome to masm!',0
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt7ch

		mov dh,10	;行号
		mov dl,10	;列号
		mov cl,2	;颜色
		mov ax,data
		mov ds,ax
		mov si,0	;字符串首地址
		int 7ch

		mov ax,4c00h
		int 21h
;===========================================
doStart:	push ax

		mov ax,0b800h
		mov es,ax

		mov al,160
		mul dh
		mov di,ax
		mov al,2
		mul dl
		add di,ax

doLoop:		cmp byte ptr ds:[si],0
		je doRet
		mov al,ds:[si]
		mov ah,cl
		mov es:[di],ax
		inc si
		add di,2
		jmp doLoop

doRet:		pop ax
		iret
doEnd:		nop
;===========================================
_copyInt7ch:
		mov ax,cs
		mov ds,ax
		mov si,offset doStart
		mov ax,0
		mov es,ax
		mov di,7e00h

		cld
		mov cx,offset doEnd - offset doStart
		rep movsb

		ret
;===========================================
_newInt7ch:
		call _copyInt7ch

		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],7e00h
		mov word ptr es:[7ch*4+2],0

		ret
code ends

end start