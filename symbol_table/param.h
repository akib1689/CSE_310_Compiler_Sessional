#ifndef PARAM_H
#define PARAM_H 1

#include <iostream>
using namespace std;

class param {
   private:
    string name;
    string type;
    
   public:
    param(string name, string type) {
        this->name = name;
        this->type = type;
    }

    param(const param& other) {
        this->name = other.name;
        this->type = other.type;
    }

    ~param() {
    }

    string get_name() {
        return this->name;
    }
    string get_type() {
        return this->type;
    }
    void set_name(string name) {
        this->name = name;
    }
    void set_type(string type) {
        this->type = type;
    }
};
#endif // PARAM_H