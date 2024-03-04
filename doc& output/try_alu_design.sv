module ALU (
	input alu_clk,    // Clock
	input rst_n,  // Asynchronous reset active low
	input alu_enable_a,
	input alu_enable_b,
	input alu_enable,
	input alu_irq_clr,
	input [1:0]alu_op_a,
	input [1:0]alu_op_b,
	input [7:0]alu_in_a,
    input [7:0]alu_in_b,
	output reg alu_irq,
	output reg [7:0]alu_out	
);
parameter 
MODE_E=2'b11,MODE_ILL=3'b111;
always @(posedge alu_clk or negedge rst_n) begin : proc_
	if(!rst_n) begin
		alu_out <= 8'b0;
		alu_irq <= 1'b0;
	end else begin
		if(alu_irq_clr)
			alu_irq<=0;
		if(({alu_enable,alu_enable_a}==MODE_E)&&(alu_enable_b!==1'b1))begin
			case (alu_op_a)
				2'b00:begin if(alu_in_b==8'b0) alu_out<=8'bx;
							else begin
								alu_out<=alu_in_a & alu_in_b;
								if((alu_in_a & alu_in_b)==8'hff)
									alu_irq<=1'b1;
							end
						end
				2'b01:begin	if(alu_in_b==8'h03||alu_in_a==8'hff) alu_out<=8'bx;
							else begin
								alu_out<=~(alu_in_a & alu_in_b);
								if(~(alu_in_a & alu_in_b)==8'h00)
									alu_irq<=1'b1;
							end
						end 
				2'b10:begin	alu_out<=alu_in_a | alu_in_b;
								if((alu_in_a | alu_in_b)==8'hf8)
									alu_irq<=1'b1;	
						end 
				2'b11:begin alu_out<=alu_in_a ^ alu_in_b;
								if((alu_in_a ^ alu_in_b)==8'h83)
									alu_irq<=1'b1;	
						end
			endcase
		end
		else if({alu_enable,alu_enable_b}==MODE_E&&alu_enable_a!==1'b1)begin
			case (alu_op_b)
				2'b00:begin alu_out<=~(alu_in_a ^ alu_in_b);
								if(~(alu_in_a ^ alu_in_b)==8'hf1)
									alu_irq<=1'b1;	
						end
				2'b01:begin if(alu_in_b==8'h03) alu_out<=8'bx;
							else begin
								alu_out<=alu_in_a & alu_in_b;
								if((alu_in_a & alu_in_b)==8'hf4)
									alu_irq<=1'b1;
							end
						end
				2'b10:begin if(alu_in_a==8'hf5) alu_out<=8'bx;
							else begin
								alu_out<=~(alu_in_a | alu_in_b);
								if(~(alu_in_a | alu_in_b)==8'hf5)
									alu_irq<=1'b1;
							end
						end 
				2'b11:begin	alu_out<=alu_in_a | alu_in_b;
								if((alu_in_a | alu_in_b)==8'hff)
									alu_irq<=1'b1;	
						end
			endcase
		end
		else if({alu_enable,alu_enable_a,alu_enable_b}==MODE_ILL)begin
			alu_out<=8'bx;
		end

	end
end


endmodule : ALU