;每个单词前四个字母改成大写
assume cs:code,ds:data,ss:stack

data segment
		db		'1. display      '
		db		'2. brows        '
		db		'3. replace      '
		db		'4. modify       '
data ends

stack segment
		dw		0,0,0,0,0,0,0,0
		dw		0,0,0,0,0,0,0,0
stack ends

code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,32
				
				mov ax,data
				mov ds,ax
				mov es,ax
				
				mov dx,0
				
				mov bx,0
				mov cx,4
				
capsRow:		push cx

				mov si,3
				mov cx,4
				
capsCol:		mov dl,ds:[bx+si]
				and dl,11011111b
				mov es:[bx+si],dl
				inc si
				loop capsCol
				
				add bx,16
				pop cx
				loop capsRow
				
				mov ax,4c00h
				int 21h
code ends

end start