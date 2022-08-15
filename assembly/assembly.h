#ifndef ASSEMBLY_H
#define ASSEMBLY_H 1

#include <bits/stdc++.h>

void print_to_file(FILE* filename, string content){
    fprintf(filename, "%s\n", content.c_str());
}

void init_assembly_file(FILE* assembly_file, vector<pair<string, int>> global_vars){
    string code = "";
    code += ".MODEL SMALL\n";
    code += ".STACK 100H\n";
    code += "\n";

    code += ".DATA\n";
    code += "\tprint_var DW ?\n";

    print_to_file(assembly_file, code);


    // print the global variables
    for (int i = 0; i < global_vars.size(); i++) {
        
        
    }
    
}



#endif // ASSEMBLY_H