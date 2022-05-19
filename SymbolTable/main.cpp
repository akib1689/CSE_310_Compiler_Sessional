#include <iostream>

#include "symbol_table.cpp"
using namespace std;

int main() {
    symbol_table table(7);
    table.insert("a", 'a');
    table.create_scope();
    table.insert("h", 'h');
    table.create_scope();
    table.insert("o",'o');
    table.print_all();
}