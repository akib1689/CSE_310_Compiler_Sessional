#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H

#include <iostream>
#include "param.cpp"
#include <vector>
using namespace std;

/*
 * Node class to store the symbol info
 */
class symbol_info {
   private:
    symbol_info* next;
    string name;
    string identifier;

    int size;       // defined for array
    bool defined;
    vector<param> params;   // defined for function

   public:
    symbol_info(string, string);
    symbol_info(const symbol_info&);
    symbol_info(string, string, int);
    symbol_info(string, string, vector<param>);
    ~symbol_info();

    string get_name();
    int get_size();
    void add_param(string name, string identifier);
    string get_identifier();
    symbol_info* get_next();
    vector<param> get_params();
    int total_params();
    bool is_defined();
    void set_defined(bool);
    bool is_array();
    bool is_function();
    bool is_variable();
    void set_next(symbol_info*);
    void print_node();
    void print_node(FILE*);
};



#endif // SYMBOL_INFO_H