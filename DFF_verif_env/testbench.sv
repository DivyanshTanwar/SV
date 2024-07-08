class transaction;
  
  rand bit d_in;
  bit d_out;
  
  
  function transaction copy();
    
    copy = new();
    copy.d_in = this.d_in;
    copy.d_out = this.d_out;
    
  endfunction
  
  function void display(input string tag);
    
    $display("[%0s]: DATA IN : %0b DATA OUT : %0b",tag,d_in,d_out);
    
  endfunction
  
endclass


class generator;
  
  transaction trans;
  mailbox #(transaction) mbxgendrv;
  mailbox #(transaction) mbxgensco;
  int count;
  event done; // to convey that all the stimulus has been generated
  event sconext; // to convey that scoreboarding for current stimulus is done send next one
  
  function new(mailbox #(transaction) mbxgendrv, mbxgensco);
    
    this.mbxgendrv = mbxgendrv;
    this.mbxgensco = mbxgensco;
    trans = new();
    
  endfunction
  
  task run();
    
    repeat(count) begin
      
      assert(trans.randomize()) else $error("[GEN]: Randomization failed ");
      mbxgendrv.put(trans.copy()); // sending transaction data to drv to drive DUT
      mbxgensco.put(trans.copy()); //sending transaction data to scoreboard to check the correctness of response
      trans.display("GEN");
      @(sconext); // waiting for scoreboard to finish its work for current stimulus
      
    end
    
    -> done;
    
  endtask
  
  
endclass

class driver;
  
  transaction trans;
  mailbox #(transaction) mbx;
  virtual dff_if dif;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    
  endfunction
  
  task run();
    
    forever begin
      
      mbx.get(trans);
      trans.display("DRV");
      dif.d_in <= trans.d_in; //applying input stimulus
      @(posedge dif.clk);

      dif.d_in <= 1'b0; //removing input stimulus
      @(posedge dif.clk);
      
    end
    
  endtask
  
  task rst_dut();
    
    dif.rst  <= 1'b1;
    repeat(5) @(posedge dif.clk);
    dif.rst <= 1'b0;
    @(posedge dif.clk);
    $display("[DRV]: RESET DONE");
    
  endtask
  
  
endclass

class monitor;
  
  transaction trans;
  mailbox #(transaction) mbx;
  virtual dff_if dif;
  
  function new(mailbox #(transaction) mbx);
    
    this.mbx = mbx;
    trans = new();
    
  endfunction
  
  task run();
    
    forever begin
      
      repeat(2) @(posedge dif.clk);
      trans.d_out = dif.d_out;
      mbx.put(trans);
      trans.display("MON");
      
    end
    
  endtask
  
endclass


class scoreboard;
  
  transaction trref, tr;
  mailbox #(transaction) mbxmonsco, mbxgensco;
  event sconext;
  
  function new(mailbox #(transaction) mbxmonsco, mbxgensco);
    
    this.mbxmonsco = mbxmonsco;
    this.mbxgensco = mbxgensco;
    
  endfunction
  
  task comp();		//comparision function , compares values between input from gen and output from DUT(monitor)
    
    if(tr.d_out == trref.d_in) $display("[SCO]: DATA MATCHED");
    else $display("[SCO]: DATA MISMATCHED");
    
    $display("------------------------------------------------");
    
  endtask
  
  task run();
    
    forever begin
      
      mbxmonsco.get(tr);
      mbxgensco.get(trref);
      tr.display("SCO");
      trref.display("REF");
      comp();
      -> sconext;
      
    end
    
  endtask
  
endclass

class environment;
  
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  
  mailbox #(transaction) mbxgendrv, mbxgensco, mbxmonsco;
  virtual dff_if dif;
  event done;
  
  function new(virtual dff_if dif);
    mbxgendrv = new();
    mbxgensco = new();	
    mbxmonsco = new();
    
    gen = new(mbxgendrv, mbxgensco);
    drv = new(mbxgendrv);
    mon = new(mbxmonsco);
    sco = new(mbxmonsco, mbxgensco);
    
    this.dif = dif;
    drv.dif = this.dif;		//connecting interface in driver and monitor to dut
    mon.dif = this.dif;
    
    done = gen.done;
    gen.sconext = sco.sconext;

  endfunction
  
  task pre_test();
    
    drv.rst_dut();
    
  endtask
  
  task test();
    
    fork 
      
      gen.run();
      drv.run();
      mon.run();
      sco.run();
      
    join_any
      
  endtask
  
  task post_test();
    
    wait(done.triggered);
    $finish;
    
  endtask
  
  
  task run();
    
    pre_test();
    test();
    post_test();
    
  endtask

endclass


module tb_top();
  
  environment env;
  dff_if dif();
  dff dut(dif); // instantiating DUT
  
  initial dif.clk <= 1'b0; 
  
  always #10 dif.clk <= ~dif.clk; // clock generation
  
  initial begin
    dif.d_in <= 0;
    env = new(dif);
    env.gen.count = 30; // count for the number of stimulus
    env.run();
    
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars();
    
  end
  
  property dff_behavior;
    @(posedge dif.clk) (dif.rst == 1) |=> (dif.d_out == 0);
  endproperty

  assert property (dff_behavior) else $error("Assertion failed: reset should set q to 0 ---- %0t",$time);

  property dff_follow_d;
    @(posedge dif.clk) (dif.rst == 0) |-> (dif.d_out == $past(dif.d_in));
  endproperty

    assert property (dff_follow_d) else $error("Assertion failed: q should follow d at the rising edge of clk when reset is 0 ---- %0t",$time);
  
endmodule
