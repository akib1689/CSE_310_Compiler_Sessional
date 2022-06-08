#include<iostream>
#include "symbol_table.cpp"

int main(){
    symbol_table table(7);
    table.insert("a", "a");
    table.create_scope();
    table.insert("h","h");
    table.create_scope();
    table.insert("o","o");
    // table.print_all();
    table.search("o");
    table.search("a");
    table.delete_scope();
    table.create_scope();
    table.insert("foo", "function");
    table.delete_scope();
    table.create_scope();
    table.insert("i", "var");
    table.print_all();
    table.search("foo");
    table.search("j");
    table.delete_scope();
    table.delete_scope();
    table.create_scope();
    table.insert("5", "Number");
    table.print_all();
    table.remove("j");
    table.remove("i");
    table.print_all();
    table.create_scope();
    table.delete_scope();
    table.create_scope();
    table.insert("<=", "Relop");
    table.insert("==", "Relop");
    table.print_all();
    table.delete_scope();
    table.insert("t", "t");
    table.insert("k", "k");
    table.print_top();
    table.print_all();


    // scope_table stable(7, NULL);
    // stable.insert("o", "o");
    // stable.insert("a", "a");
    // stable.search("a");
    // stable.print(); 

    // linked_list list;
    // list.insert("a", "var");
    // list.insert("o", "o");
    // list.insert("d", "o");
    // list.remove("o");
    // list.print() ;
    // cout<<"end of program"<<endl;

    return 0;
}