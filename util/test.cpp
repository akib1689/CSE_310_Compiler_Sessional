#include<bits/stdc++.h>
#include "util.h"
using namespace std;
int main(){
    int a,b,c,i;
    b=0;
	c=1;
    for(i=0;i<4;i++){
        a=3;
        while(a--){
            b++;
        }
    }
    printf("%d", &a);
	printf("%d", &b);
	printf("%d", &c);
}