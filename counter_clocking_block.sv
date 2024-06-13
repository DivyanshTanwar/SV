//design

module counter(
  
  input clk, rst_n,
  output reg [7:0] count
  
);
  
  always @(posedge clk or negedge rst_n) begin
    
    if(!rst_n) 
      count <= 0;
    
    else
      count <= count + 1;
  end
  
  
endmodule;

//testbench

module tb();
  
  reg clk,rst_n;
  wire [7:0] count;
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  counter dut (
    .clk(clk),
    .rst_n(rst_n),
    .count(count)
  );
  
  test1 t1(clk,count,rst_n);
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
  
endmodule

program test1(input clk,input [7:0] count, output rst_n);
    
    clocking clk1 @(posedge clk);
      
      default input #2ns output #1ns;
      output negedge rst_n;
      input count;
      
    endclocking
    
    initial begin
      
      clk1.rst_n <= 0;
      ##5 clk1.rst_n <= 1;
      ##5 clk1.rst_n <= 0;
      ##5 clk1.rst_n <= 1;
      
      #100;
      
    end
    
endprogram


