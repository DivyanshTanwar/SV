//tb

//run on Siemens Questa
module tb();
  
  import "DPI-C" context function int printC(int c);
  export "DPI-C" function printSV;
  
  int rValue;
  
  initial begin
    
    $display("In SV right now :  ");
    rValue = printC(5);
    $display("Returned Value by C = %0d",rValue);
    
  end
  
  function int printSV(int sv);
    
    $display("Hello from SV, value of SV : %0d",sv);
    return 100;
    
  endfunction
  
endmodule


//c

#include <stdio.h>
#include <svdpi.h>

extern "C" int printSV(int sv);

extern "C" int printC(int c) {
  
  printf("Hello Guys From C Language , Value of c is : %0d \n",c);
  
  printf("In C Right Now\n");
  
  int R;
  R = printSV(66);
  printf("Returned value by SV : %0d\n",R);
  
  return 1;
  
}


