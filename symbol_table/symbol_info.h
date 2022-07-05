#ifndef SYMBOL_INFO_H
#define SYMBOL_INFO_H

#include <iostream>
using namespace std;

/*
 * Node class to store the symbol info
 */
class symbol_info {
   private:
    symbol_info* next;
    string name;
    string identifier;

   public:
    symbol_info(string, string);
    symbol_info(const symbol_info&);
    ~symbol_info();

    string get_name();
    string get_identifier();
    symbol_info* get_next();
    void set_next(symbol_info*);
    void print_node();
    void print_node(FILE*);
};



#endif // SYMBOL_INFO_H