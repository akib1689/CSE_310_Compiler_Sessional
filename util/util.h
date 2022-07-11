#include<bits/stdc++.h>
#include "../symbol_table/param.h"

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
            param_list.push_back(param("", param_str_split[0]));
        }
        else if(param_str_split.size() == 2){
            param_list.push_back(param(param_str_split[1], param_str_split[0]));
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
        string param_type = param_str_split[0];
        param_type_list.push_back(param("", param_type));
    }
    return param_type_list;
}