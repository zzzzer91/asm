;软驱A的读或写
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		mov bx,0b800h
		mov es,bx
		mov bx,0

		mov dl,0		;驱动号,0代表软驱A
		mov dh,0		;磁头号
		mov ch,0		;磁道号
		mov cl,1		;扇区号
		mov al,8		;读取或写入扇区数
		mov ah,2		;功能号,2是从软驱读,3是往软驱写
		int 13h

		mov ax,4c00h
		int 21h
code ends

end start