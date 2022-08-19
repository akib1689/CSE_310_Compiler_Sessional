.MODEL SMALL

.STACK 400h; 1KB stack

.DATA

	
	x		DW		0; line no 1 : x declared
	y		DW		10 DUP(0); line no 1 : y declared
		
.CODE
		

	foo  PROC
		
		PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        ; DX for returning results
        PUSH AX
        PUSH BX
        PUSH CX
        PUSHF
        
        
		
		MOV BX, [ x+0 ]
		PUSH BX; line no 4 : x loaded
		
		
		PUSH 0
		POP BX; line no 4 : ; Array index in BX ; global array
		SHL BX, 1; line no 4 :  ; because 2 byte element
		PUSH y[BX]
; peepholed 37		PUSH BX; line no 4 : ; here goes the index
; peepholed 36		POP BX
		POP AX
		MOV [x + 0], AX; line no 4 : x assined
		MOV BX, AX
; peepholed 43		PUSH BX

; peepholed 41		POP BX; line no 4 : ; previously pushed value on stack is removed
		
		
		MOV BX, [ x+0 ]
; peepholed 48		PUSH BX; line no 5 : x loaded
; peepholed 47		POP BX; line no 5 :  return value saved in DX 
		MOV DX, BX
		JMP @L_1; line no 5 :  ; exit from the function
		
		; return point foo
		@L_1: 
		MOV SP, BP
		SUB SP, 8
		POPF  
        
        POP CX
        POP BX
        POP AX
        
        POP BP
		RET 0
		

	foo ENDP

	main  PROC
		
		mov AX, @DATA
		mov DS, AX
		; data segment loaded
		
		MOV CX, 6; line no 10 : ; new array of size 6
		@L_3:
		JCXZ @L_4
		PUSH BX
		DEC CX
		JMP @L_3
		@L_4: 
		PUSH BX ; line no 10 : a declared
		
		MOV BX, [ BP-22 ]
		PUSH BX; line no 11 : a loaded
		
		CALL foo ; function foo called.; line no 11 : 
		MOV BX, DX; line no 11 :  return result in DX.
		PUSH BX
		POP AX
		MOV [BP + -22], AX; line no 11 : a assined
		MOV BX, AX
; peepholed 94		PUSH BX

; peepholed 92		POP BX; line no 11 : ; previously pushed value on stack is removed
		
		; return point main
		@L_2: 
		mov AH, 4Ch
		int 21h
		; returned control to OS
		

	main ENDP
		

	PRINT_NEWLINE PROC
        ; PRINTS A NEW LINE WITH CARRIAGE RETURN
        PUSH AX
        PUSH DX
        MOV AH, 2
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        POP DX
        POP AX
        RET
    PRINT_NEWLINE ENDP
    
    PRINT_CHAR PROC
        ; PRINTS A 8 bit CHAR 
        ; INPUT : GETS A CHAR VIA STACK 
        ; OUTPUT : NONE    
        PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        
        
        MOV DX, [BP + 4]
        MOV AH, 2
        INT 21H
        
        
        
        POPF  
        
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        RET 2
    PRINT_CHAR ENDP 

    PRINT_DECIMAL_INTEGER PROC NEAR
        ; PRINTS SIGNED INTEGER NUMBER WHICH IS IN HEX FORM IN ONE OF THE REGISTER
        ; INPUT : CONTAINS THE NUMBER  (SIGNED 16BIT) IN STACK
        ; OUTPUT : 
        
        ; STORING THE REGISTERS
        PUSH BP
        MOV BP, SP
        
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        MOV AX, [BP+4]
        ; CHECK IF THE NUMBER IS NEGATIVE
        OR AX, AX
        JNS @POSITIVE_NUMBER
        ; PUSHING THE NUMBER INTO STACK BECAUSE A OUTPUT IS WILL BE GIVEN
        PUSH AX

        MOV AH, 2
        MOV DL, 2Dh
        INT 21h

        ; NOW IT'S TIME TO GO BACK TO OUR MAIN NUMBER
        POP AX

        ; AX IS IN 2'S COMPLEMENT FORM
        NEG AX

        @POSITIVE_NUMBER:
            ; NOW PRINTING RELATED WORK GOES HERE

            XOR CX, CX      ; CX IS OUR COUNTER INITIALIZED TO ZERO
            MOV BX, 0Ah
            @WHILE_PRINT:
                
                ; WEIRD DIV PROPERTY DX:AX / BX = VAGFOL(AX) VAGSESH(DX)
                XOR DX, DX
                ; AX IS GUARRANTEED TO BE A POSITIVE NUMBER SO DIV AND IDIV IS SAME
                DIV BX                     
                ; NOW AX CONTAINS NUM/10 
                ; AND DX CONTAINS NUM%10
                ; WE SHOULD PRINT DX IN REVERSE ORDER
                PUSH DX
                ; INCREMENTING COUNTER 
                INC CX

                ; CHECK IF THE NUM IS 0
                OR AX, AX
                JZ @BREAK_WHILE_PRINT; HERE CX IS ALWAYS > 0

                ; GO AGAIN BACK TO LOOP
                JMP @WHILE_PRINT

            @BREAK_WHILE_PRINT:

            ;MOV AH, 2
            ;MOV DL, CL 
            ;OR DL, 30H
            ;INT 21H
            @LOOP_PRINT:
                POP DX
                OR DX, 30h
                MOV AH, 2
                INT 21h

                LOOP @LOOP_PRINT

        CALL PRINT_NEWLINE
        ; RESTORE THE REGISTERS
        POPF
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        
        RET


    PRINT_DECIMAL_INTEGER ENDP

END MAIN
