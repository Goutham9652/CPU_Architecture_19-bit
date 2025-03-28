module CPU(
       input clk,
       input rst,
       input [18:0] instruction,
       output reg [18:0] result
);

    reg [18:0] regfile [0:15];       // temporary registers
    reg [18:0] memory  [0:524288];   // data memory to read write
    reg [18:0] pc;                   // program counter
    reg [18:0] stack [0:15];         // stack for storing next address when call mnemonic is called
    reg [3:0]  sp;                   // stack pointer to point the stack memory
    
    // instruction decodeing
    wire [4:0] opcode;
    wire [4:0] r1,r2,r3;
    wire [18:0] immediate;
    
    assign opcode = instruction[18:14];
    assign r1     = instruction[13:10];
    assign r2     = instruction[9:6];
    assign r3     = instruction[5:2];
    assign immediate = {5'b0, instruction[13:0]};
    
    wire [18:0] a,b;
    
    assign a = (opcode == 5'b00100 || opcode == 5'b00101)? regfile[r1]:
               (opcode == 5'b01001) ? regfile[r2] : 
               ((opcode >= 5'b00000 && opcode <= 5'b00101) ? regfile[r2] : 
               ((opcode == 5'b01011 || opcode == 5'b01100) ? regfile[r1] : 19'b0 ));
           
    assign b = ((opcode >= 5'b00000 && opcode <= 5'b00011) || 
               (opcode >= 5'b00110 && opcode <= 5'b01000)) ? regfile[r3]:
               ((opcode == 5'b01011 || opcode == 5'b01100) ? regfile[r2] : 19'b0);
               
    wire [18:0] alu_out ;
    wire [18:0] ret_addr;
    
    ALU alu_inst(opcode, a, b, pc, immediate, alu_out, ret_addr);   // instantiating the alu module
    
    integer i;
    always @(posedge clk or posedge rst) begin
            if(rst) begin
                pc <= 0;
                sp <= 0;
                result <= 0;
                for(i=0; i<16; i=i+1)
                        regfile[i] <= 0;
            end
            
            else  begin
                case(opcode)
                    5'b00000, 5'b00001, 5'b00010, 5'b00011, 5'b00100, 5'b000101, 5'b000110, 5'b000111, 5'b01000, 5'b01001: begin   //computed in alu module
                            regfile[r1] <= alu_out;
                            pc <= pc+1;
                    end
                    
                    5'b01011, 5'b01010, 5'b01100: begin     //jump if equal, unequal
                        pc <= alu_out;
                    end
                    
                    5'b01101: begin                       // call
                        stack[sp] <= ret_addr;
                        sp <= sp-1;
                        pc <= alu_out;
                    end
                    
                    5'b01110: begin                         // return
                        pc <= alu_out;
                        sp <= sp+1;
                    end
                    
                    5'b01111: begin                             // load into register from memory
                          regfile[r1] <= memory[alu_out];
                          pc <= pc+1;
                          
                    end
                    
                    5'b10000: begin                                // store into mmory
                          memory[alu_out] <= regfile[r1];
                          pc <= pc+1;
                          
                    end
                    
                    
                    
                    5'b10010: begin
                        encrypt(regfile[r1], regfile[r2]);                    // calling the encryption task
                        pc <= pc+1;
                    end
                    
                    5'b10011: begin
                        decrypt(regfile[r1], regfile[r2]);                 // calling the decryption task
                        pc <= pc+1;
                    end
                    
                    default : pc <= pc+1;
                endcase
            end
    end
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
     task encrypt;
        input [18:0] test;
        input [18:0] source;
         reg [18:0] key;     // key to encrypt data
        integer i;
        
        begin
        key = 19'b0011001100110011111  ;  
            for(i=0; i<8; i=i+1)
                memory[test + i] <= memory[source + i] ^ key;           // xor method for encryption
        end
    endtask
    
     task decrypt;
        input [18:0] test;
        input [18:0] source;
        reg [18:0] key;
                             // same key to decrypt data
        integer i;
        
        begin
        key = 19'b0011001100110011111  ;  
            for(i=0; i<8; i=i+1)
                memory[test + i] <= memory[source + i] ^ key;           // xor method for decryption
        end
    endtask
    
    always @(posedge clk or posedge rst)
    begin 
        if(rst)
            result <= 0;
        else
            result <= regfile[0];                              // assigninf final result
    end
    
endmodule