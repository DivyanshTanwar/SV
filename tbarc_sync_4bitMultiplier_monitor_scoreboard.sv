//design

module top
(
  input clk,
  input [3:0] a,b,
  output reg [7:0] mul
);
  
  always@(posedge clk)
    begin
     mul <= a * b;
    end
  
endmodule


//tb
class transaction;
  
  randc bit [3:0] a,b;
  bit [7:0] mul;
  
  function void display();
    
    $display("a = %0d, b = %0d, mul = %0d",a, b, mul);
    
  endfunction
  
  
endclass

interface mul_if;
  
  logic clk;
  logic [3:0] a,b;
  logic [7:0] mul;
  
  
endinterface


class monitor;
  
  transaction trans;
  virtual mul_if mif;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    trans = new();
    
    forever begin
      repeat(2) @(posedge mif.clk);
      trans.a = mif.a;
      trans.b = mif.b;
      trans.mul = mif.mul;
      
      mbx.put(trans);
      $display("-----------------------------------------");
      $display("[MON] Data Recieved from DUT");
      trans.display();
      
    end
    
  endtask
  
  
endclass


class scoreboard;
  
  transaction trans;
  mailbox #(transaction) mbx;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task comp(input transaction trans);
    
    if((trans.mul) == (trans.a * trans.b))
      $display("[SCO] : OUTPUT MATCHED, PASSED");
    
    else
      $error("[SCO] : OUTPUT MISMATCH, FAILED");
    
  endtask
  
  task run();
    
    forever begin
      
      mbx.get(trans);
      $display("[SCO]: Data Recievd from monitor");
      trans.display();
      comp(trans);
      $display("-----------------------------------------");
      #20;
      
    end
    
  endtask
  
endclass


module tb();
  
  mailbox #(transaction) mbx;
  monitor mon;
  scoreboard sco;
  mul_if mif();
  top dut(mif.clk, mif.a, mif.b,mif.mul);

  
  
  initial begin
    
    mbx = new();
    mon = new(mbx);
    sco = new(mbx);
    mon.mif = mif;
    
  end
  
  
  initial begin
    
    mif.clk <= 0;
    
  end
  
  always #5 mif.clk <= ~ mif.clk;
  
  initial begin
    for(int i = 0; i<20; i++) begin
      repeat(2)@(posedge mif.clk);
      mif.a <= $urandom_range(1,15);
      mif.b <= $urandom_range(1,15);
    end
    
  end
  
  initial begin
    
    fork 
      
      mon.run();
      sco.run();
      
    join
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;    
    #300;
    $finish();
  end
  

  
endmodule
