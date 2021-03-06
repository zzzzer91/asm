;课程设计2(3,4功能)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _regInit
		call _showMenu
		call _core

		mov ax,4c00h
		int 21h
;==================================================
;应用时间修改
_changeClock:
		mov si,offset Time_COMS
		mov bx,0

		mov cx,6
goLoop:		mov di,ds:[bx+offset TABLE1]
		mov dl,es:[di+160*10+2*30]
		mov di,ds:[bx+2+offset TABLE1]
		mov dh,es:[di+160*10+2*30]
		sub dh,30h
		sub dl,30h
		shl dl,1
		shl dl,1
		shl dl,1
		shl dl,1
		and dh,00001111b
		or dl,dh

		mov al,ds:[si]
		out 70h,al
		mov al,dl
		out 71h,al

		inc si
		add bx,4
		loop goLoop

		ret
;==================================================
;处理输入
TABLE1		dw 0,2,6,8,0ch,0eh,12h,14h,18h,1ah,1eh,20h

_input:
		mov di,[bx+offset TABLE1]

		mov ah,0
		int 16h

		cmp al,'0'
		jb noNum
		cmp al,'9'
		ja inputRet
		cmp cx,12
		je inputRet
		mov es:[di+160*10+2*30],al
		inc cx
		mov bx,cx
		add bx,bx

inputRet:	ret
;--------------------------------------------------
;如果输入的不是数字
noNum:
		cmp ah,0eh
		je backSpace
		cmp ah,1ch
		je enter
		cmp ah,01h
		je return1

		jmp inputRet
;--------------------------------------------------
;退格键处理
backSpace:
		cmp cx,0
		je inputRet

		dec cx
		mov bx,cx
		add bx,bx
		mov di,[bx+offset TABLE1]
		mov byte ptr es:[di+160*10+2*30],'0'

		jmp inputRet
;--------------------------------------------------
;Enter键处理
enter:
		call _changeClock

		pop di
		jmp clock
;--------------------------------------------------
;Esc键处理
return1:
		pop di
		call _clearBUf
		call _showMenu

		jmp coreLoop
;=====================================================
;清空键盘缓冲区
_clearBUf:
		mov ah,1
		int 16h
		jz clearBufRet
		mov ah,0
		int 16h
		jmp _clearBuf
clearBufRet:	ret
;=====================================================
;显示瞬时时间
_time:
		mov cx,6
clockLoop:	mov al,ds:[bx]
		out 70h,al
		in al,71h
		mov ah,al
		shr ah,1
		shr ah,1
		shr ah,1
		shr ah,1
		and al,00001111b
		add ah,30h
		add al,30h
		mov es:[di],ah
		mov es:[di+2],al
		inc bx
		add di,6
		loop clockLoop

		ret
;=====================================================
;核心控制
_core:
coreLoop:	mov ah,0
		int 16h

		cmp ah,02h
		je resetPC
		cmp ah,03h
		je startPC
		cmp ah,04h
		je clock
		cmp ah,05h
		je setClock
		cmp ah,3bh
		je changeC

		jmp coreLoop

coreRet:	ret
;-----------------------------------------------------
;重启计算机
resetPC:
		call _cls
		jmp coreRet
;-----------------------------------------------------
;引导现有操作系统
startPC:
		call _cls
		jmp coreRet
;-----------------------------------------------------
;进入时钟程序
Time_STYLE:	db '00/00/00 00:00:00',0
Time_COMS:	db 9,8,7,4,2,0

clock:
		call _cls

		mov di,160*10+2*30
		mov si,offset Time_STYLE
		call _showStr

showTime:	mov di,160*10+2*30
		mov bx,offset Time_COMS

		call _time

		in al,60h
		cmp al,01h
		je return
		jmp showTime
;-----------------------------------------------------
;设置时间
setClock:
		call _cls

		mov di,160*10+2*30
		mov si,offset Time_STYLE
		call _showStr

		mov cx,0
		mov bx,cx
setClockLoop:	call _input
		jmp setClockLoop
;-----------------------------------------------------
;改变显示颜色
changeC:
		mov si,1

		mov cx,2000
changeCLoop:	inc byte ptr es:[si]
		add si,2
		loop changeCLoop

		jmp coreLoop
;-----------------------------------------------------
;返回主菜单
return:
		call _clearBUf
		call _showMenu

		jmp coreLoop
;=====================================================
;显示字符串
_showStr:
		push si
		push di
		push ax

showStrLoop:	cmp byte ptr ds:[si],0
		je showStrRet
		mov al,ds:[si]
		mov es:[di],al
		inc si
		add di,2
		jmp showStrLoop

showStrRet:	pop ax
		pop di
		pop si
		ret
;=====================================================
;清屏
_cls:
		mov di,0
		mov bl,0

		mov cx,2000
clsLoop:	mov es:[di],bl
		add di,2
		loop clsLoop

		ret
;=====================================================
;显示主菜单
STR1		db '1) reset pc',0
STR2		db '2) start system',0
STR3		db '3) clock',0
STR4		db '4) set clock',0
TABLE		dW offset STR1,offset STR2,offset STR3,offset STR4

_showMenu:
		call _cls

		mov di,160*10+2*30
		mov bx,offset TABLE

		mov cx,4
showMenuLoop:	mov si,ds:[bx]
		call _showStr
		add di,160
		add bx,2
		loop showMenuLoop

		ret
;=====================================================
;初始化寄存器
_regInit:
		mov bx,0b800h
		mov es,bx
		mov bx,cs
		mov ds,bx

		ret
code ends

end start