virtual class transaction;
  
  bit [7:0] header;
  bit [15:0] payload;
  bit parity;
  
  pure virtual function void print_packets();
  pure virtual function void display_parity();
  pure virtual function bit calculate_parity();
  pure virtual function void display_payload();
    

endclass
    
class large_packet extends transaction;
  
  function new ( bit[7:0] header, bit[15:0] payload);
    
    $display("Large Packet Constructor Called");
    this.header = header;
    this.payload = payload;
    this.parity = calculate_parity();
    
  endfunction
  
  function void print_packets();
    
    $display("Large packet : Header = %0h, Payload = %0h, parity = %b", header, payload, parity);
    
  endfunction
  
  function void display_parity();
    
    $display("Large Packet Parity = %b", parity);
    
  endfunction
  
  
  function void display_payload();
  	
    $display("Large Packet Payload = %0h", payload);
    
  endfunction;
  
  
  function bit calculate_parity();
    
    return ^ this.payload;
    
  endfunction
  
endclass
    
class small_packet extends transaction;
  
  function new (bit[7:0] header, bit[15:0] payload);
    
    this.header = header;
    this.payload = payload;
    this.parity = calculate_parity();
    
  endfunction
  
  function void print_packets();
    
    $display("Small Packet : header = %0h, Payload = %0h, parity = %b", this.header, this.payload, this.parity);
    
  endfunction
  
  function void display_parity();
    
    $display("Small Packet Parity = %b", this.parity);
    
  endfunction
  
  function void display_payload();
    
    $display("Small Packet Payload = %0h", this.payload);
    
  endfunction
  
  function bit calculate_parity();
    
    return ^this.payload;
    
  endfunction
  
endclass
    
class corrupted_packet extends transaction;
  
  function new (bit[7:0] header, bit[15:0] payload);
    
    this.header = header;
    this.payload = payload;
    this.parity = calculate_parity();
    
  endfunction
  
  
  function void print_packets();
    
    $display("Corrupted Packet : Header = %0h, Payload = %0h, Parity = %b", this.header, this.payload, this.parity);
    
  endfunction
  
  function void display_payload();
    
    $display("Corrupted Packet Payload = %0h ", this.payload);
    
  endfunction
  
  function bit calculate_parity();
    
    return ^this.payload;
    
  endfunction
  
  function void display_parity();
    
    $display("Corrupted Packet Parity = %b",this.parity);
    
  endfunction
  
endclass
    
    
module tb();
  
  function void send_packet(transaction t);
    
    $display("Parity Calculated in send packet = %b", t.calculate_parity());
    t.print_packets();
    t.display_payload();
    t.display_parity();
    
  endfunction
  
  large_packet l1;
  small_packet s1;
  corrupted_packet c1;
  
  initial begin
    
    l1 = new(8'h52,16'h150);
    s1 = new(8'h102,16'h264);
    c1 = new(8'h12,16'h315);
    
    send_packet(l1);
    $display("--------------------------------------");
    send_packet(s1);
    $display("--------------------------------------");
    send_packet(c1);
    
    $finish;

  end
  
  
endmodule
    
    
  
