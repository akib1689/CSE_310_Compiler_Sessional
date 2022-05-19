#include <iostream>
#include <vector>

#include "linked_list.cpp"

using namespace std;

/**
 * The hashtable class to store the symbol information
 * It stores all the information reguading a scope
 */

class scope_table {
   private:
    int length;
    vector<linked_list> array;
    unsigned int hash_value(string);

   public:
    scope_table(int);

    //-------dictionary function----------
    void insert(string, char);
    void insert(string, char, int);
    bool remove(string);
    symbol_info* search(string);

    void print();

    ~scope_table();
};

scope_table::scope_table(int length) {
    this->length = length;
    this->array.resize(length);
}

scope_table::~scope_table() {}

//--------------------private util function---------------------------
/**
 * @brief hash function to calculate the standard hash function of the name
 * passed to the function
 *
 * @param name              name of the symbol whose hash is to be determined
 * @return unsigned int     hash value of the name
 */
unsigned int scope_table::hash_value(string name) {
    hash<string> standard_hash;
    return (standard_hash(name) % length);
}

//----------------dictionary function-----------------------
/**
 * @brief findes the hash value that is in what table the symbol is to be placed
 * then adds to that table
 *
 * @param name          name of the symbol
 * @param identifier    symbol type
 * @param value         initial value of the symbol if the symbol is variable
 */
void scope_table::insert(string name, char identifier, int value) {
    unsigned int hash_val = this->hash_value(name);
    array[hash_val].insert(name, identifier, value);
}

/**
 * @brief overloaded function to insert those symbol that is not variable
 *
 * @param name          name of the symbol
 * @param identifier    symbol type
 */
void scope_table::insert(string name, char identifier) {
    unsigned int hash_val = this->hash_value(name);
    array[hash_val].insert(name, identifier);
}

/**
 * @brief searches the symbol in the table
 * This function first calculates the hash value of any string then it searches
 * the the symbol from thath linked list
 *
 * @param name              name of the variable that is to be searched
 * @return symbol_info*     the symbol info pointer if the symbol is present
 * @return NULL             if the symbol is not found
 */
symbol_info* scope_table::search(string name) {
    unsigned int hash_val = this->hash_value(name);
    return array[hash_val].search(name);
}

/**
 * @brief function to remove a symbol from a table
 * Useful to implement the functionality of delete
 * calculates the hash value then removes from that particular linked list
 *
 * @param name      name of the symbol that is to be removed
 * @return true     if the removal is successful
 * @return false    if the removal is unsuccessful (symbol is not present)
 */
bool scope_table::remove(string name) {
    unsigned int hash_val = this->hash_value(name);
    return array[hash_val].remove(name);
}

//-----------------print function--------------
void scope_table::print() {
    for (int i = 0; i < length; i++) {
        cout<<i<<"----";
        array[i].print();
        cout<<endl;
    }
}