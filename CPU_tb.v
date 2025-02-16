`timescale 1ns/1ps

module CPU_tb;
    reg clk, rst;
    reg [18:0] instruction;
    wire [18:0] result;
    
CPU uut(clk, rst, instruction, result);

integer i;
initial begin
    clk=0 ;
    rst= 1;
    instruction = 0;
    
    #10;
    rst = 0;
    
 //add
 instruction = {5'b00000, 4'd1, 4'd2, 4'd3};  // add r1, r2, r3 == r1=r2+r3        first  5bit opcode
 uut. regfile[2] = 19'd5;
 uut.regfile[3] = 19'd10; #10;
 
 instruction = {5'b00001, 4'd1, 4'd2, 4'd3};  // sub r1, r2, r3 == r1=r2-r3        first  5bit opcode
 uut. regfile[2] = 19'd10;
 uut.regfile[3] = 19'd5; #10;
 
 instruction = {5'b00010, 4'd1, 4'd2, 4'd3};  // mult r1, r2, r3 == r1=r2xr3        first  5bit opcode
 uut. regfile[2] = 19'd5;
 uut.regfile[3] = 19'd5; #10;
 
 instruction = {5'b00011, 4'd1, 4'd2, 4'd3};  // div r1, r2, r3 == r1=r2/r3        first  5bit opcode
 uut. regfile[2] = 19'd20;
 uut.regfile[3] = 19'd10; #10;
 
 instruction = {5'b00100, 4'd11, 4'd0, 4'd0};  // increment r1       first  5bit opcode
 uut. regfile[2] = 19'd11;
 #10;
 
 instruction = {5'b00101, 4'd11, 4'd0, 4'd0};  // decrement r1       first  5bit opcode
 uut. regfile[2] = 19'd11;#10;
 
 instruction = {5'b00110, 4'd1, 4'd2, 4'd3};  // and r1, r2, r3 == r1=r2+&3        first  5bit opcode
 uut. regfile[2] = 19'b1010101010101010101;
 uut.regfile[3] = 19'b01010101010101010101; #10;
 
 instruction = {5'b00111, 4'd1, 4'd2, 4'd3};  // or r1, r2, r3 == r1=r2|r3        first  5bit opcode
 uut. regfile[2] = 19'b1010101010101010101;
 uut.regfile[3] = 19'b0110101010101010101; #10;
 
 instruction = {5'b01001, 4'd1, 4'd0, 4'd0};  // not r1, r0       first  5bit opcode
 uut. regfile[0] = 19'b1111111111111111111;
  #10;
 
 instruction = {5'b01000, 4'd1, 4'd2, 4'd3};  // xor r1, r2, r3 == r1=r2^r3        first  5bit opcode
  uut. regfile[2] = 19'b1010101010101010101;
 uut.regfile[3] = 19'b1110101010101010101; #10;
 
 instruction = {5'b01010, 4'd0, 4'd0, 14'd30};  #10; //jmp 30
 instruction = {5'b01011, 4'd0, 4'd0, 14'd40};   // BEQ if r1,r2 40
 uut.regfile[0] = 19'd15; #10;
 
  instruction = {5'b01100, 4'd0, 4'd1, 14'd40};   // BNE if r1,r2 40
 uut.regfile[0] = 19'd15; 
 uut.regfile[1] = 19'd20; #10;
 
 instruction = {5'b01101, 4'b0, 4'b0,14'd60}; // call 60
 #10;
 instruction = {5'b01110, 4'b0, 4'b0,14'd40}; // ret 40
 #10;
 
 instruction = {5'b01111, 4'b1, 4'b0,14'd40};  // load r1, 40
 uut.memory[1] = 19'd1234; #10;
 
 instruction = {5'b10000, 4'd1, 4'b0,14'd20};  // load r1, 40
 uut.regfile[1] = 19'd5678; #10;
 
 uut.regfile[1] = 100;
 uut.regfile[2] = 200;
 
 for(i=0; i<8;i=i+1) 
    uut.memory[200+i] = i+1; // storing values in memory
 instruction = {5'b10001,4'd1,4'd2,6'd0}; #20; // instruction for fft
 
 $display("FFT results");
 for(i=0 ; i<8 ; i=i+1) begin
    $display("memory[%0d]=%0d",100+i,uut.memory[100+i]);  end
    
    
  uut.regfile[1] = 300; // dest
 uut.regfile[2] = 400; //sourse for enc
 
 for(i=0; i<8;i=i+1) 
  uut.memory[400+i] = i+10; // storing values in memory
 instruction = {5'b10010,4'd1,4'd2,6'd0}; #20; // instruction for fencryption
 
 $display("encrypted results");
 for(i=0 ; i<8 ; i=i+1) begin
    $display(" encrypted memory[%0d]=%0d",300+i,uut.memory[300+i]);  end
    
    
  uut.regfile[1] = 500;
 uut.regfile[2] = 300;
 
 
 instruction = {5'b10011,4'd1,4'd2,6'd0}; #20;// instruction for fft
 
 $display("decrypted results");
 for(i=0 ; i<8 ; i=i+1) begin
    $display("decrypted memory[%0d]=%0d",500+i,uut.memory[500+i]);   end
      
 
 #200 $stop;
end
always #5 clk = ~clk;
endmodule