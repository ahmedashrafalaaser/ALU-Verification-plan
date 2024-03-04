package classes;

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

endpackage