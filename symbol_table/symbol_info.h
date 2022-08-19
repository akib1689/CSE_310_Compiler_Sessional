#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H 1

#include <iostream>
#include "param.h"
#include <vector>
using namespace std;

/**
 * Node class to store the symbol info
 */
class symbol_info {
   private:
    symbol_info* next;
    string name;
    string identifier;
    string asm_name;

    int size;               // defined for array as the size of the array
                            // for function : -1 for variable: 0
    bool defined;           // defined for funciton
    vector<param> params;   // defined for function

    int offset;             // defined for variable

   public:
    /** constructor
     * @param name name of the symbol
     * @param identifier the type of symbol (variable, array, function)
    */
    symbol_info(string name, string identifier) {
        this->name = name;
        this->identifier = identifier;
        this->size = 0;
        this->offset = 0;
        this->defined = false;
        this->next = NULL;
        this->asm_name = "";
    }
    /** overloaded constructor variable
     * @param name name of the symbol
     * @param identifier the type of symbol (variable, array, function)
     * @param asm_name the asm name of the variable
     */
    symbol_info(string name, string identifier, string asm_name) {
        this->name = name;
        this->identifier = identifier;
        this->asm_name = asm_name;
        this->size = 0;
        this->offset = 0;
        this->defined = false;
        this->next = NULL;
    }
    /** constructor for array
     * @param name name of the symbol
     * @param identifier the type of symbol 
     * @param size the size of the array
    */
    symbol_info(string name, string identifier, int size) {
        this->name = name;
        this->identifier = identifier;
        this->size = size;
        this->offset = 0;
        this->defined = false;
        this->next = NULL;
        this->asm_name = "";
    }
    /** constructor for function
     * @param name name of the symbol
     * @param identifier the type of symbol (this works as return type of the function)
     * @param params the parameters of the function
    */
    symbol_info(string name, string identifier, vector<param> params) {
        this->name = name;
        this->identifier = identifier;
        this->size = -1;
        this->offset = 0;
        this->params = params;
        this->defined = false;
        this->next = NULL;
        this->asm_name = "";
    }

    // copy constructor
    symbol_info(const symbol_info& that) {
        this->name = new char;
        this->name = that.name;
        this->identifier = that.identifier;
        this->next = that.next;
        this->size = that.size;
        this->offset = that.offset;
        this->defined = that.defined;
        this->params = that.params;
        this->asm_name = that.asm_name;
    }

    // destructor
    ~symbol_info() {
        // patience
        // don't do anything stupid
    }

    // dictionary getter setter

    void set_next(symbol_info* next) { this->next = next; }

    void set_defined(bool defined) { this->defined = defined; }

    void set_asm_name(string asm_name) { this->asm_name = asm_name; }

    void set_offset(int offset) { this->offset = offset; }

    symbol_info* get_next() { return this->next; }

    string get_name() { return this->name; }

    string get_identifier() { return this->identifier; }

    string get_asm_name() { return this->asm_name; }

    bool is_array() {return (this->size > 0);}

    bool is_function() { return (this->size == -1); }

    bool is_variable() { return (this->size == 0); }

    bool is_defined() { return this->defined; }

    int get_size() { return this->size; }

    int get_offset() { return this->offset; }


    int get_param_count() { return this->params.size(); }

    void add_param(string name, string type) {
        this->params.push_back(param(name, type));
    }

    vector<param> get_params() { return this->params; }


    // function to print the node
    void print_node() {
        cout<<"<" << (this->name) << " : " << this->identifier << ">";
    }

    // finction to print the node in a file passed to the function
    void print_node(FILE *file) {
        string str = this->identifier;
        if (this->is_array() || this->is_function() || this->is_variable()) {
            str = "ID";
        }
        fprintf(file, "<%s : %s>", this->name.c_str(), str.c_str());
    }
};
#endif // SYMBOL_INFO_H