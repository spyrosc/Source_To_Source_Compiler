
#include <stdlib.h> 
#include "teaclib.h"


 const int N=100;
 int a, b; 
 int cube(int i){return i*i*i;}
 
 int add(int k, int n)
 {	int j; 
    j=(N-n)+cube(k); 
    writeInt(j); 
    return j;
}
int main() {
	a=readInt( ); 
	 b=readInt( ); 
	 add(a , b); 
	 return 0;  
} 
