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


