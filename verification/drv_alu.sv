//////////////////////////////////////DRIVER///////////////////////
class driver;
	transaction t1;
  int no_transactions;
  virtual intf intf_drv;
  mailbox seq_driv;

  function new(virtual intf in_intf,mailbox seq_driv);
    this.intf_drv=in_intf;
    this.seq_driv=seq_driv;
  endfunction 




  task run_drv();
    forever begin
      
      seq_driv.get(t1);

      @(posedge intf_drv.clk);
      intf_drv.rst_n            = t1.rst_n        ;
      intf_drv.alu_enable_a     = t1.alu_enable_a ;
      intf_drv.alu_enable_b     = t1.alu_enable_b ;
      intf_drv.alu_enable       = t1.alu_enable   ;
      intf_drv.alu_irq_clr      = t1.alu_irq_clr  ;
      intf_drv.alu_op_a         = t1.alu_op_a     ;
      intf_drv.alu_op_b         = t1.alu_op_b     ;
      intf_drv.alu_in_a         = t1.alu_in_a     ;
      intf_drv.alu_in_b         = t1.alu_in_b     ; 
      @(posedge intf_drv.clk);
      @(posedge intf_drv.clk);
      no_transactions++							   ;
      $display ("driver transaction is %p at time : %0t",t1,$realtime);
    end
  endtask : run_drv


endclass
