#ifndef PARAM_H
#define PARAM_H 1

#include <iostream>
using namespace std;

class param {
   private:
    string name;
    string identifier;
    
      
   public:
    param(string name, string identifier) {
        this->name = name;
        this->identifier = identifier;
    }

    param(const param& other) {
        this->name = other.name;
        this->identifier = other.identifier;
    }

    ~param() {
    }

    string get_name() {
        return this->name;
    }
    string get_identifier() {
        return this->identifier;
    }
    void set_name(string name) {
        this->name = name;
    }
    void set_identifier(string identifier) {
        this->identifier = identifier;
    }
};
#endif // PARAM_H