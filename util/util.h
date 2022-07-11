#include<bits/stdc++.h>

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