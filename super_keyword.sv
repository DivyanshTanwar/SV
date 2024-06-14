class A;
  
  function print();
    
    $display("A");
    
  endfunction
endclass

class B extends A;
  
  function print();
    
    $display("B");
    
  endfunction
  
  function print_A();
    
    super.print();
    
  endfunction
  
endclass

class C extends B;
  
  function print();
    
    $display("C");
    
  endfunction
  
  function print_A();
    
    super.print_A(); //super.super.print() doesnot exist.
    
  endfunction
  
endclass

module tb();
  
  C c;
  
  initial begin
  
  c = new();
  c.print_A();
    
  end
  
endmodule
