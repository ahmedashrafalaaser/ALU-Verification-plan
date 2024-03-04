////////////////////////////MONITOR/////////////////////////////////
class monitor;
  virtual intf intf_mon;
  mailbox mon_sub;
  mailbox mon_score;
  function new(virtual intf in_intf,mailbox mon_sub,mailbox mon_score);
    this.intf_mon=in_intf;
    this.mon_sub=mon_sub;
    this.mon_score=mon_score;
  endfunction 

  task run_mon();

    forever begin 
      transaction t2;
      t2=new();
      @(posedge intf_mon.clk);

      t2.rst_n            = intf_mon.rst_n        ;
      t2.alu_enable_a     = intf_mon.alu_enable_a ;
      t2.alu_enable_b     = intf_mon.alu_enable_b ;
      t2.alu_enable       = intf_mon.alu_enable   ;
      t2.alu_irq_clr      = intf_mon.alu_irq_clr  ;
     t2.alu_op_a         = intf_mon.alu_op_a     ;
//       $cast(t2.alu_op_a,intf_mon.alu_op_a )       ;
      t2.alu_op_b         = intf_mon.alu_op_b     ;
//       $cast(t2.alu_op_b,intf_mon.alu_op_b )		  ;
      t2.alu_in_a         = intf_mon.alu_in_a     ;
      t2.alu_in_b         = intf_mon.alu_in_b     ; 
      @(posedge intf_mon.clk);
      t2.alu_irq          = intf_mon.alu_irq      ;
      t2.alu_out          = intf_mon.alu_out      ;
      @(posedge intf_mon.clk);
      mon_sub.put(t2);
      mon_score.put(t2);
      $display ("monitor transaction is %p at time : %0t",t2,$realtime);
    end

  endtask : run_mon

endclass