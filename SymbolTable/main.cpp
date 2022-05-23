#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "symbol_table.cpp"

using namespace std;

void split_str(string &str, const char delim, vector<string> &out) {
    // create a stream from the string
    stringstream s(str);

    string s2;
    while (getline(s, s2, delim)) {
        out.push_back(s2);  // store the string in s2
    }
}

string match_dictionary(char instruction,
                        vector<pair<string, char> > dictionary) {
    for (int i = 0; i < dictionary.size(); i++) {
        if (dictionary[i].second == instruction) {
            return dictionary[i].first;
        }
    }

    return "404";
}

int main() {
    ifstream input, dictionary;
    input.open("input.txt");
    dictionary.open("dictionary.txt");
    if (!input || !dictionary) {
        cerr << "Error! file could not be opened..." << endl;
        exit(1);
    }

    vector<pair<string, char> > instructions;
    string line;
    const char delim = ' ';
    // taking the dictionary operation form file
    while (getline(dictionary, line)) {
        vector<string> inputs;
        split_str(line, delim, inputs);
        instructions.push_back(make_pair(inputs[0], inputs[1][0]));
    }

    int n;
    input >> n;  // take the size from top line
    symbol_table table(n);

    while (getline(input, line)) {
        vector<string> params;
        split_str(line, delim, params);
        if (params.size() > 0) {
            if (match_dictionary(params[0][0], instructions)
                    .compare("insert") == 0) {
                cout << "insert";
            } else if (match_dictionary(params[0][0], instructions)
                           .compare("lookup") == 0) {
                cout << "lookup";
            } else if (match_dictionary(params[0][0], instructions)
                           .compare("delete") == 0) {
                cout << "lookup";
            } else if (match_dictionary(params[0][0], instructions)
                           .compare("print") == 0) {
                cout << "print";
            } else if (match_dictionary(params[0][0], instructions)
                           .compare("enter_scope") == 0) {
                cout << "enter_scope";
            } else if (match_dictionary(params[0][0], instructions)
                           .compare("exit_scope") == 0) {
                cout << "exit_scope";
            }
        }
    }
}