#include <iostream>
using namespace std;
/*
 * Node class to store the symbol info
 */
class symbol_info {
   private:
    symbol_info* next;
    char* name;
    char identifier;
    int value;

   public:
    symbol_info(char*, char, int);
    symbol_info(const symbol_info&);
    ~symbol_info();

    int get_value();
    char* get_name();
    char get_identifier();
    symbol_info* get_next();
    void set_value(int);
    void set_next(symbol_info*);

    void print_node();
};

/** constructor
 * @param name name of the symbol
 * @param identifier the type of symbol 
 * @param value the current value of the symbol (it is applicable to only variables)
*/
symbol_info::symbol_info(char* name, char identifier, int value) {
    this->name = new char;
    *(this->name) = *(name);
    this->name = name;
    this->identifier = identifier;
    this->value = value;
    next = NULL;
}

// copy constructor
symbol_info::symbol_info(const symbol_info& that) {
    this->name = new char;
    *(this->name) = *(that.name);
    this->identifier = that.identifier;
    this->value = that.value;
    this->next = that.next;
}

// destructor
symbol_info::~symbol_info() { delete this->name; }

// dictionary getter setter
void symbol_info::set_value(int value) { this->value = value; }

/** function to set the next node of this node
 * @param next the node that is next to this node
 */
void symbol_info::set_next(symbol_info* next) { this->next = next; }

symbol_info* symbol_info::get_next() { return this->next; }

char* symbol_info::get_name() { return this->name; }

char symbol_info::get_identifier() { return this->identifier; }

int symbol_info::get_value() { return this->value; }

// function to print the node
void symbol_info::print_node() {
    cout << (this->name) << " " << this->identifier << " " << this->value;
}
