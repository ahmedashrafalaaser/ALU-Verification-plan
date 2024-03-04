// `include "package.svh"
`include "transaction.sv"
`include "seq.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "subscriber.sv"
// import classes::*;
class environment;
 //
  //seq1erator and driver instance
  sequencer 	seq;
  driver    	driv;
  monitor   	mon;
  scoreboard	scb;
  subscriber 	sub;

  //mailbox handle's
  mailbox seq_driv;
  mailbox mon_score;
  mailbox mon_sub;

  //virtual interface
  virtual intf vif;

  //constructor
  function new(virtual intf vif);
    //get the interface from test
    this.vif = vif;

    //creating the mailbox (Same handle will be shared across seq1erator and driver)
    seq_driv  = new();
    mon_sub   = new();
    mon_score = new();

    //creating seq1erator and driver
    seq  = new(seq_driv);
    driv = new(vif,seq_driv);
    mon  = new(vif,mon_sub,mon_score);
    scb  = new(mon_score);
    sub  = new(mon_sub);
  endfunction

  //
//   task pre_test();
//     seq.reset();
//   endtask

  task test();
    fork 
      seq.main();
      driv.run_drv();
      mon.run_mon();
      scb.checking();
      sub.sub();
    join_any
  endtask

  task post_test();
    wait(seq.done.triggered);
    wait(seq.repeats == driv.no_transactions); //Optional
    wait(seq.repeats == scb.no_transactions);
  endtask  

  //run task
  task run;
//     pre_test();
    test();
    post_test();
    $finish;
  endtask

endclass
