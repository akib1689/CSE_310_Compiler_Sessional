#include "param.h"

param::param(string name, string identifier) {
    this->name = name;
    this->identifier = identifier;
}

param::param(const param& other) {
    this->name = other.name;
    this->identifier = other.identifier;
}

param::~param() {
}

string param::get_name() {
    return this->name;
}
string param::get_identifier() {
    return this->identifier;
}
void param::set_name(string name) {
    this->name = name;
}
void param::set_identifier(string identifier) {
    this->identifier = identifier;
}
