#include <iostream>

#include "scope_table.cpp"
using namespace std;

int main() {
    scope_table table(7);
    table.insert("a", 'a');
    table.insert("h", 'h');
    table.insert("x", 'v', 20);
    table.print();
}