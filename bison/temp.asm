.MODEL SMALL
.STACK 400H	
.DATA
.CODE
	
	main PROC
		MOV AX, @DATA
		MOV DS, AX
		PUSH BP		
		MOV BP, SP	
		SUB SP, 2			
		SUB SP, 2			
		SUB SP, 2			
		SUB SP, 2			
		PUSH [BP + -2]				
		PUSH 0			
		
		POP AX				
		MOV [BP + -2], AX	

		POP AX				
		
		@L_1:		
		PUSH [BP + -2]				
		PUSH 6			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JL @L_3
		PUSH 0		
		JMP @L_4
		@L_3:
			PUSH 1		
		@L_4:
		POP AX				
		CMP AX, 0		
		JNE @L_6		

		@L_5:		
		PUSH [BP + -2]				
		
		POP 	AX			
		PUSH AX			
		INC 	AX			
		MOV [BP+-2], AX		
		POP AX		
		JMP @L_1		
		@L_6:		
		
		PUSH [BP + -2]
		CALL PRINT_DECIMAL_INTEGER
		JMP @L_5		
		@L_2:		
		PUSH [BP + -6]				
		PUSH 4			
		
		POP AX				
		MOV [BP + -6], AX	

		POP AX				
		PUSH [BP + -8]				
		PUSH 6			
		
		POP AX				
		MOV [BP + -8], AX	

		POP AX				
		@L_7: 		
		PUSH [BP + -6]				
		PUSH 0			
		
		POP BX		
		POP AX		
		CMP AX, BX	
		JG @L_8
		PUSH 0		
		JMP @L_9
		@L_8:
			PUSH 1		
		@L_9:
		POP AX		
		CMP AX, 0		
		JE @L_10		
		
		PUSH [BP + -8]				
		PUSH [BP + -8]				
		PUSH 3			
		
		POP BX		
		POP AX		
		ADD AX, BX	
		PUSH AX		
		
		POP AX				
		MOV [BP + -8], AX	

		POP AX				
		PUSH [BP + -6]				
		
		POP 	AX			
		PUSH AX			
		DEC 	AX			
		MOV [BP+-6], AX		
		POP AX				
		JMP @L_7		
		@L_10: 		
		
		PUSH [BP + -8]
		CALL PRINT_DECIMAL_INTEGER
		
		PUSH [BP + -6]
		CALL PRINT_DECIMAL_INTEGER
		PUSH [BP + -6]				
		PUSH 4			
		
		POP AX				
		MOV [BP + -6], AX	

		POP AX				
		PUSH [BP + -8]				
		PUSH 6			
		
		POP AX				
		MOV [BP + -8], AX	

		POP AX				
		@L_11: 		
		PUSH [BP + -6]				
		
		POP 	AX			
		DEC 	AX			


		POP AX		
		CMP AX, 0		
		JE @L_12		
		
		PUSH [BP + -8]				
		PUSH [BP + -8]				
		PUSH 3			
		
		POP BX		
		POP AX		
		ADD AX, BX	
		PUSH AX		
		
		POP AX				
		MOV [BP + -8], AX	

		POP AX				
		JMP @L_11		
		@L_12: 		
		
		PUSH [BP + -8]
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
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSHF
		MOV DX, [BP + 4]
		MOV AH, 2
		INT 21H

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
		
		OR AX, AX
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
