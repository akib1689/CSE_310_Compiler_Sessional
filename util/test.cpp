#include<bits/stdc++.h>
#include "util.h"
using namespace std;
int main(){
    string str = "a[50]";
    string str1 = "int a,int c,string d,float e";
    cout << is_array_declaration(str) << endl;
    cout << get_array_size(str) << endl;
    cout << get_array_name(str) << endl;
    cout << is_array_declaration(str1) << endl;
    vector<param> result = get_param_list(str1);
    for (int i = 0; i < result.size(); i++){
        cout << result[i].get_type() << " " << result[i].get_name() << endl;
    }
    

    return 0;
}