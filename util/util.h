#include<bits/stdc++.h>
#include "../symbol_table/param.h"
#include "../symbol_table/symbol_table.h"

using namespace std;
/**
 * @brief this function is used to split the string using a delimiter
 * 
 * @param str           the string to be split
 * @param delimiter     the delimiter to be used
 * @return vector<string> the vector of strings after splitting
 */
vector<string> split(string str, char delimiter){
    vector<string> result;
    stringstream ss(str);
    string token;
    while(getline(ss, token, delimiter)){
        result.push_back(token);
    }
    return result;
}

/**
 * @brief this function is used to check if a string is a declaration of array
 * @param str_to_check the string to be checked in the format of "array_name[size]"
 * @return true if the string is a declaration of array
 * @return false otherwise
 */
bool is_array_declaration(string str_to_check){
    // npos is the default value of string::size_type defined to be -1
    // npos means negative position
    if(str_to_check.find('[') != string::npos && str_to_check.find(']') != string::npos){
        return true;
    }
    return false;
}

/**
 * @brief this function is used to extract the size of an array from a string
 * @param str_array_declaration the string from which size of the array
 *                              is to be extracted in the format of "array_name[size]"
 * @return int the size of the array
 */
int get_array_size(string str_array_declaration){
    int start_index = str_array_declaration.find('[');
    int end_index = str_array_declaration.find(']');
    string str_size = str_array_declaration.substr(start_index + 1, end_index - start_index - 1);
    return stoi(str_size);
}

/**
 * @brief this function is used to extract the name of the array from a string
 * @param str_array_declaration the string from which name of the array
 *                              is to be extracted in the format of "array_name[size]"
 * @return string the name of the array 
 */
string get_array_name(string str_array_declaration){
    int start_index = 0;
    int end_index = str_array_declaration.find('[');
    return str_array_declaration.substr(start_index, end_index);
}
/**
 * @brief this function is a simple dictionary function that returns the
 *        corresponding type of a given type name like int, float, to CONST_INT, CONST_FLOAT, etc.
 * @param type_name the name of the type
 * @return string the corresponding type 
 */
string get_type_name(string type_name){
    if(type_name == "int"){
        return "CONST_INT";
    }
    else if(type_name == "float"){
        return "CONST_FLOAT";
    }
    else if(type_name == "char"){
        return "CONST_CHAR";
    }
    else if(type_name == "string"){
        return "STRING";
    }
    else if(type_name == "bool"){
        return "CONST_BOOL";
    }
    else if(type_name == "void"){
        return "VOID";
    }
    else{
        return "ERROR";
    }
}

/**
 * @brief this function is used to extract the parameter list from a string 
 *        seperated by commas
 * @param param_str the string from which parameter list
 * @return vector<param> the vector of parameters
 */
vector<param> get_param_list(string param_str){
    vector<param> param_list;
    vector<string> param_str_list = split(param_str, ',');
    for(int i = 0; i < param_str_list.size(); i++){
        string param_str = param_str_list[i];
        vector<string> param_str_split = split(param_str, ' ');
        if(param_str_split.size() == 1){
            string param_type = get_type_name(param_str_split[0]);
            param_list.push_back(param("", param_type));
        }
        else if(param_str_split.size() == 2){
            string param_name = param_str_split[1];
            string param_type = get_type_name(param_str_split[0]);
            param_list.push_back(param(param_name, param_type));
        }
    }
    return param_list;
}
/**
 * @brief this function is used to extract the parameter type list from a string
 *       seperated by commas
 * @param param_str the string from which parameter type list
 * @return vector<param> the vector of parameters
 */
vector<param> get_param_type_list(string param_str){
    vector<param> param_type_list;
    vector<string> param_str_list = split(param_str, ',');
    for(int i = 0; i < param_str_list.size(); i++){
        string param_str = param_str_list[i];
        vector<string> param_str_split = split(param_str, ' ');
        string param_type = get_type_name(param_str_split[0]);
        param_type_list.push_back(param("", param_type));
    }
    return param_type_list;
}

/**
 * @brief this function is used to get a new name for a variable
 * @param   temp_var_count      pointer to the count of temporary variables
 * @return                      name of the new variable 
 */
string get_new_var_name(int* temp_var_count){
    string new_var_name = "temp_var_" + to_string((*temp_var_count)++);
    (*temp_var_count) = (*temp_var_count) + 1;
    return new_var_name;
}
/**
 * @brief this function is used to get a new lable for a variables
 * @param   temp_label_count        pointer to the count of temporary labels
 * @return                          name of the new label 
 */
string get_new_var_label(int* temp_label_count){
    string new_var_label = "@L_" + to_string((*temp_label_count)++);
    (*temp_label_count) = (*temp_label_count) + 1;
    return new_var_label;
}

/**
 * @brief this function is used to get a name of the variable w.r.t global scope
 * @param   var_name        variable name of the variable
 * @param   table           the symbol table
 * @return                  name of the variable w.r.t global scope
 */
string get_global_name(string var_name, symbol_table table){
    string temp = var_name + "_" + table.get_top()->get_id();
    return temp;
}

