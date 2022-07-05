#ifndef SCOPE_TABLE_H
#define SCOPE_TABLE_H

#include<iostream>

#include "linked_list.h"
#include "symbol_info.cpp"

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
    scope_table(int, int, scope_table*);

    //-------dictionary function----------
    bool insert(string, string);
    bool insert(string, string, FILE*);
    bool remove(string);
    symbol_info* search(string);

    //-------getter-----------
    scope_table* get_parent();

    //-------print function---------------
    void print();
    void print(FILE* out);
    ~scope_table();
};


#endif // SCOPE_TABLE_H