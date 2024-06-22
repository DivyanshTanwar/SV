//tb

//run on Siemens Questa
module tb();

  import "DPI-C" context function void pass_arr(input int arr[], int size);

  int arr[];
  int size;
  
  initial begin
    arr = {1,2,3,4,5};
    size = 5;
    $display("%0p",arr);
    pass_arr(arr,size);
    
    
  end
  
endmodule


//cpp

#include <stdio.h>
#include "svdpi.h"


extern "C" void pass_arr(const svOpenArrayHandle h, int size){
  
  int* arr;
  arr = (int*) svGetArrayPtr(h);

  printf("Printing Array : \n");
  for( int i=0; i<size ; i++){
  	printf("%0d\n",*(arr + i));	
  
  }
}

