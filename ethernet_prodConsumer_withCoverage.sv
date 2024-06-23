//tb
class ethernet;
  
  rand bit[6:0] preamble, DA, SA;
  rand bit sfd;
  rand bit [1:0] length;
  rand bit[0:2] data;
  rand bit [0:3] crc;
  
  function void display();
    
    $display("preamble : %0d DA : %0d SA : %0d sfd : %0d length : %0d data : %0d crc : %0d", preamble,DA,SA, sfd, length, data, crc);
    
  endfunction
  
  covergroup covgrp;
   
//     coverpoint preamble;
//     coverpoint DA;
//     coverpoint SA;
//     coverpoint sfd;
//     coverpoint length;
    coverpoint data {
      bins d1 = {0};
      bins d2 = {[1:14]};
      bins d3 = {15};
    }
//     coverpoint crc;
    
    
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
