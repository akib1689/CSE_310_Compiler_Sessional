int foo(int a);
int foo(int a){
	return a-3;
}


int bar(int a, int b){
	return foo(a) + foo(b);
}



int main(){
	return bar(1,2);
}