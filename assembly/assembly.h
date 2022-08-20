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
string remove_comments(char* line){
    string line_without_comments = "";
    int i = 0;
    while(line[i] != '\0' && line[i] != '\n'){
        if(line[i] == ';'){
            break;
        }else if (line[i] == '\t'){
            i++;
            continue;
        }
        line_without_comments += line[i];
        i++;
    }
    return line_without_comments;
}


/**
 * @brief this function optimizes the assembly code by
 *        removing unnecessary labels and comments
 *        push consicutive statements to one line
 * @param asm_file      the file to optimize
 */
/* void optimize_asm_code(FILE* asm_file){
    vector<string> lines;

    // open the file in reading mode
    freopen("assembly.asm", "r", asm_file);
    FILE *optimized_file = fopen("optimized.asm", "w");
    char *line;         // pointer to a line in the file
    size_t len = 0;     // length of the line
    ssize_t read;       // number of bytes read from the file

    // read the file line by line
    while ((read = getline(&line, &len, asm_file)) != -1) {
        // remove comments from the line
        string line_wc = remove_comments(line);
        // if the line is not empty
        if (line_wc.length() != 0)
        {
            lines.push_back(remove_comments(line));
        }
    }

    
    for (int i = 0; i < lines.size()-1; i++) {
        
    }

    int count = 0;
    while (count < lines.size()) {
        // if there is two consecutive push pop statements
        // then remove the second one
        // and replace with mov
        if (lines[count].find("PUSH") != string::npos && lines[count+1].find("POP") != string::npos) {
            // find the pushed value
            string pushed_value = lines[count].substr(lines[count].find(" ")+1);
            // find the popped value
            string popped_value = lines[count+1].substr(lines[count+1].find(" ")+1);
            // if the pushed value is the same as the popped value
            // then do nothing
            if (pushed_value == popped_value) {
                lines.erase(lines.begin()+count);
                lines.erase(lines.begin()+count);
            } else {
                // else replace the push pop with mov
                lines[count] = "MOV " + popped_value + ", " + pushed_value;
                lines.erase(lines.begin()+(count+1));
            }
            lines.erase(lines.begin()+(count+1));
        } else {
            count++;
        }
    }
    

     

    // print the lines in the optimized file
    for (int i = 0; i < lines.size(); i++){
        // size of the line[i] variable
        // cout<<lines[i]<<" "<<len<<endl;
        print_asm_to_file(optimized_file, lines[i]);
    }

    fclose(optimized_file);                      // close the temp file
    freopen("assembly.asm", "a", asm_file);     // reopen the assembly file in append mode
} */

void optimize_asm_code(FILE *asm_file)
{
    vector<string> code_list;
    vector<string> token_up;
    vector<string> token_down;

    ifstream file_in("code.asm");
    string temp;

    while (getline(file_in, temp))
    {
        code_list.push_back(temp);
    }

    int line_count = code_list.size();

    for (int i = 0; i < line_count - 1; i++)
    {
        if ((code_list[i].size() < 4) || (code_list[i + 1].size() < 4))
        {
            print_asm_to_file(asm_file, code_list[i]);
        }
        else if ((code_list[i].substr(1, 3) == "MOV") && (code_list[i + 1].substr(1, 3) == "MOV"))
        {
            stringstream ss_up(code_list[i]);
            stringstream ss_down(code_list[i + 1]);

            while (getline(ss_up, temp, ' '))
            {
                token_up.push_back(temp);
            }

            while (getline(ss_down, temp, ' '))
            {
                token_down.push_back(temp);
            }

            if ((token_up[1].substr(0, token_up[1].size() - 1) == token_down[2]) && (token_down[1].substr(0, token_down[1].size() - 1) == token_up[2]))
            {
                print_asm_to_file(asm_file, code_list[i]);
                i++;
            }
            else
            {
                print_asm_to_file(asm_file, code_list[i]);
            }

            token_up.clear();
            token_down.clear();
        }
        else
        {
            print_asm_to_file(asm_file, code_list[i]);
        }
    }
}

#endif // ASSEMBLY_H