;除法防溢出
assume cs:code

data segment
		dd 1234567
data ends

stack segment stack
		dw 128 dup (0)
stack ends

code segment
start:		mov ax,data
		mov ds,ax

		mov ax,ds:[0]
		mov dx,ds:[2]
		mov bx,10

		call _longDiv

		mov ax,4c00h
		int 21h
;===============================================
_longDiv:
		mov cx,dx
		jcxz _shortDiv	;当被除数小于等于2字节时,调用普通除法提高效率
		mov cx,ax	;先将被除数低位保存到cx
		mov ax,dx	;将被除数高位移动到ax
		mov dx,0	;不能忘记将dx置成0
		div bx
		push ax		;保存商,这是最终结果的高位商
		mov ax,cx	;放出被除数低位
		div bx
		mov cx,dx	;将余数放在cx上
		pop dx		;把高位商放在dx上

		ret
;===============================================
_shortDiv:
		div bx
		mov cx,dx	;将余数统一放置在cx上
		mov dx,0	;不能忘记把dx置成0

		ret
code ends

end start