#include <iostream>
#include <typeinfo>

#include "linked_list.cpp"
using namespace std;

int main() {
    linked_list list;

    list.insert("ak", 'c', 10);
    list.insert("htis", 'c', 20);
    list.insert("c", 'c', 30);
    cout << list.size() << " ";
    list.insert("d", 'c', 40);

    list.print();

    list.search("htis") == NULL ? cout << "not found " : cout << "found ";

    cout << list.size() << " ";
    list.remove("htis");

    cout << list.size() << " ";
    list.print();
}