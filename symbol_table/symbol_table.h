#pragma once
#include "scope_table.h"
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

/**
 * @brief Construct a new symbol table::symbol table object
 *
 * @param length    the bucket size of all the scope hash table
 */
symbol_table::symbol_table(int length) {
    this->length = length;
    this->global_scope_count = 0;
    this->top = NULL;
    this->ensure_scope();
}
/**
 * @brief Destroy the symbol table::symbol table object
 *
 */
symbol_table::~symbol_table() {
    while (this->delete_scope()) {
        // do nothing
    }
}

//------------private util function--------------
/**
 * @brief ensures that there is at least one scope (if the root directory is
 * deleted and then some insert/ remove instruction is given)
 *
 */
void symbol_table::ensure_scope() {
    if (this->top == NULL) {
        this->top = new scope_table(length, ++global_scope_count, NULL);
    }
}

//-----------dictionary function------------
/**
 * @brief function to insert a symbol to the symbol table
 * This function inserts the new symbol to the inner most scope
 *
 * @param name          name of the symbol
 * @param identifier    type of symbol
 */
void symbol_table::insert(string name, string identifier) {
    this->ensure_scope();
    if (top->insert(name, identifier))     {
        this->print_all();
    }
    
    
}
//-----------overloaded function to print to file------------
/**
 * @brief the function is to insert a symbol to the symbol table
 * This function inserts the new symbol to the inner most scope but it receives a file pointer to which the output is written
 * @param name          name of the symbol
 * @param identifier    type of symbol
 * @param fp            file pointer to which the output is written
 */
void symbol_table::insert(string name, string identifier, FILE* fp) {
    this->ensure_scope();
    if (top->insert(name, identifier, fp))     {
        this->print_all(fp);
    }
}
/**
 * @brief function to search a symbol by name in the table
 * This function searches the name at first in the inner most scope then
 * gradually travarses to the top of the scope
 *
 * @param name              name of the symbol that is to be searched
 * @return symbol_info*     the symbol_info type of object that is has this name
 * @return null             if there is no symbol
 */
symbol_info* symbol_table::search(string name) {
    this->ensure_scope();
    return top->search(name);
}
/**
 * @brief function to delete a symbol from the table
 * This function searches the name at the inner most scope first the
 * gradually traverses to the top of the scope
 *
 * @param name          name of the symbol that is to be deleted
 * @return true         successful deletion
 * @return false        otherwise (symbol was not found in that scope and any
 * other parent scope)
 */
bool symbol_table::remove(string name) {
    this->ensure_scope();
    return top->remove(name);
}

//------------creation and deletion of scope-----------------
/**
 * @brief this function creates a new scope it
 * This creates a scope and puts it at the top of the stack
 */
void symbol_table::create_scope() {
    if (this->top == NULL) {
        this->ensure_scope();
        return;
    }

    scope_table* new_scope =
        new scope_table(length, global_scope_count, this->top);
    this->top = new_scope;
}
/**
 * @brief this function removes the topmost element of the stack
 * innermost scope of the program. this is called whenever '}' braces appears
 *
 * @return true     if the deletion is successful and there is a table left in
 * the scope table
 * @return false    if the root directory is deleted (in case of the programmer
 * wants to delete the root scope or there is no scope to delete)
 */
bool symbol_table::delete_scope() {
    if (this->top == NULL) {
        cout << "There is no scope to delete" << endl;
        return false;
    }

    scope_table* new_top = this->top->get_parent();
    delete this->top;
    this->top = new_top;
    if (new_top == NULL) {
        return false;
    }
    return true;
}

//------------------print funciton-------------------------
/**
 * @brief prints the inner most scope and that's varaiable
 *
 */
void symbol_table::print_top() {
    if (this->top == NULL) {
        cout << "There is no scope to print" << endl;
        return;
    }
    this->top->print();
}
/**
 * @brief this function prints all the scope that is currently active
 *
 */
void symbol_table::print_all() {
    scope_table* current = this->top;
    while (current != NULL) {
        current->print();
        cout << endl;
        current = current->get_parent();
    }
}
//----------overloaded print funciton to file-------------------------
/**
 * @brief this function prints all the scope and that's varaiable to the file
 *
 * @param fp    file pointer to which the output is written
 */
void symbol_table::print_all(FILE* fp) {
    scope_table* current = this->top;
    while (current != NULL) {
        current->print(fp);
        fprintf(fp, "\n");
        current = current->get_parent();
    }
}