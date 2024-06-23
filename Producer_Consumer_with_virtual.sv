class ethernet;
  
  rand bit[6:0] preamble, DA, SA;
  rand bit sfd;
  rand bit [1:0] length;
  rand bit[0:50] data;
  rand bit [0:3] crc;
  
  virtual function void display();
    
    $display("preamble : %0d DA : %0d SA : %0d sfd : %0d length : %0d data : %0d crc : %0d", preamble,DA,SA, sfd, length, data, crc);
    
  endfunction
  
endclass

class smallpacket extends ethernet;
  
  rand bit[0:2] data;
  
  virtual function void display();
    
    $display("In Small Packet :");
    $display("preamble : %0d DA : %0d SA : %0d sfd : %0d length : %0d data : %0d crc : %0d", preamble,DA,SA, sfd, length, data, crc);
    
  endfunction

  
endclass

class largepacket extends ethernet;
  
  rand bit[0:10] data;
  
  virtual function void display();
    
    $display("In Large Packet :");
    $display("preamble : %0d DA : %0d SA : %0d sfd : %0d length : %0d data : %0d crc : %0d", preamble,DA,SA, sfd, length, data, crc);
    
  endfunction

  
endclass

class corruptedpacket extends ethernet;
  
  rand bit[0:5] data;
  
  virtual function void display();
    
    $display("In Corrupted Packet :");
    $display("preamble : %0d DA : %0d SA : %0d sfd : %0d length : %0d data : %0d crc : %0d", preamble,DA,SA, sfd, length, data, crc);
    
  endfunction

  
endclass



class producer;
  
  ethernet e1;
  mailbox #(ethernet) mbx;
  event next;
  smallpacket s1;
  
  
  
  function new(mailbox #(ethernet) mbx, ethernet e1);
    
    this.e1 = e1;
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
  smallpacket s1;
  largepacket l1;
  corruptedpacket cp1;
  
  initial begin
    s1 = new();
    cp1 = new();
    l1 = new();
    mbx = new();
    p1 = new(mbx,cp1);
    c1 = new(mbx);
    p1.next = c1.next;
    
    fork
      
      p1.run();
      c1.run();
      
    join_none
    
    #1000;
    $finish;
    
  end
  
  
endmodule
