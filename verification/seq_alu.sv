class sequencer;
  // sequence items
  transaction t1;
  int  repeats;
  int n_mods=3;
  mailbox seq_driv;
  event done;

  // dummy constructor 
  function new (mailbox seq_driv);
    this.seq_driv = seq_driv;
  endfunction

  task main ();
    $display("reset");
    t1 = new ();
    this.reset;
    seq_driv.put(t1);

    $display ("Mode A Testing");
    repeat (repeats/n_mods) begin
      t1 = new ();
      this.mode_a();
      seq_driv.put(t1);
    end

    $display ("Mode B Testing");
    repeat (repeats/n_mods) begin
      t1 = new ();
      this.mode_b();
      seq_driv.put(t1);
    end

    $display ("Mode gen Testing");
    repeat (repeats/n_mods) begin
      t1 = new ();
      this.mode_gen();
      seq_driv.put(t1);
    end
    //repeat (insert number of repeats) begin
    // direct_test(insert your inputs)
    //  seq_driv.put(t1);
    //end
    -> done;
  endtask

  task mode_a ;
    assert(t1.randomize() with {t1.rst_n&&t1.alu_enable_a&&t1.alu_enable;});
  endtask

  task mode_b ;
    assert(t1.randomize() with {t1.rst_n&&t1.alu_enable_b&&t1.alu_enable;});
  endtask

  task mode_gen;
    assert(t1.randomize());
  endtask 

  //   task direct_test(bit rst_n , logic alu_enable_a , alu_enable_b , alu_enable, alu_irq_clr, alu_in_a, alu_in_b,op_a alu_op_a, op_b alu_op_b);
  //     t1.rst_n            = rst_n        ;
  //     t1.alu_enable_a     = alu_enable_a ;
  //     t1.alu_enable_b     = alu_enable_b ;
  //     t1.alu_enable       = alu_enable   ;
  //     t1.alu_irq_clr      = alu_irq_clr  ;
  //     t1.alu_op_a         = alu_op_a     ;
  //     t1.alu_op_b         = alu_op_b     ;
  //     t1.alu_in_a         = alu_in_a     ;
  //     t1.alu_in_b         = alu_in_b     ;
  //   endtask

  task reset;
    assert(t1.randomize()with {!t1.rst_n;});
  endtask

endclass