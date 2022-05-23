#include<iostream>
#include "symbol_table.cpp"

int main(){
    symbol_table table(7);
    table.insert("a", "a");
    table.create_scope();
    table.insert("h","h");
    table.create_scope();
    table.insert("o","o");
    //table.print_all();
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


    /* scope_table stable(7, NULL);
    stable.insert("o", "o");
    stable.insert(" a", "a");
    stable.search("a");
    stable.print(); */

    /* linked_list list;
    list.insert("a", "a");
    list.insert("o", "o");
    list.insert("d", "o");
    list.search("a")->print_node();
    list.print(); */
    cout<<"all ok"<<endl;

    return 0;
}