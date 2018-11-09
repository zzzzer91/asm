;安装新int9h中断 F1改变颜色 (思考格式,易错点)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt9h

testA:		mov ax,1000h
		jmp testA

		call _setOldInt

		mov ax,4c00h
		int 21h
;================================================
;新的int9h的主体,需要被copy到一段安全的内存
doStart:	push ax		;安装新中断,尽量把用过的寄存器都push
		push bx
		push cx
		push es

		in al,60h
		pushf			;这里必须先pushf,才能call
		call dword ptr cs:[200h];cs=0 因为是call far 所以已经保存cs和ip了

		cmp al,48h
		je isUP
		cmp al,3bh		;F1的扫描码
		jne doRet
		call _changeSColor

doRet:		pop es
		pop cx
		pop bx
		pop ax
		iret			;这里是iret,别写成ret了!!!
;================================================
isUP:		mov bx,0b800h
		mov es,bx
		mov di,160*20+2*10

		mov byte ptr es:[di],'U'

		jmp doRet
;================================================
_changeSColor:
		mov bx,0b800h
		mov es,bx
		mov bx,1

		mov cx,2000
goLoop:		inc byte ptr es:[bx]
		add bx,2
		loop goLoop

		ret

doEnd:		nop	;切记nop要放在整段最后!!!
;================================================
;恢复原来的int9h,以免影响其他程序
_setOldInt:
		mov bx,0
		mov es,bx

		cli
		push es:[200h]
		pop es:[9*4]
		push es:[202h]
		pop es:[9h*4+2]
		sti

		ret
;================================================
;把新的int9h入口地址放到中断向量表
_setNewInt:
		mov bx,0
		mov es,bx

		cli
		mov word ptr es:[9h*4],7e00h
		mov word ptr es:[9h*4+2],0
		sti

		ret
;================================================
;将原来的入口地址放到 0:200h
_savOldInt:
		mov bx,0
		mov es,bx

		cli		;使IF=0 屏蔽可屏蔽中断(如键盘输入)
		push es:[9h*4]
		pop es:[200h]
		push es:[9h*4+2]
		pop es:[202h]
		sti		;使IF=1 解除屏蔽

		ret
;================================================
;把代码copy到相对安全的内存(0:7e00h)
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
;================================================
_newInt9h:
		call _cpyNewInt
		call _savOldInt
		call _setNewInt

		ret
code ends

end start