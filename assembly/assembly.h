#ifndef ASSEMBLY_H
#define ASSEMBLY_H 1

#include <bits/stdc++.h>

void print_asm_to_file(FILE* filename, string content){
    fprintf(filename, "%s\n", content.c_str());
}

void init_assembly_file(FILE* assembly_file){
    string code = "";
    code += ".MODEL SMALL\n";
    code += ".STACK 400H\t;4KB stack\n";
    code += "\n";

    code += ".DATA\n";
    code += ".CODE\n";
    print_asm_to_file(assembly_file, code);  
    
}

/**
 * @brief this function is used to print the name of global variable in the assembly file
 * @param asm_file     the file to print the name of global variable
 * @param name         the name of global variable
 * @param line_number  the line number of the global variable is declared
 */
void print_global_variable_name(FILE* asm_file, string name, int line_number){
    freopen("assembly.asm", "r", asm_file);
    FILE *temp = fopen("temp.txt", "w");
    char *line;         // pointer to a line in the file
    size_t len = 0;     // length of the line
    ssize_t read;       // number of bytes read from the file
    int count = 0;      // number of lines read

    // read the file line by line
    // and print the file to the temp file only in temp file at line 4 we print the name of global variable
    while ((read = getline(&line, &len, asm_file)) != -1) {
        if(count == 4){
            // print the name of global variable on the line 4
            // model small          line-1
            // stack 100h           line-2
            // .data                line-3
            fprintf(temp, "\t%s \t\tDW\t\t?\t\t\t\t\t;Line no %d : %s declared\n", name.c_str(), line_number, name.c_str());
        }
        fprintf(temp, "%s", line);
        count++;
    }

    // now temp contains the assembly file with the name of global variable
    // we need to copy the temp file to the assembly file
    freopen("assembly.asm", "w", asm_file);
    freopen("temp.txt", "r", temp);

    while ((read = getline(&line, &len, temp)) != -1) {
        fprintf(asm_file, "%s", line);
    }

    fclose(temp);                               // close the temp file
    remove("temp.txt");                         // delete the temp file
    freopen("assembly.asm", "a", asm_file);     // reopen the assembly file in append mode  
}

//------------------------------Overloading function for printing global array variable------------------------------
/**
 * @brief this function is used to print the name of global variable in the assembly file
 * @param asm_file     the file to print the name of global variable
 * @param name         the name of global variable
 * @param line_number  the line number of the global variable is declared
 * @param size         the size of the global array variable
 */
void print_global_variable_name(FILE* asm_file, string name, int line_number, int arr_size){
    freopen("assembly.asm", "r", asm_file);
    FILE *temp = fopen("temp.txt", "w");
    char *line;         // pointer to a line in the file
    size_t len = 0;     // length of the line
    ssize_t read;       // number of bytes read from the file
    int count = 0;      // number of lines read

    // read the file line by line
    // and print the file to the temp file only in temp file at line 4 we print the name of global variable
    while ((read = getline(&line, &len, asm_file)) != -1) {
        if(count == 4){
            // print the name of global variable on the line 4
            // model small          line-1
            // stack 100h           line-2
            // .data                line-3
            fprintf(temp, "\t%s \t\tDW \t\t%d\t\tDUP(?)\t\t;Line no %d : %s declared\n", name.c_str(), arr_size, line_number, name.c_str());
        }
        fprintf(temp, "%s", line);
        count++;
    }

    // now temp contains the assembly file with the name of global variable
    // we need to copy the temp file to the assembly file
    freopen("assembly.asm", "w", asm_file);
    freopen("temp.txt", "r", temp);

    while ((read = getline(&line, &len, temp)) != -1) {
        fprintf(asm_file, "%s", line);
    }

    fclose(temp);                               // close the temp file
    remove("temp.txt");                         // delete the temp file
    freopen("assembly.asm", "a", asm_file);     // reopen the assembly file in append mode  
}

/**
 * @brief function is used for terminating the main procedure
 * @param asm_file  the file for asm code
 */
void return_to_dos(FILE* asm_file){
    string code = "\t\t;returning to dos\n";
    code += "\t\tMOV AH, 4CH";
    code += "\t\tINT 24H";
    print_asm_to_file(asm_file, code);
}


/**
 * @brief function that prints predefined functions to assembly file
 * @param asm_file the file to print the predefined functions
 * 
 */
void print_newline_proc(FILE* asm_file){
    string str = "\tPRINT_NEWLINE PROC\n\
        ; PRINTS A NEW LINE WITH CARRIAGE RETURN\n\
        PUSH AX\n\
        PUSH DX\n\
        MOV AH, 2\n\
        MOV DL, 0Dh\n\
        INT 21h\n\
        MOV DL, 0Ah\n\
        INT 21h\n\
        POP DX\n\
        POP AX\n\
        RET\n\
    PRINT_NEWLINE ENDP";

    print_asm_to_file(asm_file, str);
}

/**
 * @brief function that prints predefined functions to assembly file
 * @param asm_file the file to print the predefined functions
 * 
 */
void print_char_print_proc(FILE* asm_file){
    string str = "\tPRINT_CHAR PROC\n\
        ; PRINTS A 8 bit CHAR \n\
        ; INPUT : GETS A CHAR VIA STACK\n\ 
        ; OUTPUT : NONE\n\
        PUSH BP\n\
        MOV BP, SP\n\
        ; STORING THE GPRS\n\
        PUSH AX\n\
        PUSH BX\n\
        PUSH CX\n\
        PUSH DX\n\
        PUSHF\n\
        MOV DX, [BP + 4]\n\
        MOV AH, 2\n\
        INT 21H\n\
        POPF\n\
        POP DX\n\
        POP CX\n\
        POP BX\n\
        POP AX\n\
        POP BP\n\
        RET 2\n\
    PRINT_CHAR ENDP";
    print_asm_to_file(asm_file, str);
}

void print_int_print_proc(FILE* asm_file){
    string str = "\tPRINT_DECIMAL_INTEGER PROC NEAR\n\
        ; PRINTS SIGNED INTEGER NUMBER WHICH IS IN HEX FORM IN ONE OF THE REGISTER\n\
        ; INPUT : CONTAINS THE NUMBER  (SIGNED 16BIT) IN STACK\n\
        ; OUTPUT : \n\
        ; STORING THE REGISTERS\n\
        PUSH BP\n\
        MOV BP, SP\n\
        PUSH AX\n\
        PUSH BX\n\
        PUSH CX\n\
        PUSH DX\n\
        PUSHF\n";
        str+= 
        "\t\tMOV AX, [BP+4]\n\
        ; CHECK IF THE NUMBER IS NEGATIVE\n\
        OR AX, AX\n\
        JNS @POSITIVE_NUMBER\n\
        ; PUSHING THE NUMBER INTO STACK BECAUSE A OUTPUT IS WILL BE GIVEN\n\
        PUSH AX\n\
        MOV AH, 2\n\
        MOV DL, 2Dh\n\
        INT 21h\n\
        ; NOW IT'S TIME TO GO BACK TO OUR MAIN NUMBER\n\
        POP AX\n\
        ; AX IS IN 2'S COMPLEMENT FORM\n\
        NEG AX\n";
        str+="\t\t@POSITIVE_NUMBER:\n\
            ; NOW PRINTING RELATED WORK GOES HERE\n\
            XOR CX, CX      ; CX IS OUR COUNTER INITIALIZED TO ZERO\n\
            MOV BX, 0Ah\n\
            @WHILE_PRINT:\n\
                ; WEIRD DIV PROPERTY DX:AX / BX = VAGFOL(AX) VAGSESH(DX)\n\
                XOR DX, DX\n\
                ; AX IS GUARRANTEED TO BE A POSITIVE NUMBER SO DIV AND IDIV IS SAME\n\
                DIV BX\n\
                ; NOW AX CONTAINS NUM/10\n\
                ; AND DX CONTAINS NUM%10\n\
                ; WE SHOULD PRINT DX IN REVERSE ORDER\n\
                PUSH DX\n\
                ; INCREMENTING COUNTER\n\
                INC CX\n\
                ; CHECK IF THE NUM IS 0\n\
                OR AX, AX\n\
                JZ @BREAK_WHILE_PRINT; HERE CX IS ALWAYS > 0\n\
                ; GO AGAIN BACK TO LOOP\n\
                JMP @WHILE_PRINT\n\
            @BREAK_WHILE_PRINT:";
            str += "\n\
            ;MOV AH, 2\n\
            ;MOV DL, CL \n\
            ;OR DL, 30H\n\
            ;INT 21Hn\n\
            @LOOP_PRINT:\n\
                POP DX\n\
                OR DX, 30h\n\
                MOV AH, 2\n\
                INT 21h\n\
                LOOP @LOOP_PRINT\n\
        CALL PRINT_NEWLINE";
        str+="\n\
        ; RESTORE THE REGISTERS\n\
        POPF\n\
        POP DX\n\
        POP CX\n\
        POP BX\n\
        POP AX\n\
        POP BP\n\
        RET\n\
    PRINT_DECIMAL_INTEGER ENDP";
    print_asm_to_file(asm_file, str);
}

void print_predefined_proc(FILE* asm_file){
    print_newline_proc(asm_file);
    print_char_print_proc(asm_file);
    print_int_print_proc(asm_file);
    print_asm_to_file(asm_file, "END MAIN");
}

#endif // ASSEMBLY_H