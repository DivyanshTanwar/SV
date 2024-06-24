class ethernet;
  
  rand bit[7:0] DA, SA; //64
  rand bit[7:0] data; // 256
  
  function void display();
    
    $display("DA : %0d SA : %0d data : %0d",DA,SA,data);
    
  endfunction
  
  covergroup covgrp;
    
    A : coverpoint SA {
      ignore_bins ignore_vals = {0,255};
      ignore_bins invalid_trans = ([0:254] => 255),([1:255] => 0);
      bins low = {[0:64]};
      bins mid = {[65:128]};
      bins high = {[129:255]};
    }
    
    B : coverpoint DA{
     
      option.weight = 3;
      bins low = {[0:32]};
      bins mid = {[33:200]};
      bins high = {[201:255]};
      
    }
    
    C : coverpoint data {
     
      option.weight = 5;
      bins low = {[0:32]};
      bins mid = {[33:200]};
      bins high = {[201:255]};
      wildcard bins w1 = {8'b111111??};
      
    }
    
    
    AXB : cross A,B;
    
  endgroup
  
  
  function new();
    
    this.covgrp = new();
    
  endfunction
  
endclass

class producer;
  
  ethernet e1;
  mailbox #(ethernet) mbx;
  event next;
  
  
  
  function new(mailbox #(ethernet) mbx);
    
    e1 = new();
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    forever begin
      
      assert(e1.randomize()) else $error("Randomization Failed");

      $display("Data Produced in Producer  ");
      e1.display();
      mbx.put(e1);
      @(next);
      
    end
    
  endtask
  
endclass


class consumer;
  
  ethernet e1;
  mailbox #(ethernet) mbx;
  event next;
  
  function new(mailbox #(ethernet) mbx);
    this.mbx = mbx;
    
  endfunction
  
  task run();
  
    forever begin
      
        mbx.get(e1);
      	$display("Data Recieved in Consumer");
      	e1.display();
     	e1.covgrp.sample();
      	$display("------------------------------------------------");
        ->next;
      	#5;

    end
    
  endtask
  
  
  
endclass


module tb();
  
  
  mailbox #(ethernet) mbx;
  producer p1;
  consumer c1;
  
  
  initial begin
    mbx = new();
    p1 = new(mbx);
    c1 = new(mbx);
    p1.next = c1.next;
    
    fork
      
      p1.run();
      c1.run();
      
    join_none
    
    
    #1000;
    $display("Coverage = %0.2f",c1.e1.covgrp.get_inst_coverage());
    $finish;
    
  end
  
  
endmodule
