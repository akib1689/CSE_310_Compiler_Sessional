#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H
#include "scope_table.cpp"
using namespace std;

/**
 * @brief This is the symbol table of a program this
 * stores all the information about the program
 * Actually it is a stack of scope table with innermost stack on the top
 * Here the stack is implemented using linked list concept
 */

class symbol_table {
   private:
    int length;              // length of bucket size of each table
    int global_scope_count;  // keeps track of the global scope

    scope_table* top;
    void ensure_scope();

   public:
    symbol_table(int);

    //---------dictionary function-----------
    void insert(string, string);
    symbol_info* search(string);
    bool remove(string);
    //---------overloaded function-----------
    void insert(string, string, FILE*);
    void print_all(FILE*);

    //--------util function------------------
    void create_scope();
    bool delete_scope();

    //--------print function-----------------
    void print_all();
    void print_top();

    ~symbol_table();
};
#endif // SYMBOL_TABLE_H