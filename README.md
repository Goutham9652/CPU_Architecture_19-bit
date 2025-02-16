# -CPU_Architecture_19-bit-

/////////////////////////////////////////////////////////////////**Overview**///////////////////////////////////////////////////////////////////////////////////

This project implements a custom 19-bit CPU architecture in Verilog, following a Harvard architecture style with separate instruction and data memories. The design adopts a modular approach by isolating arithmetic/logic operations into a dedicated Extended ALU module while the CPU module handles instruction decoding, control flow, and specialized operations.

/////////////////////////////////////////////////////////////////**Architecture Details**///////////////////////////////////////////////////////////////////////
Data Width:
All registers, memory words, and data paths are 19 bits wide.

General Purpose Registers:
The CPU features 16 general-purpose registers, each 19 bits wide, which store temporary data and computation results.

Memory:
The design includes 524,288 memory addresses (2^19), which serve instruction and data storage, enabling efficient data access.

Instruction Format:
Each 19-bit instruction consists of:

Opcode (5 bits): Defines the operation (e.g., arithmetic, logical, control, or memory access).
Register Operands (12 bits total): Three 4-bit fields (r1, r2, r3) designate the registers involved.
Immediate Value (14 bits): Used for addressing and immediate data, with zero extension to 19 bits when necessary.
Control Signals:
The design is synchronous, driven by a clock signal with an asynchronous reset that initializes the program counter, registers, and memory.

///////////////////////////////////////////////////////////////// Modular Design //////////////////////////////////////////////////////////////////////////
1> CPU Module
--Instruction Decoding:
The CPU module extracts the opcode, register operands, and immediate values from the instruction.

--Control Flow:
It manages jumps (JMP), branches (BEQ/BNE), subroutine calls (CALL), and returns (RET) by updating the program counter and managing the stack pointer.

--Memory Access:
Instructions such as LD (load) and ST (store) are implemented to interact with the separate memory.

--Specialized Tasks:
Operations like FFT, encryption, and decryption are implemented as tasks within the CPU module.

--Extended ALU Module
Arithmetic & Logical Operations:
Performs operations like ADD, SUB, MUL, DIV, INC, DEC, AND, OR, XOR, and NOT.

--Control Flow & Memory Addressing:
In addition to basic operations, the ALU computes effective addresses for JMP, LD, ST and even handles conditional branch decisions (BEQ/BNE). For subroutine calls (CALL), it computes the return address.

--Seamless Integration:
The Extended ALU is instantiated within the CPU module, centralizing the bulk of computational tasks while simplifying the overall design.

Instruction Set

--Arithmetic Operations:
ADD, SUB, MUL, DIV: Standard arithmetic operations.
INC, DEC: Increment and decrement operations.

--Logical Operations:
AND, OR, XOR, NOT: Bitwise logical operations.
Control Flow:

--JMP: Unconditional jump.
--BEQ/BNE: Conditional branches based on register comparisons.
--CALL/RET: Subroutine call and return mechanism using an internal stack.

Memory Access:

--LD: Load data from a memory address specified in the immediate field.
ST: Store data to a memory address specified in the immediate field.
Specialized Operations:

--FFT: Processes a block of eight memory words by incrementing each value.
Encryption/Decryption: Uses an XOR operation with a fixed key to encrypt and decrypt data blocks.
Testing
A test bench is included that demonstrates:

FFT Operation:

A block of memory is preloaded with sequential data.
The FFT task copies these values to a new memory region, incrementing each by one.
Results can be observed in the designated destination addresses.
Encryption and Decryption:

A memory block is encrypted using the XOR-based algorithm.
The encrypted data is then decrypted back to its original form, verifying the correct operation of both tasks.

The below opcodes performs their corresponding operations.

| Opcode  | Operation | Description                                            |
|---------|-----------|--------------------------------------------------------|
| 00000   | ADD       | r1 = r2 + r3 (Addition)                                |
| 00001   | SUB       | r1 = r2 - r3 (Subtraction)                             |
| 00010   | MUL       | r1 = r2 * r3 (Multiplication)                          |
| 00011   | DIV       | r1 = r2 / r3 (Division)                                |
| 00100   | INC       | r1 = r1 + 1 (Increment)                                |
| 00101   | DEC       | r1 = r1 - 1 (Decrement)                                |
| 00110   | AND       | r1 = r2 & r3 (Bitwise AND)                             |
| 00111   | OR        | r1 = r2 \| r3 (Bitwise OR)                             |
| 01000   | XOR       | r1 = r2 ^ r3 (Bitwise XOR)                             |
| 01001   | NOT       | r1 = ~r2 (Bitwise NOT)                                 |
| 01010   | JMP       | PC = immediate (Unconditional jump)                    |
| 01011   | BEQ       | if (r1 == r2) then PC = immediate (Branch if Equal)    |
| 01100   | BNE       | if (r1 != r2) then PC = immediate (Branch if Not Equal)|
| 01101   | CALL      | Push (PC+1) to stack; PC = immediate (Call subroutine) |
| 01110   | RET       | Pop return address from stack to PC (Return)           |
| 01111   | LD        | r1 = memory[immediate] (Load from memory)              |
| 10000   | ST        | memory[immediate] = r1 (Store to memory)               |
| 10001   | FFT       | Execute FFT task (increment each of 8 memory words)    |
| 10010   | ENC       | Execute encryption task (XOR with a fixed key)         |
| 10011   | DEC (Dec) | Execute decryption task (XOR with the same key)        |
