class queue #(type M = int);
  
  M queue[];
  int size;
  bit full, empty;
  int wr_ptr, rd_ptr;
  
  function new (int size);
    
    this.queue = new[size];
    this.size = size;
    this.full = 1'b0;
    this.empty = 1'b1;
    this.wr_ptr = 0;
    this.rd_ptr = 0;
    
  endfunction
  
  function void push(M element);
    
    if(!full) begin
      
      queue[wr_ptr] = element;
      wr_ptr = (wr_ptr + 1) % size;
      
    end
    
    else $display("Queue Full !!!!");
        
    if(rd_ptr == wr_ptr) begin
      full = 1'b1;
      empty = 1'b0;
    end
    
    
  endfunction
  
  function M pop();
    
    M value;
   	
    if(!empty) begin
      
    	value = queue[rd_ptr];
        rd_ptr = (rd_ptr + 1) % size;

    end
    
    else begin
      $display("Queue Empty !!!!!");
      value = M'(-1);
    end
    
    if(rd_ptr == wr_ptr) begin
      empty = 1'b1;
      full = 1'b0;
    end
    
    return value;
	
    
  endfunction
  
endclass

module tb();
  
  queue#(int) q;
  queue#(real) q1;
  queue#(string) q2;
  
  initial begin
    
    q = new(5);
    
    q.push(10);
    q.push(11);
    q.push(12);
    q.push(13);
    q.push(14);
    q.push(15);
    
    $display("Element popped : %0d", q.pop());
    $display("Element popped : %0d", q.pop());
    $display("Element popped : %0d", q.pop());
    $display("Element popped : %0d", q.pop());
    $display("Element popped : %0d", q.pop());
    $display("Element popped : %0d", q.pop());
    
    $display("-------------------------------");
    
    
    q1 = new(5);
    
    q1.push(10.11);
    q1.push(11.11);
    q1.push(12.24);
    q1.push(13.63);
    q1.push(14.984);
    q1.push(15.881);
    
    $display("Element popped : %f", q1.pop());
    $display("Element popped : %f", q1.pop());
    $display("Element popped : %f", q1.pop());
    $display("Element popped : %f", q1.pop());
    $display("Element popped : %f", q1.pop());
    $display("Element popped : %f", q1.pop());
    
    $display("-------------------------------");

	
    
    q2 = new(6);
    q2.push("Hello1");
    q2.push("Hello2");
    q2.push("Hello3");
    q2.push("Hello4");
    q2.push("Hello5");
    q2.push("Hello6");
    
    $display("Element popped : %s", q2.pop());
    $display("Element popped : %s", q2.pop());
    $display("Element popped : %s", q2.pop());
    $display("Element popped : %s", q2.pop());
    $display("Element popped : %s", q2.pop());
    $display("Element popped : %s", q2.pop());
	
    $finish;


    
  end
  
endmodule
  
