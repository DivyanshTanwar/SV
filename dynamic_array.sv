module dynamic_array();
  
  int mem [];
  int memcopy[];
  
  initial begin
    
    mem = new[8];
    
    mem = {1,2,3,4,5,6,7,8};
    $display("mem = %p",mem);

    $display("Size of the dynamic array = %0d",mem.size());
    
    mem[2] = 8;
    mem[6] = 16;
    
    $display("mem = %p",mem);
    
    mem = new[18](mem);
    mem[16] = 20;
    mem[17] = 22;
    $display("Size of the dynamic array = %0d",mem.size());
    $display("mem = %p",mem);
    
    memcopy = mem;
    memcopy = new[memcopy.size()+2](memcopy);
    memcopy[memcopy.size() - 1] = 99;
    $display("Size of the copy of dynamic array memcopy = %0d",memcopy.size());
    $display("memcopy = %p",memcopy);
    
    mem.delete();
    $display("Size of the dynamic array mem = %0d",mem.size());

    
    
  end
  
endmodule
