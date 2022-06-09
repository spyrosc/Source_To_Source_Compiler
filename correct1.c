
#include <stdlib.h> 
#include "teaclib.h"


const char message[14]="Hello world!\n"; 
 
int main() {

  int i=1; 
 while(i<20)  
 { 
	 if(i%2==0)  
		 { 
	 	writeString(message); 
		 } ; 
	 	i=i+1; 
 } ; 
 return 0;  
} 
