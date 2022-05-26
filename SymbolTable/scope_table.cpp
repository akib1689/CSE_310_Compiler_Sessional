#include <iostream>

#include "linked_list.cpp"

using namespace std;

/**
 * @brief
 * The hashtable class to store the symbol information
 * It stores all the information reguading a scope
 * It also has a pointer to maintain a stack
 * so that we can reference the parent scope of the stack
 */

class scope_table {
   private:
    string id;
    int length;
    linked_list* array;
    scope_table* parent;
    int child;

    unsigned int hash_value(string);
    static unsigned long sdbm(string);

   public:
    scope_table(int,int, scope_table*);

    //-------dictionary function----------
    bool insert(string, string);
    bool remove(string);
    symbol_info* search(string);

    //-------getter-----------
    scope_table* get_parent();

    //-------print function---------------
    void print();

    ~scope_table();
};
//------------------constructor---------------------------
/**
 * @brief Construct a new scope table::scope table object
 *
 * @param length    length of the bucket of the table
 * @param parent    parent to this table it is needed for maintaining stack
 */
scope_table::scope_table(int length,int id, scope_table* parent) {
    this->parent = parent;
    this->length = length;
    this->array = new linked_list[length];
    this->child = 0;
    if (this->parent == NULL) {
        this->id = to_string(id);
    } else {
        parent->child++;
        this->id = parent->id + "." + to_string(parent->child);
    }
    cout << "New ScopeTable with id " << this->id << " created." << endl;
}

scope_table::~scope_table() {
    delete [] (this->array);
    cout << "ScopeTable with id " << this->id << " deleted." << endl;
}

//--------------------private util function---------------------------
/**
 * @brief sdbm hash function to calculate the standard hash function of the name
 * passed to the function
 * @ref     sdbm hash         "http://www.cse.yorku.ca/~oz/hash.html"
 *
 * @param   name             name of the symbol whose hash is to be determined
 * @return  unsigned long    sdbm hash value of the name
 */
unsigned long scope_table::sdbm(string str) {
    unsigned long hash = 0;
    unsigned int i = 0;
    unsigned int len = str.length();

    for (i = 0; i < len; i++) {
        hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
    }

    return hash;
}

/**
 * @brief it only maps the sdbm hash value with the table size
 *
 * @param name              name of the symbol whose hash is to be determined
 * @return unsigned int     hash table bucket number
 */
unsigned int scope_table::hash_value(string name) {
    /* hash<string> standard_hash;
    return (standard_hash(name) % length); */
    unsigned long hash = sdbm(name);

    return hash % length;
}

//----------------dictionary function-----------------------

/**
 * @brief findes the hash value that is in what table the symbol is to be placed
 * then adds to that table
 *
 * @param name          name of the symbol
 * @param identifier    symbol type
 * @return true         if successfully inserted to the table
 * @return false        if already in the table
 */
bool scope_table::insert(string name, string identifier) {
    unsigned int hash_val = scope_table::hash_value(name);
    int index = array[hash_val].insert(name, identifier);
    if (index < 0) {
        // unsuccessful
        cout << "There is a variable with <" << name
             << "> already in this scope"<<endl;
        return false;
    }
    // successful
    cout << "Inserted in Scopetable# " << this->id << " at position "
         << hash_val << " , " << index << endl;
    return true;
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
    scope_table* current = this;
    while (current != NULL) {
        unsigned int hash_val = scope_table::hash_value(name);
        symbol_info* cur_sym = current->array[hash_val].search(name);
        int index = current->array[hash_val].get_index(name);
        if (cur_sym != NULL && index >= 0) {
            cout << "Found in ScopeTable# " << current->id << " at position "
                 << hash_val << " , " << index << endl;
            return cur_sym;
        }
        current = current->parent;
    }
    cout << "Not found" << endl;
    return NULL;
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
    scope_table* current = this;

    while (current != NULL) {
        /* code */
        unsigned int hash_val = scope_table::hash_value(name);
        int index = current->array[hash_val].get_index(name);
        if (current->array[hash_val].remove(name)) {
            cout << "Removed from ScopeTable# " << current->id
                 << " at position " << hash_val << " , " << index << endl;
            return true;
        }
        current = current->parent;
    }
    cout << "Could not delete " << name << endl;
    return false;
}

//-------------getter--------------------------
scope_table* scope_table::get_parent() { return this->parent; }

//-----------------print function--------------
void scope_table::print() {
    cout << "Scope Table# " << this->id << endl;
    for (int i = 0; i < this->length; i++) {
        cout << i << "----";
        array[i].print();
        cout << endl;
    }
}