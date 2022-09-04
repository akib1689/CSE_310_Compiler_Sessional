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
    code += "\t\tMOV AH, 4CH\n";
    code += "\t\tINT 21H";
    code += "\n";
    print_asm_to_file(asm_file, code);
}

/**
 * @brief function to print declare a procedre
 * @param asm_file  the file for asm code
 * @param proc_name name of the procedure
 */
void declare_procedure(FILE* asm_file, string proc_name){
    string code = "\t;declaring procedure " + proc_name +"\n";
    code += "\t" + proc_name + " PROC\n";

    if (proc_name == "main"){
        code += "\t\tMOV AX, @DATA\n";
        code += "\t\tMOV DS, AX\n";
    } 
    code += "\n";
    code += "\t\tPUSH BP\t\t;save BP\n";
    code += "\t\tMOV BP, SP\t;set BP to SP\n";

    print_asm_to_file(asm_file, code);
    
}

void terminate_proc(FILE* asm_file, string proc_name, string proc_ret_type, int proc_param_count){
    if(proc_name == "main" && proc_ret_type == "VOID"){
			return_to_dos(asm_file);
    } else if (proc_ret_type == "VOID") {
        // other case will have return;
        string code = "\t\tMOV SP, BP\t;restoring the value of stack\n";
        code += "\t\tPOP BP\t\t;restoring the value of base pointer\n";
        code += "\t\tRET " + (proc_param_count*2);

        print_asm_to_file(asm_file, code);
    }
}


/**
 * @brief function that prints predefined functions to assembly file
 * @param asm_file the file to print the predefined functions
 * 
 */
void print_newline_proc(FILE* asm_file){
    string str = "\tPRINT_NEWLINE PROC\n\
\t\t; PRINTS A NEW LINE WITH CARRIAGE RETURN\n\
\t\tPUSH AX\n\
\t\tPUSH DX\n\
\t\tMOV AH, 2\n\
\t\tMOV DL, 0Dh\n\
\t\tINT 21h\n\
\t\tMOV DL, 0Ah\n\
\t\tINT 21h\n\
\t\tPOP DX\n\
\t\tPOP AX\n\
\t\tRET\n\
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
\t\t; PRINTS A 8 bit CHAR \n\
\t\t; INPUT : GETS A CHAR VIA STACK\n\ 
\t\t; OUTPUT : NONE\n\
\t\tPUSH BP\n\
\t\tMOV BP, SP\n\
\t\t; STORING THE GPRS\n\
\t\tPUSH AX\n\
\t\tPUSH BX\n\
\t\tPUSH CX\n\
\t\tPUSH DX\n\
\t\tPUSHF\n\
\t\tMOV DX, [BP + 4]\n\
\t\tMOV AH, 2\n\
\t\tINT 21H\n\
\t\tPOPF\n\
\t\tPOP DX\n\
\t\tPOP CX\n\
\t\tPOP BX\n\
\t\tPOP AX\n\
\t\tPOP BP\n\
\t\tRET 2\n\
PRINT_CHAR ENDP";
    print_asm_to_file(asm_file, str);
}

void print_int_print_proc(FILE* asm_file){
    string str = "\tPRINT_DECIMAL_INTEGER PROC NEAR\n\
\t\t; PRINTS SIGNED INTEGER NUMBER WHICH IS IN HEX FORM IN ONE OF THE REGISTER\n\
\t\t; INPUT : CONTAINS THE NUMBER  (SIGNED 16BIT) IN STACK\n\
\t\t; OUTPUT : \n\
\t\t; STORING THE REGISTERS\n\
\t\tPUSH BP\n\
\t\tMOV BP, SP\n\
\t\tPUSH AX\n\
\t\tPUSH BX\n\
\t\tPUSH CX\n\
\t\tPUSH DX\n\
\t\tPUSHF\n";
str+= "\t\tMOV AX, [BP+4]\n\
\t\t; CHECK IF THE NUMBER IS NEGATIVE\n\
\t\tOR AX, AX\n\
\t\tJNS @POSITIVE_NUMBER\n\
\t\t; PUSHING THE NUMBER INTO STACK BECAUSE A OUTPUT IS WILL BE GIVEN\n\
\t\tPUSH AX\n\
\t\tMOV AH, 2\n\
\t\tMOV DL, 2Dh\n\
\t\tINT 21h\n\
\t\t; NOW IT'S TIME TO GO BACK TO OUR MAIN NUMBER\n\
\t\tPOP AX\n\
\t\t; AX IS IN 2'S COMPLEMENT FORM\n\
\t\tNEG AX\n";
str+="\t\t@POSITIVE_NUMBER:\n\
\t\t; NOW PRINTING RELATED WORK GOES HERE\n\
\t\tXOR CX, CX      ; CX IS OUR COUNTER INITIALIZED TO ZERO\n\
\t\tMOV BX, 0Ah\n\
\t\t@WHILE_PRINT:\n\
\t\t\t\t; WEIRD DIV PROPERTY DX:AX / BX = VAGFOL(AX) VAGSESH(DX)\n\
\t\t\t\tXOR DX, DX\n\
\t\t\t\t; AX IS GUARRANTEED TO BE A POSITIVE NUMBER SO DIV AND IDIV IS SAME\n\
\t\t\t\tDIV BX\n\
\t\t\t\t; NOW AX CONTAINS NUM/10\n\
\t\t\t\t; AND DX CONTAINS NUM%10\n\
\t\t\t\t; WE SHOULD PRINT DX IN REVERSE ORDER\n\
\t\t\t\tPUSH DX\n\
\t\t\t\t; INCREMENTING COUNTER\n\
\t\t\t\tINC CX\n\
\t\t\t\t; CHECK IF THE NUM IS 0\n\
\t\t\t\tOR AX, AX\n\
\t\t\t\tJZ @BREAK_WHILE_PRINT; HERE CX IS ALWAYS > 0\n\
\t\t\t\t; GO AGAIN BACK TO LOOP\n\
\t\t\t\tJMP @WHILE_PRINT\n\
\t\t@BREAK_WHILE_PRINT:";
str += "\n\
\t\t;MOV AH, 2\n\
\t\t;MOV DL, CL \n\
\t\t;OR DL, 30H\n\
\t\t;INT 21Hn\n\
\t\t@LOOP_PRINT:\n\
\t\t\t\tPOP DX\n\
\t\t\t\tOR DX, 30h\n\
\t\t\t\tMOV AH, 2\n\
\t\t\t\tINT 21h\n\
\t\t\t\tLOOP @LOOP_PRINT\n\
\t\tCALL PRINT_NEWLINE";
str+="\n\
\t\t; RESTORE THE REGISTERS\n\
\t\tPOPF\n\
\t\tPOP DX\n\
\t\tPOP CX\n\
\t\tPOP BX\n\
\t\tPOP AX\n\
\t\tPOP BP\n\
\t\tRET\n\
PRINT_DECIMAL_INTEGER ENDP";
    print_asm_to_file(asm_file, str);
}

void print_predefined_proc(FILE* asm_file){
    print_newline_proc(asm_file);
    print_char_print_proc(asm_file);
    print_int_print_proc(asm_file);
    print_asm_to_file(asm_file, "END MAIN");
}

/**
 * @brief function to remove assembly comments from the line
 * @param line the line to remove comments from
 * @return the line without comments
 */
char* remove_comments(char* line){
    char* temp = (char*)malloc(sizeof(char)*(strlen(line)+1));
    strcpy(temp, line);
    char* comment_start = strstr(temp, ";");
    if(comment_start != NULL){
        *comment_start = '\n';
        *(comment_start+1) = '\0';
    }
    // replace tabs with spaces
    char* tab_start = strstr(temp, "\t");
    while(tab_start != NULL){
        *tab_start = ' ';
        tab_start = strstr(temp, "\t");
    }
    return temp;
}


/**
 * @brief this function optimizes the assembly code by
 *        removing unnecessary labels and comments
 *        push consicutive statements to one line
 * @param asm_file      the file to optimize
 * @return              if there is any push pop statement that is changed
 */
bool optimize_asm_code_push(FILE* asm_file, char* file_name, char* dest_file, bool marker){
    vector<string> lines;

    bool no_change = true;

    // open the file in reading mode
    freopen(file_name, "r", asm_file);
    FILE *optimized_file = fopen(dest_file, "w");
    char *line;         // pointer to a line in the file
    size_t len = 0;     // length of the line
    ssize_t read;       // number of bytes read from the file

    // read the file line by line
    while ((read = getline(&line, &len, asm_file)) != -1) {
        char* line_without_comments = remove_comments(line);

        // check the length of the line
        if (strlen(line_without_comments) == 1) {
            continue;
        }
        // cout<<line_without_comments<<strlen(line_without_comments)<<endl;
        lines.push_back(line_without_comments);
    }

    // delete the lines with only newline
    for(int i = 0; i < lines.size(); i++){
        if(lines[i].length() == 1){
            lines.erase(lines.begin()+i);
            i--;
        }
    }
/* 
    for (int i = 0; i < lines.size()-1; i++){
        if (lines[i].find("PUSH") != string::npos && lines[i+1].find("POP") != string::npos) {
            string pushed_value = lines[i].substr(lines[i].find(" ")+1);
            string popped_value = lines[i+1].substr(lines[i+1].find(" ")+1);
            // cout<<"found the consicutive push pop "<< pushed_value << " " << popped_value <<endl;

            if (pushed_value == popped_value) {
                // erase both the values
                lines[i] = '\0';
                lines[i+i] = '\0';
                
            } else {
                // else replace the push pop with mov
                lines[i] = "MOV " + popped_value + ", " + pushed_value;
                lines[i] = '\0';
            }
            no_change = false;
        }
    } 

    if(marker){
        freopen(file_name, "w", asm_file);
    }

 */
    // print the lines in the optimized file
    for (int i = 0; i < lines.size(); i++){
        // size of the line[i] variable
        // cout<<lines[i]<<" "<<len<<endl;
        print_asm_to_file(optimized_file, lines[i]);
        if (marker)
        {
            print_asm_to_file(asm_file, lines[i]);
        }
        
    }

    fclose(optimized_file);                      // close the temp file
    freopen(file_name, "a", asm_file);     // reopen the assembly file in append mode
    cout<<"pass finished"<<endl;
    return no_change;
} 
#endif // ASSEMBLY_H