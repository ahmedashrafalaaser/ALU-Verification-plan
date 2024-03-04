`include "package.svh"
import classes::*;
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
  constraint const0 { rst_n dist {0:=5, 1:=15}; }

  constraint const1 { !(alu_enable && alu_enable_a && alu_enable_b); }

  constraint const2 {  alu_enable dist {0:=5, 1:=20}; }

  constraint const3 {  if (alu_enable && alu_enable_a && (alu_op_a == 2'b00)) 
    alu_in_b !=8'h0;}

  constraint const4 {  if (alu_enable && alu_enable_a && (alu_op_a == 2'b01)) 
  { alu_in_b !=8'h03;
   alu_in_a !=8'hff;}
                    }                         
    constraint const5 {  if (alu_enable && alu_enable_b && (alu_op_b == 2'b01)) 
      alu_in_b !=8'h03;}
    constraint const6 {  if (alu_enable && alu_enable_b && (alu_op_b == 2'b10)) 
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