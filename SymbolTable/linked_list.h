#pragma once

#include "symbol_info.h"
using namespace std;


/**
 * Linked list class to store the chains of the hash table
 */

class linked_list {
   private:
    symbol_info* head;  // here this is interprated as tail of the list
    int length;
    void print_recur(symbol_info*, bool);

   public:
    linked_list();

    //---------dictionary func----------------
    int insert(string, string);
    symbol_info* search(string);
    int get_index(string);
    bool remove(string);
    int size();

    void print();

    ~linked_list();
};



linked_list::linked_list() {
    this->head = NULL;
    this->length = 0;
}

linked_list::~linked_list() {
    symbol_info* temp;
    while (this->head != NULL) {
        temp = this->head->get_next();
        delete this->head;
        this->head = temp;
    }
}

/**
 * @brief to get the index of the symbol
 * This function is used to get the symbol from the linked list from its name
 *
 * @param name      name of the symbol that's index is needed
 * @return int      index of the symbol if present
 * @return -1       if the symbol by this name is not present
 */
int linked_list::get_index(string name) {
    symbol_info* temp = this->head;
    int counter = length - 1;

    while (temp != NULL) {
        if (temp->get_name() == name) {
            return counter;
        }
        temp = temp->get_next();
        counter--;
    }
    return counter;
}

/**
 * @brief to insert a symbol
 * This fucntion puts the new symbol in the head of the linked list. the newest
 * element is infront of the list
 * @param name:        name of the symbol
 * @param identifier:  what type of symbol is this
 * @return int         index of the new symbol that is inserted
 * @return -1          if could not inserted (if the symbol was already present)
 */
int linked_list::insert(string name, string identifier) {
    if (this->search(name) != NULL) {
        return -1;
    }

    symbol_info* symbol = new symbol_info(name, identifier);
    if (this->head == NULL) {
        this->head = symbol;
    } else {
        symbol->set_next(this->head);
        this->head = symbol;
    }
    return this->length++;
}

/**
 * @brief
 * This function searchs from head to the last position of the list
 * @param name       name of the symbol that should be search
 */
symbol_info* linked_list::search(string name) {
    symbol_info* temp = this->head;

    while (temp != NULL) {
        if (temp->get_name() == name) {
            return temp;
        }
        temp = temp->get_next();
    }

    return temp;
}

// function to remove a symbol from the list
//
// This function removes the symbol from the linked list
// @param-
//  name:       name of the symbol that is to be deleted from the list
bool linked_list::remove(string name) {
    symbol_info* temp = this->head;
    symbol_info* prev = NULL;

    while (temp != NULL) {
        if (temp->get_name() == name) {
            if (prev == NULL) {
                // head is the symbol to delete
                this->head = temp->get_next();
                
            } else {
                prev->set_next(temp->get_next());
            }
            delete temp;
            this->length--;
            return true;
        }
        prev = temp;
        temp = temp->get_next();
    }

    return false;
}

// function to return the size of the linked list
int linked_list::size() { return this->length; }

// print function
void linked_list::print() { this->print_recur(this->head, false); }

void linked_list::print_recur(symbol_info* current, bool flag) {
    if (current == NULL) {
        return;
    }
    print_recur(current->get_next(), true);
    current->print_node();
    if (flag) {
        cout << "--";
    }
}
