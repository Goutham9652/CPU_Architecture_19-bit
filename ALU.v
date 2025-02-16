module ALU(
    input [4:0] opcode,
    input [18:0] a,
    input [18:0] b,
    input [18:0] pc,
    input [18:0] immediate,
    output reg [18:0] alu_out,
    output reg [18:0] ret_addr
);
    always @(*) begin
        ret_addr = 19'b0;
        case(opcode)
        // arithmatic aand logic operations
            5'b00000: alu_out <= a + b ;
            5'b00001: alu_out <= a-b;
            5'b00010: alu_out <= a*b;
            5'b00011: alu_out <= a/b;
            5'b00100: alu_out <= a+1;
            5'b00101: alu_out <= a-1;
            5'b00110: alu_out <= a&b;
            5'b00111: alu_out <= a|b;
            5'b01000: alu_out <= a^b;
            5'b01001: alu_out <= ~a;     
            
          //mem operations
           5'b01010: begin               //jmp
                    alu_out <= immediate;
           end    
            5'b01011: begin
                if(a==b)           // branch if equal
                    alu_out <= immediate;
                else   alu_out <= pc+1;
            end
            
            5'b01100: begin        // branch if unequal
                    if(a!=b)
                        alu_out <= immediate;
                    else alu_out <= pc+1;  end
                    
            5'b01101: begin                   // call
                    ret_addr <= pc+1;
                    alu_out  <= immediate;
            end
            
            5'b01110: begin                       // return
                    alu_out <= a;
            end
            
            5'b01111: begin                       // load
                    alu_out <= immediate;
            end
            
             5'b10000: begin                         // store
                    alu_out <= immediate;
            end
        endcase
        
    end

endmodule

