class first;
  
  rand int data;
  
  constraint data_c {
    data > 0;
    data < 10;
  }
  
endclass

class second;
  
  rand int data;
  
  constraint data_c {
   	data > 10;
    data < 20;
  }
  
endclass

class main;
  
  first f;
  second s;
  semaphore sema;
  int data2;
  
  function new();
    
    f = new();
    s = new();
    sema = new(1);
    
  endfunction
  
  task run_first();
    
    sema.get(1);
    $display("Key Occupied by first !!");
    
    for(int i = 0; i< 10 ; i++) begin
      
      assert(f.randomize()) else $display("Randomization Failed");
      data2 = f.data;
      $display("FIRST : data = %d",data2);
      #10;
      
    end
    sema.put();
    $display("Key Released By first");
    
  endtask
  
  task run_second();
    
    sema.get(1);
    $display("Key Occupied by second !!");
    for(int i = 0; i<10; i++) begin
      
      assert(s.randomize()) else $display("Randomization Failed");
      data2 = s.data;
      $display("SECOND : data = %d",data2);
      #10;
      
    end
    
    sema.put();
    $display("Key Released By Second");
    
  endtask
  
  task run();
    
    fork
      
      run_first();
      run_second();
      
    join
    
  endtask
  
endclass

module test();
  
  main m;
  
  initial begin
    
    m = new();
    m.run();
    
  end
  
endmodule
  
