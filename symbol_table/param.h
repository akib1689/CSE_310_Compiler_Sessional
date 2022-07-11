#ifndef PARAM_H
#define PARAM_H

#include <iostream>
using namespace std;

class param {
   private:
    string name;
    string identifier;
    
      
   public:
    param(string, string);
    param(const param&);
    ~param();
    
    string get_name();
    string get_identifier();
    void set_name(string);
    void set_identifier(string);
};

#endif // PARAM_H