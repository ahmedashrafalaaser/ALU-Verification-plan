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