
// parameter  clk_period =10;

typedef enum logic [1:0] {AND_a  = 2'b00,
                        NAND_a = 2'b01,
                        OR_a   = 2'b10,
                        XOR_a  = 2'b11 } op_a;

typedef enum logic [1:0] {XNOR_b = 2'b00,
                        AND_b  = 2'b01,
                        NOR_b  = 2'b10,
                        OR_b   = 2'b11 } op_b;

// `include "transaction.sv"
// `include "seq.sv"
// `include "driver.sv"
// `include "monitor.sv"
// `include "scoreboard.sv"
// `include "subscriber.sv"
// `include "env.sv"
// `include "rand.sv"




class transaction;

  // import classes::*;
  // transaction items

  rand  bit                     rst_n;
  rand  logic                   alu_enable_a;
  rand  logic                   alu_enable_b;
  rand  logic                   alu_enable;
  rand  logic                   alu_irq_clr;
  rand  op_a                    alu_op_a;
  rand  op_b                    alu_op_b;
  rand  logic [7:0]             alu_in_a;
  rand  logic [7:0]             alu_in_b;
  logic                   alu_irq;
  logic [7:0]             alu_out;
  local bit                   alu_irq_last;
  local bit                   alu_irq_clr_last;

  // dummy constructor 
  function new;

    this.alu_enable_a=0;
    this.alu_enable_b=0;
    this.alu_enable=0;
    this.alu_irq_clr=0;
        this.alu_op_a=AND_a;
//     $cast(this.alu_op_a,0);
        this.alu_op_b=XNOR_b;
//     $cast(this.alu_op_b,0);
    this.alu_in_a=0;
    this.alu_in_b=0;
    this.alu_irq=0;
    this.alu_out=0;

  endfunction

  // Randomization Constraints
  constraint const0 { rst_n dist {0:=15, 1:=95}; }

  constraint const1 { !(alu_enable && alu_enable_a && alu_enable_b); }

  constraint const2 {  alu_enable dist {0:=15, 1:=95}; }

  constraint const3 {  if (alu_enable && alu_enable_a && (alu_op_a == 2'b00)) 
    alu_in_b !=8'h0;}

  constraint const4 {  if (alu_enable && alu_enable_a && (alu_op_a == 2'b01)) 
  { alu_in_b !=8'h03;
   alu_in_a !=8'hff;}
                    }                         
    constraint const5 {  if (alu_enable && alu_enable_b && (alu_op_b == 2'b01)) 
      alu_in_b !=8'h03;}
    constraint const6 {  if (alu_enable && alu_enable_a && (alu_op_b == 2'b10)) 
      alu_in_a !=8'hf5;}          

    constraint const7 {  if (alu_irq_last&&!alu_irq_clr_last) 
      alu_irq_clr ==1;} 

    constraint const8 {  if (alu_irq_clr_last) 
      alu_irq_clr ==0;} 


    function void post_randomize;
                     alu_irq_last = alu_irq;
                     alu_irq_clr_last =alu_irq_clr;
                     endfunction

                     endclass

                     class sequencer;
  // sequence items
  transaction t1;
  int  repeats;
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

/*   
 $display ("Mode A Testing");
    repeat (repeats) begin
      t1 = new ();
      this.mode_a();
      seq_driv.put(t1);
    end

    $display ("Mode B Testing");
    repeat (repeats) begin
      t1 = new ();
      this.mode_b();
      seq_driv.put(t1);
    end
*/
    $display ("Mode gen Testing");
    repeat (repeats) begin
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
   //assert(t1.randomize()with {t1.rst_n&&alu_enable;});
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
///////////////////////////////SCOREBOARD//////////////////////////////////

class scoreboard;

  logic [7:0] alu_out_exp;
  logic       alu_irq_exp;
  mailbox mon_score;
  int no_transactions,correct ,wrong;
  function new(mailbox mon_score);
    this.mon_score=mon_score;
  endfunction : new
  parameter 
  MODE_E=2'b11,MODE_ILL=3'b111;

  task checking;
    transaction t3;
    forever begin
      mon_score.get(t3); 

      if(t3.rst_n==0)
        begin
          alu_out_exp = 8'b0;
          alu_irq_exp = 1'b0;  
        end 

      else begin
        if(t3.alu_irq_clr) 

          alu_irq_exp = 1'b0;
        if(({t3.alu_enable,t3.alu_enable_a}==MODE_E)&&(t3.alu_enable_b!==1'b1))begin
          case (t3.alu_op_a)
            2'b00:begin if(t3.alu_in_b==8'b0) alu_out_exp = 8'bx;
              else begin
                alu_out_exp = t3.alu_in_a & t3.alu_in_b;
                if((t3.alu_in_a & t3.alu_in_b)==8'hff)
                  alu_irq_exp = 1'b1;
              end
            end
            2'b01:begin    if(t3.alu_in_b==8'h03||t3.alu_in_a==8'hff) alu_out_exp =8'bx;
              else begin
                alu_out_exp =~(t3.alu_in_a & t3.alu_in_b);
                if(~(t3.alu_in_a & t3.alu_in_b)==8'h00)
                  alu_irq_exp =1'b1;
              end
            end 
            2'b10:begin    alu_out_exp =t3.alu_in_a | t3.alu_in_b;
              if((t3.alu_in_a | t3.alu_in_b)==8'hf8)
                alu_irq_exp =1'b1; 
            end 
            2'b11:begin alu_out_exp =t3.alu_in_a ^ t3.alu_in_b;
              if((t3.alu_in_a ^ t3.alu_in_b)==8'h83)
                alu_irq_exp =1'b1; 
            end
          endcase
        end
        else if({t3.alu_enable,t3.alu_enable_b}==MODE_E&&t3.alu_enable_a!==1'b1)begin
          case (t3.alu_op_b)
            2'b00:begin alu_out_exp =~(t3.alu_in_a ^ t3.alu_in_b);
              if(~(t3.alu_in_a ^ t3.alu_in_b)==8'hf1)
                alu_irq_exp =1'b1; 
            end
            2'b01:begin if(t3.alu_in_b==8'h03) alu_out_exp =8'bx;
              else begin
                alu_out_exp =t3.alu_in_a & t3.alu_in_b;
                if((t3.alu_in_a & t3.alu_in_b)==8'hf4)
                  alu_irq_exp =1'b1;
              end
            end
            2'b10:begin if(t3.alu_in_a==8'hf5) alu_out_exp<=8'bx;
              else begin
                alu_out_exp =~(t3.alu_in_a | t3.alu_in_b);
                if(~(t3.alu_in_a | t3.alu_in_b)==8'hf5)
                  alu_irq_exp = 1'b1;
              end
            end 
            2'b11:begin    alu_out_exp =t3.alu_in_a | t3.alu_in_b;
              if((t3.alu_in_a | t3.alu_in_b)==8'hff)
                alu_irq_exp = 1'b1; 
            end
          endcase
        end
        else if({t3.alu_enable,t3.alu_enable_a,t3.alu_enable_b}==MODE_ILL)begin
          alu_out_exp =8'bx;
        end


      end

      $display ("scoreboard transaction is %p at time : %0t",t3,$realtime);
      no_transactions++;

      if (t3.alu_irq == alu_irq_exp && t3.alu_out == alu_out_exp) begin
        $display("Result is as Expected");
        correct ++;
      end
      else begin
        $display("wrong !");
        $display("Wrong Alu_out is: %0h \t the EXpected is %0h",t3.alu_out,alu_out_exp);
        $display("Wrong Alu_irq is: %0h \t the EXpected is %0h",t3.alu_irq,alu_irq_exp);
      end
    end
  endtask


endclass

// `include "package.svh"
class subscriber;
  // import classes::*;
  transaction t4;

  mailbox mon_sub;

  covergroup g1_tgl();
    al_in_a0:coverpoint t4.alu_in_a[0] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a1:coverpoint t4.alu_in_a[1] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a2:coverpoint t4.alu_in_a[2] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a3:coverpoint t4.alu_in_a[3] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a4:coverpoint t4.alu_in_a[4] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a5:coverpoint t4.alu_in_a[5] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a6:coverpoint t4.alu_in_a[6] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_a7:coverpoint t4.alu_in_a[7] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}

    al_in_b0:coverpoint t4.alu_in_b[0] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b1:coverpoint t4.alu_in_b[1] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b2:coverpoint t4.alu_in_b[2] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b3:coverpoint t4.alu_in_b[3] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b4:coverpoint t4.alu_in_b[4] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b5:coverpoint t4.alu_in_b[5] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b6:coverpoint t4.alu_in_b[6] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    al_in_b7:coverpoint t4.alu_in_b[7] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}

    alu_out0:coverpoint t4.alu_out[0] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out1:coverpoint t4.alu_out[1] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out2:coverpoint t4.alu_out[2] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out3:coverpoint t4.alu_out[3] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out4:coverpoint t4.alu_out[4] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out5:coverpoint t4.alu_out[5] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out6:coverpoint t4.alu_out[6] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_out7:coverpoint t4.alu_out[7] iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}

    alu_enable:coverpoint t4.alu_enable iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alu_enable_a:coverpoint t4.alu_enable_a iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
    alue_enable_b:coverpoint t4.alu_enable_b iff(t4.rst_n)
    {bins toggle_bit0[] = ( 1,0 => 1,0);}
  endgroup


  covergroup g2;
    coverpoint t4.rst_n 
    {
      bins asserted   = {1};
      bins deasserted = {0};
    }
    enable:  coverpoint t4.alu_enable
    {
      bins asserted   = {1};
      bins deasserted = {0};
    }
    enable_a:  coverpoint t4.alu_enable_a
    {
      bins asserted   = {1};
      bins deasserted = {0};
    }
    enable_b:   coverpoint t4.alu_enable_b
    {
      bins asserted   = {1};
      bins deasserted = {0};
    }
    enables_c : cross enable,enable_a,enable_b
    {illegal_bins all_en = binsof (enable) intersect {1} && binsof (enable_a) intersect {1} && binsof(enable_b) intersect {1};
    }

    coverpoint t4.alu_irq
    {
      bins asserted   = {1};
      bins deasserted = {0};
      bins susccessive0 = (1[*2:4]);
    }

    successive_irq_with_clr : coverpoint t4.alu_irq iff(t4.alu_irq_clr)
    { bins susccessive1 = (1[*2:4]);}
    successive_irq_without_clr :coverpoint t4.alu_irq iff(!t4.alu_irq_clr)
    { bins susccessive2 = (1[*2:4]);}
    coverpoint t4.alu_irq_clr
    {
      bins asserted   = {1};
      bins deasserted = {0};
    }
    interrupt_cross : cross t4.alu_irq_clr, t4.alu_irq;
  endgroup

  covergroup g3; 
   
    op_a:  coverpoint t4.alu_op_a iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_a)
    { 
      bins a_AND  = {AND_a} ;
      bins a_NAND = {NAND_a};
      bins a_OR   = {OR_a}  ;
      bins a_XOR  = {XOR_a} ;
    }
    op_b: coverpoint t4.alu_op_b iff(t4.rst_n && t4.alu_enable && t4.alu_enable_b)
    {
      bins b_XNOR = {XNOR_b};
      bins b_AND  = {AND_b} ;
      bins b_NOR  = {NOR_b} ;
      bins b_OR   = {OR_b}  ;
    }

  endgroup:g3

  covergroup g4_illegal;

    op_aa:  coverpoint t4.alu_op_a iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_a)
    { 
      bins a_AND  = {AND_a} ;
      bins a_NAND = {NAND_a};
      bins a_OR   = {OR_a}  ;
      bins a_XOR  = {XOR_a} ;
    }
    op_bb: coverpoint t4.alu_op_b iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_b)
    {
      bins b_XNOR = {XNOR_b};
      bins b_AND  = {AND_b} ;
      bins b_NOR  = {NOR_b} ;
      bins b_OR   = {OR_b}  ;
    }


    forbiiden_values_a :  coverpoint t4.alu_in_a iff(t4.alu_enable && t4.rst_n)
    {
      bins illegal_nand_a = {8'hff}; 
      bins illegal_nor_b  = {8'hf5};
    }

    forbiiden_values_b :  coverpoint t4.alu_in_b iff(t4.alu_enable && t4.rst_n)
    {
      bins illegal_and_a  = {8'h00};
      bins illegal_nand_b = {8'h03};
      bins illegal_and_b  = {8'h03}; 
    }

    forbidden_cross: cross forbiiden_values_a, op_aa , forbiiden_values_b ,op_bb
    {
      illegal_bins AND_a_inb  = binsof(forbiiden_values_b)  intersect{8'h00}  && binsof(op_aa) intersect{AND_a}; 
      illegal_bins NAND_a_ina = binsof(forbiiden_values_a)  intersect{8'hff}  && binsof(op_aa) intersect{NAND_a};
      illegal_bins NAND_a_inb = binsof(forbiiden_values_b)  intersect{8'h03}  && binsof(op_aa) intersect{NAND_a};
      illegal_bins AND_b_inb  = binsof(forbiiden_values_b)  intersect{8'h03}  && binsof(op_bb) intersect{AND_b}; 
      illegal_bins NOR_b_ina  = binsof(forbiiden_values_a)  intersect{8'hf5}  && binsof(op_bb) intersect{NOR_b}; 
    }

  endgroup

  covergroup g5_irq;

    op_aaa:  coverpoint t4.alu_op_a iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_a)
    { 
      bins a_AND  = {AND_a} ;
      bins a_NAND = {NAND_a};
      bins a_OR   = {OR_a}  ;
      bins a_XOR  = {XOR_a} ;
    }
    op_bbb: coverpoint t4.alu_op_b iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_b)
    {
      bins b_XNOR = {XNOR_b};
      bins b_AND  = {AND_b} ;
      bins b_NOR  = {NOR_b} ;
      bins b_OR   = {OR_b}  ;
    }



    ALU_OUT:coverpoint t4.alu_out iff(t4.rst_n)
    {
      bins bin00 = {8'h00}; 
      bins bin83 = {8'h83}; 
      bins binf1 = {8'hf1}; 
      bins binf4 = {8'hf4}; 
      bins binf5 = {8'hf5}; 
      bins binf8 = {8'hf8};
      bins binff = {8'hff};
    }
    irq_events_a_cross: cross ALU_OUT, op_aaa
    {
      bins bin00 = binsof(ALU_OUT) intersect{8'h00} && binsof(op_aaa) intersect{NAND_a};
      bins bin83 = binsof(ALU_OUT) intersect{8'h83} && binsof(op_aaa) intersect{XOR_a}; 
      bins binf8 = binsof(ALU_OUT) intersect{8'hf8} && binsof(op_aaa) intersect{OR_a};
      bins binff = binsof(ALU_OUT) intersect{8'hff} && binsof(op_aaa) intersect{AND_a};
    }
    irq_event_b_cross: cross ALU_OUT,op_bbb
    {

      bins binf1 = binsof(ALU_OUT) intersect{8'hf1} && binsof(op_bbb) intersect{XNOR_b};
      bins binf4 = binsof(ALU_OUT) intersect{8'hf4} && binsof(op_bbb) intersect{AND_b}; 
      bins binf5 = binsof(ALU_OUT) intersect{8'hf5} && binsof(op_bbb) intersect{NOR_b};
      bins binff = binsof(ALU_OUT) intersect{8'hff} && binsof(op_bbb) intersect{OR_b};
    }

  endgroup

  function new(mailbox mon_sub);
    this.mon_sub=mon_sub;
    g1_tgl=new();
    g2=new();
    g3=new();
    g4_illegal=new();
    g5_irq=new();
  endfunction : new


  task sub;

    forever begin
      mon_sub.get(t4);
      g1_tgl.sample();
      g2.sample();
      g3.sample();
      g4_illegal.sample();
      g5_irq.sample();
      $display("time is %0t coverage of g1_tgl is %f ", $time, g1_tgl.get_coverage());
      $display("time is %0t coverage of g2 is %f ", $time, g2.get_coverage());
      $display("time is %0t coverage of g3 is %f ", $time, g3.get_coverage());
      $display("time is %0t coverage of g4 is %f ", $time, g4_illegal.get_coverage());
      $display("time is %0t coverage of g5 is %f ", $time, g5_irq.get_coverage());
    end
  endtask
endclass

// `include "package.svh"
// `include "transaction.sv"
// `include "seq.sv"
// `include "driver.sv"
// `include "monitor.sv"
// `include "scoreboard.sv"
// `include "subscriber.sv"
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

// `include "env.sv"
program test(intf i_intf);
  
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(i_intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.seq.repeats = 250000;
    
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram

//`include "package.svh"

interface intf (input bit clk);

bit						rst_n;
logic                   alu_enable_a;
logic                   alu_enable_b;
logic                   alu_enable;
logic                   alu_irq_clr;
logic [1:0]             alu_op_a;
logic [1:0]             alu_op_b;
logic [7:0]             alu_in_a;
logic [7:0]             alu_in_b;
logic                   alu_irq;
logic [7:0]             alu_out;


endinterface

`timescale 1ns/1ps
module top_tb;
  parameter  clk_period =10;
 //import classes::*;
  bit clk;
  intf i1(clk);

  //program
  test program1(i1);
 
  ALU dut (
    .alu_clk          (clk),    
    .rst_n            (i1.rst_n),  
    .alu_enable_a     (i1.alu_enable_a),
    .alu_enable_b     (i1.alu_enable_b),
    .alu_enable       (i1.alu_enable),
    .alu_irq_clr      (i1.alu_irq_clr),
    .alu_op_a         (i1.alu_op_a),
    .alu_op_b         (i1.alu_op_b),
    .alu_in_a         (i1.alu_in_a),
    .alu_in_b         (i1.alu_in_b),
    .alu_irq          (i1.alu_irq),
    .alu_out          (i1.alu_out));



  always #(clk_period / 2) clk = ~clk;


  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end
  
initial begin
  $fsdbDumpfile("tb.fsdb");
  $fsdbDumpvars;
end

endmodule
