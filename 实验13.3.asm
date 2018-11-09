
assume cs:code

code segment
s1:		db 'Good,better,best,','$'
s2:		db 'Never let it rest,','$'
s3:		db 'Till good is better,','$'
s4:		db 'And better,best.','$'
s:		dw offset s1,offset s2,offset s3,offset s4
row:		db 2,4,6,8
start:
		mov ax,cs
		mov ds,ax
		mov bx,offset s
		mov si,offset row
		mov cx,4
ok:		mov bh,0	;第0页
		mov dh,ds:[si]	;dh中放行号
		mov dl,0	;dl中放列号
		mov ah,2	;ah=2,代表设置光标
		int 10h

		mov dx,ds:[bx]
		mov ah,9	;代表在光标处显示字符串
		int 21h
		add bx,2
		inc si
		loop ok

		mov ax,4c00h
		int 21h
code ends

end start