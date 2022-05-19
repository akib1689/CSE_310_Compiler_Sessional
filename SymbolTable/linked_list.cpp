#include <iostream>

#include "symbol_info.cpp"

/**
 * Linked list class to store the chains of the hash table
 */

class linked_list {
   private:
    symbol_info* head;
    int length;

   public:
    linked_list();

    //---------dictionary func----------------
    bool insert(string, char);
    symbol_info* search(string);
    bool remove(string);
    int size();

    void print();

    ~linked_list();
};

linked_list::linked_list() {
    this->head = NULL;
    this->length = 0;
}

linked_list::~linked_list() { delete this->head; }

/**
 * @brief to insert a symbol
 * This fucntion puts the new symbol in the head of the linked list. the newest
 * element is infront of the list
 * @param name:        name of the symbol
 * @param identifier:  what type of symbol is this
 * @return true        if it successfully inserts
 * @return false       if the symbol is already present
 */
bool linked_list::insert(string name, char identifier) {
    if (this->search(name) != NULL) {
        return false;
    }

    symbol_info* symbol = new symbol_info(name, identifier);
    if (this->head == NULL) {
        this->head = symbol;
    } else {
        symbol->set_next(this->head);
        this->head = symbol;
    }
    this->length++;
    return true;
}

// function to search a symbol in a list
//
// This function searchs from head to the last position of the list
// @param-
//  name:       name of the symbol that should be search
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
void linked_list::print() {
    symbol_info* current = this->head;
    while (current != NULL) {
        current->print_node();
        cout << " -- ";
        current = current->get_next();
    }
}
