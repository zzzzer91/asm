
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt7ch

		mov ah,2
		mov al,3
		int 7ch

		mov ax,4c00h
		int 21h
;======================================================
doStart:	jmp gogogo

TABLE		dw offset cls - offset doStart + 7e00h
		dw offset prs - offset doStart + 7e00h
		dw offset bgs - offset doStart + 7e00h
		dw offset ups - offset doStart + 7e00h

gogogo:		push ax
		push bx
		push cx
		push es
		push di

		mov bx,0
		mov bl,ah
		add bx,bx
		add bx,offset TABLE - offset doStart + 7e00h
		jmp cs:[bx]

doRet:		pop di
		pop es
		pop cx
		pop bx
		pop ax
		iret
;======================================================
;清屏
cls:		mov bx,0b800h
		mov es,bx
		mov di,0

		mov bx,0700h
		mov cx,2000
clsLoop:	mov es:[di],bx
		add di,2
		loop clsLoop

		jmp doRet
;======================================================
;设置前景色
prs:		mov bx,0b800h
		mov es,bx
		mov di,1

		mov cx,2000h
preLoop:	mov es:[di],al
		add di,2
		loop preLoop

		jmp doRet
;======================================================
;设置背景色
bgs:		mov bx,0b800h
		mov es,bx
		mov di,1

		shl al,1
		shl al,1
		shl al,1
		shl al,1
		mov cx,2000h
bgsLoop:	mov es:[di],al
		add di,2
		loop bgsLoop

		jmp doRet
;======================================================
;向上滚动一行
ups:		mov bx,0b800h
		mov ds,bx
		mov si,160*1
		mov es,bx
		mov di,0

		mov cx,80*24
		cld
		rep movsw

		mov di,160*24
		mov bx,0700h
		mov cx,80
upsLoop:	mov es:[di],bx
		add di,2
		loop upsLoop

		jmp doRet

doEnd:		nop
;======================================================
_setNewInt:
		mov bx,0
		mov es,bx

		cli
		mov word ptr es:[7ch*4],7e00h
		mov word ptr es:[7ch*4+2],0
		sti

		ret
;======================================================
_cpyNewInt:
		mov bx,cs
		mov ds,bx
		mov si,offset doStart
		mov bx,0
		mov es,bx
		mov di,7e00h

		mov cx,offset doEnd - offset doStart
		cld
		rep movsb

		ret
;======================================================
_newInt7ch:
		call _cpyNewInt
		call _setNewInt

		ret
code ends

end start