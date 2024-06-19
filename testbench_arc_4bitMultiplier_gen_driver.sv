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
  
  function transaction copy();
    
    copy = new();
    copy.a = this.a;
    copy.b = this.b;
    copy.mul = this.mul;
    
  endfunction
  
endclass


class generator;
  
  transaction trans;
  mailbox #(transaction) mbx;
  event done;
  
  function new( mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    trans = new();
    
  endfunction
  
  task run();
    
    for(int i = 0; i < 10; i++) begin
      assert(trans.randomize()) else $display("[GEN] : Randomization Failed");
      $display("[GEN]: Data Send ");
      trans.display();
      mbx.put(trans.copy);
      #20;
    end
    -> done;
    
  endtask
  
  
endclass


interface mul_if;
  
  logic clk;
  logic [3:0] a,b;
  logic [7:0] mul;
  
  modport DRV(output a,b, input mul,clk);
  
endinterface


class driver ;
  
  transaction data;
  mailbox #(transaction) mbx;
  virtual mul_if.DRV mif;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    forever begin
      
      mbx.get(data);
      @(posedge mif.clk);
      mif.a <= data.a;
      mif.b <= data.b;
      $display("[DRV] : Interface Triggered.");
      data.display();
      
    end
    
  endtask
  
endclass


module tb();
  
  generator gen;
  driver drv;
  mailbox #(transaction) mbx;
  mul_if mif();
  top dut (mif.clk, mif.a, mif.b,mif.mul);
  event done;
  
  initial begin
    mif.clk <= 0;
  end
  
  always #10 mif.clk <= ~mif.clk;
  
  initial begin
    
    mbx = new();
    gen = new(mbx);
    drv = new(mbx);
    drv.mif = mif;
    done = gen.done;
    
  end
  
  initial begin
    
    fork 
      
     gen.run();
     drv.run();
      
    join_none
    
    wait(done.triggered);
    $finish();
    
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end
  
  
endmodule
