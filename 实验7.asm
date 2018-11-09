
assume cs:code,ss:stack,ds:data

data segment
		;year
		db		'1975','1976','1977','1978','1979','1980','1981','1982','1983'
		db		'1984','1985','1986','1987','1988','1989','1990','1991','1992'
		db		'1993','1994','1995'
		;summ
		dd		16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
		dd		345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
		;ne
		dw		3,7,9,13,28,130,220,476,778,1001,1442,2250,2793,4037,5635,8226
		dw		11542,14430,15257,17800
data ends

table segment
		db	21	dup ('year summ ne ?? ')
table ends

stack segment
		db	128	dup (0)
stack ends

code segment
start:			mov ax,stack
				mov ss,ax
				mov sp,128
				mov ax,data
				mov ds,ax
				mov ax,table
				mov es,ax
				
				mov si,0
				mov di,0
				mov bx,0
				mov cx,21
inputTable:		push ds:[si]
				pop es:[di]
				push ds:[si+2]
				pop es:[di+2]
				
				mov ax,ds:[si+84]
				mov dx,ds:[si+86]
				mov es:[di+5],ax
				mov es:[di+7],dx
				
				push ds:[bx+168]
				pop es:[di+10]
				div word ptr ds:[bx+168]
				mov es:[di+13],ax
				
				add si,4
				add bx,2
				add di,16
				loop inputTable
				
				mov ax,4c00h
				int 21h
code ends

end start