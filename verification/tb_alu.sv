//`include "package.svh"
`include "interface.sv" 
`include "rand.sv" 

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

endmodule