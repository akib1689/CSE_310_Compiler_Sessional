#include "symbol_info.h"
/** constructor
 * @param name name of the symbol
 * @param identifier the type of symbol 
 * @param value the current value of the symbol (it is applicable to only variables)
*/
symbol_info::symbol_info(string name, string identifier) {
    this->name = name;
    this->identifier = identifier;
    this->size = 0;
    this->defined = false;
    this->next = NULL;
}
/** constructor for array
 * @param name name of the symbol
 * @param identifier the type of symbol 
 * @param size the size of the array
*/
symbol_info::symbol_info(string name, string identifier, int size) {
    this->name = name;
    this->identifier = identifier;
    this->size = size;
    this->defined = false;
    this->next = NULL;
}
/** constructor for function
 * @param name name of the symbol
 * @param identifier the type of symbol 
 * @param params the parameters of the function
*/
symbol_info::symbol_info(string name, string identifier, vector<param> params) {
    this->name = name;
    this->identifier = identifier;
    this->size = -1;
    this->params = params;
    this->defined = false;
    this->next = NULL;
}

// copy constructor
symbol_info::symbol_info(const symbol_info& that) {
    this->name = new char;
    this->name = that.name;
    this->identifier = that.identifier;
    this->next = that.next;
    this->size = that.size;
    this->defined = that.defined;
    this->params = that.params;
}

// destructor
symbol_info::~symbol_info() {
    // patience
    // don't do anything stupid
 }

// dictionary getter setter

/** function to set the next node of this node
 * @param next the node that is next to this node
 */
void symbol_info::set_next(symbol_info* next) { this->next = next; }

void symbol_info::set_defined(bool defined) { this->defined = defined; }

symbol_info* symbol_info::get_next() { return this->next; }

string symbol_info::get_name() { return this->name; }

string symbol_info::get_identifier() { return this->identifier; }

bool symbol_info::is_array() {return (this->size > 0);}

bool symbol_info::is_function() {return (this->size == -1);}

bool symbol_info::is_variable() {return (this->size == 0);}

bool symbol_info::is_defined() {return this->defined;}

int symbol_info::get_size() {return this->size;}


int symbol_info::total_params() {return this->params.size();}

void symbol_info::add_param(string name, string identifier) {
    this->params.push_back(param(name, identifier));
}

vector<param> symbol_info::get_params() {return this->params;}




// function to print the node
void symbol_info::print_node() {
    cout<<"<" << (this->name) << " : " << this->identifier << ">";
}

// finction to print the node in a file passed to the function
void symbol_info::print_node(FILE *file) {
    fprintf(file, "<%s : %s>", this->name.c_str(), this->identifier.c_str());
}