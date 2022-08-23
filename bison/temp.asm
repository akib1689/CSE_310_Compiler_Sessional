.MODEL SMALL
.STACK 400H	
.DATA
.CODE
	
	f PROC
		PUSH BP		
		MOV BP, SP	
		SUB SP, 2			
		PUSH [BP + -2]				
		PUSH 5			
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		@L_1: 		
		PUSH [BP + -2]				
		PUSH 0			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JG @L_2
		PUSH 0		
		JMP @L_3
		@L_2:
		POP AX		
		CMP AX, 0		
		JE @L_4		
		
		PUSH [BP + 4]				
		
		POP 	AX			
		INC 	AX			
		MOV [BP+4], AX		
		POP AX				
		PUSH [BP + -2]				
		
		POP 	AX			
		DEC 	AX			
		MOV [BP+-2], AX		
		POP AX				
		JMP @L_1		
		@L_4: 		
		PUSH 3			
		PUSH [BP + 4]				
		
		
		POP BX		
		POP AX		
		IMUL BX		
		PUSH AX		
		PUSH 7			
		
		POP BX		
		POP AX		
		SUB AX, BX	
		PUSH AX		
		
		POP AX		
		MOV SP, BP		
		POP BP			
		RET 2		
		PUSH [BP + 4]				
		PUSH 9			
		
		POP AX				
		MOV [BP + 4], AX	
		POP AX				
	f ENDP
	
	g PROC
		PUSH BP		
		MOV BP, SP	
		SUB SP, 2			
		SUB SP, 2			
		PUSH [BP + -2]				
		PUSH [BP + 6]				
		CALL f			
		PUSH AX				
		PUSH [BP + 6]				
		
		POP BX		
		POP AX		
		ADD AX, BX	
		PUSH AX		
		PUSH [BP + 4]				
		
		POP BX		
		POP AX		
		ADD AX, BX	
		PUSH AX		
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		PUSH [BP + -4]				
		PUSH 0			
		
		POP AX				
		MOV [BP + -4], AX	
		POP AX				
		
		@L_5:		
		PUSH [BP + -4]				
		PUSH 7			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JL @L_7
		PUSH 0		
		JMP @L_8
		@L_7:
			PUSH 1		
		@L_8:
		POP AX				
		CMP AX, 0		
		JNE @L_10		
		JMP @L_6		
		@L_9:		
		PUSH [BP + -4]				
		
		POP 	AX			
		INC 	AX			
		MOV [BP+-4], AX		
		POP AX		
		JMP @L_5		
		@L_10:		
		PUSH [BP + -4]				
		PUSH 3			
		
		
		POP BX		
		POP AX		
		XOR DX, DX		
		IDIV BX		
		PUSH AX		
		PUSH 0			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JE @L_11
		PUSH 0		
		JMP @L_12
		@L_11:
			PUSH 1		
		@L_12:
		
		POP AX			
		CMP AX, 0			
		JE @L_13			
		PUSH [BP + -2]				
		PUSH [BP + -2]				
		PUSH 5			
		
		POP BX		
		POP AX		
		ADD AX, BX	
		PUSH AX		
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		JMP @L_14			
		@L_13:			
		PUSH [BP + -2]				
		PUSH [BP + -2]				
		PUSH 1			
		
		POP BX		
		POP AX		
		SUB AX, BX	
		PUSH AX		
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		@L_14:			
		JMP @L_9		
		@L_6:		
		PUSH [BP + -2]				
		
		POP AX		
		MOV SP, BP		
		POP BP			
		RET 4		
	g ENDP
	
		MOV AX, @DATA
		MOV DS, AX
		PUSH BP		
		MOV BP, SP	
		SUB SP, 2			
		SUB SP, 2			
		SUB SP, 2			
		PUSH [BP + -2]				
		PUSH 1			
		
		POP AX				
		MOV [BP + -2], AX	
		PUSH AX				
		PUSH [BP + -4]				
		PUSH 2			
		
		POP AX				
		MOV [BP + -4], AX	
		POP AX				
		PUSH [BP + -2]				
		PUSH [BP + -2]				
		PUSH [BP + -4]				
		CALL g			
		PUSH AX				
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		
		PUSH [BP + -2]
		CALL PRINT_DECIMAL_INTEGER
		PUSH [BP + -6]				
		PUSH 0			
		
		POP AX				
		MOV [BP + -6], AX	
		POP AX				
		
		@L_15:		
		PUSH [BP + -6]				
		PUSH 4			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JL @L_17
		PUSH 0		
		JMP @L_18
		@L_17:
			PUSH 1		
		@L_18:
		POP AX				
		CMP AX, 0		
		JNE @L_20		
		JMP @L_16		
		@L_19:		
		PUSH [BP + -6]				
		
		POP 	AX			
		INC 	AX			
		MOV [BP+-6], AX		
		POP AX		
		JMP @L_15		
		@L_20:		
		PUSH [BP + -2]				
		PUSH 3			
		
		POP AX				
		MOV [BP + -2], AX	
		POP AX				
		@L_21: 		
		PUSH [BP + -2]				
		PUSH 0			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JG @L_22
		PUSH 0		
		JMP @L_23
		@L_22:
			PUSH 1		
		@L_23:
		POP AX		
		CMP AX, 0		
		JE @L_24		
		
		PUSH [BP + -4]				
		
		POP 	AX			
		INC 	AX			
		MOV [BP+-4], AX		
		POP AX				
		PUSH [BP + -2]				
		
		POP 	AX			
		DEC 	AX			
		MOV [BP+-2], AX		
		POP AX				
		JMP @L_21		
		@L_24: 		
		JMP @L_19		
		@L_16:		
		
		PUSH [BP + -2]
		CALL PRINT_DECIMAL_INTEGER
		
		PUSH [BP + -4]
		CALL PRINT_DECIMAL_INTEGER
		
		PUSH [BP + -6]
		CALL PRINT_DECIMAL_INTEGER
		PUSH 0			
		
		MOV AH, 4CH
		INT 21H
	main ENDP
	PRINT_NEWLINE PROC
		
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
		
		
		
		PUSH BP
		MOV BP, SP
		
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
		
		
		
		
		PUSH BP
		MOV BP, SP
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSHF
		MOV AX, [BP+4]
		
		JNS @POSITIVE_NUMBER
		
		PUSH AX
		MOV AH, 2
		MOV DL, 2Dh
		INT 21h
		
		POP AX
		
		NEG AX
		@POSITIVE_NUMBER:
		
		XOR CX, CX      
		MOV BX, 0Ah
		@WHILE_PRINT:
				
				XOR DX, DX
				
				DIV BX
				
				
				
				PUSH DX
				
				INC CX
				
				OR AX, AX
				JZ @BREAK_WHILE_PRINT
				
				JMP @WHILE_PRINT
		@BREAK_WHILE_PRINT:
		
		
		
		
		@LOOP_PRINT:
				POP DX
				OR DX, 30h
				MOV AH, 2
				INT 21h
				LOOP @LOOP_PRINT
		CALL PRINT_NEWLINE
		
		POPF
		POP DX
		POP CX
		POP BX
		POP AX
		POP BP
		RET
PRINT_DECIMAL_INTEGER ENDP
END MAIN
