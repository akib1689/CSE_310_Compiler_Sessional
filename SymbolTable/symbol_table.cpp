#include <iostream>
#include <stack>

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
    int length;  // length of bucket size of each table

    scope_table* top;

   public:
    symbol_table(int length);

    //---------dictionary function-----------
    void insert(string, string);
    symbol_info* search(string);
    bool remove(string);

    //--------util function------------------
    void create_scope();
    bool delete_scope();

    //--------print function-----------------
    void print_all();
    void print_top();

    ~symbol_table();
};

symbol_table::symbol_table(int length) {
    this->length = length;
    this->top = new scope_table(length, NULL);
}

symbol_table::~symbol_table() { delete top; }

//-----------dictionary function------------
void symbol_table::insert(string name, string identifier) {
    top->insert(name, identifier);
}

symbol_info* symbol_table::search(string name) { top->search(name); }

bool symbol_table::remove(string name) {}

//------------creation and deletion of scope-----------------
/**
 * @brief this function creates a new scope it
 * This creates a scope and puts it at the top of the stack
 */
void symbol_table::create_scope() {
    scope_table* new_scope = new scope_table(length, this->top);
    this->top = new_scope;
}
/**
 * @brief this function removes the topmost element of the stack
 * innermost scope of the program. this is called whenever '}' braces appears
 *
 * @return true     if the deletion is successful
 * @return false    if the deletion is not successful (in case of the programmer
 * wants to delete the root scope)
 */
bool symbol_table::delete_scope() {
    scope_table* new_top = this->top->get_parent();
    if (new_top == NULL) {
        return false;
    }

    this->top = new_top;
    return true;
}

/**
 * @brief prints the inner most scope and that's varaiable
 *
 */
void symbol_table::print_top() { this->top->print(); }
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