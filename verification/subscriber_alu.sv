// `include "package.svh"
class subscriber;
  // import classes::*;
  transaction t4;

  mailbox mon_sub;
  function new(mailbox mon_sub);
    this.mon_sub=mon_sub;
    g1_tgl=new();
    g2=new();
    g3=new();
    g4_illegal=new();
    g5_irq=new();
  endfunction : new

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
    option.name         = "g3";
    op_a:  coverpoint t4.alu_op_a iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_a)
    { 
      bins a_AND  = {AND_a} ;
      bins a_NAND = {NAND_a};
      bins a_OR   = {OR_a}  ;
      bins a_XOR  = {XOR_a} ;
    }
    op_b: coverpoint t4.alu_op_b iff(t4.rst_n&&t4.alu_enable && t4.alu_enable_b)
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

  task sub;

    forever begin
      mon_sub.get(t4);
      g1_tgl.sample();
      g2.sample();
      g3.sample();
      g4_illegal.sample();
      g5_irq.sample();
//       $display("time is %0t coverage of g1_tgl is %f ", $time, g1_tgl.get_coverage());
//       $display("time is %0t coverage of g2 is %f ", $time, g2.get_coverage());
//       $display("time is %0t coverage of g3 is %f ", $time, g3.get_coverage());
//       $display("time is %0t coverage of g4 is %f ", $time, g4_illegal.get_coverage());
//       $display("time is %0t coverage of g5 is %f ", $time, g5_irq.get_coverage());
    end
  endtask
endclass
