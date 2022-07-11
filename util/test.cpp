#include<bits/stdc++.h>
#include "util.h"
using namespace std;
int main(){
    string str = "a[50]";
    string str1 = "a";
    cout << is_array_declaration(str) << endl;
    cout << get_array_size(str) << endl;
    cout << get_array_name(str) << endl;
    cout << is_array_declaration(str1) << endl;

    return 0;
}