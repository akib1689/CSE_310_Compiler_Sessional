#include <iostream>
#include <vector>

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
    vector<linked_list> array;
    scope_table* parent;
    int child;

    unsigned int hash_value(string);
    unsigned long sdbm(char*);

   public:
    scope_table(int, scope_table* parent);

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
scope_table::scope_table(int length, scope_table* parent) {
    this->parent = parent;
    this->length = length;
    this->child = 0;
    if (this->parent == NULL) {
        this->id = "1";
    }else{
        parent->child++;
        this->id = parent->id + "." + to_string(parent->child);
    }
    this->array.resize(length);
    cout<<"New ScopeTable with id "<<this->id<<" created"<<endl;
}

scope_table::~scope_table() {}


//--------------------private util function---------------------------
/**
 * @brief sdbm hash function to calculate the standard hash function of the name
 * passed to the function
 * @ref     sdbm hash         "http://www.cse.yorku.ca/~oz/hash.html"
 *
 * @param   name             name of the symbol whose hash is to be determined
 * @return  unsigned long    sdbm hash value of the name
 */
unsigned long scope_table::sdbm(char* str) {
    unsigned long hash = 0;
    int c;
    while (c = *str++) {
        hash = c + (hash << 6) + (hash << 16) - hash;
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
    unsigned long hash = sdbm((char*)(&name));

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
    unsigned int hash_val = this->hash_value(name);
    int index = array[hash_val].insert(name, identifier);
    if(index < 0){
        //unsuccessful
        cout<< "There is a variable with <" << name <<"> already in this scope";
        return false;
    }
    //successful
    cout<<"Inserted in Scopetable # "<< this->id << " at position "<<hash_val<<" , "<<index<<endl;
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

//-------------getter--------------------------
scope_table* scope_table::get_parent() { return this->parent; }

//-----------------print function--------------
void scope_table::print() {
    for (int i = 0; i < length; i++) {
        cout << i << "----";
        array[i].print();
        cout << endl;
    }
}