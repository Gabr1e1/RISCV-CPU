/* ACM Class System (I) 2018 Fall Assignment 1 
 *
 * Part I: Write an adder in Verilog
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */
 
//worse-than-naive version
//module adder(in1, in2, out, overflow);
//    input in1, in2;
//    output out, overflow;
    
//    wire[15:0] in1, in2;
//    reg[15:0] out;
//    reg overflow;
//    integer i;
//    always @ (in1, in2) begin
//            overflow = 0;
//            for (i = 0; i < 16; i = i + 1) begin
//                out[i] = in1[i] ^ in2[i] ^ overflow;
//                overflow = (in1[i] & in2[i]) | ((in1[i] ^ in2[i]) & overflow);
//            end
//        end
//endmodule

module full_adder(input a, input b, input c1, output o, output c2);
    assign o = a ^ b ^ c1;
    assign c2 = (a & b) | ((a ^ b) & c1);
endmodule

module adder(input [15:0] in1, input [15:0] in2, output [15:0] out, output overflow);
    wire[15:1] c;
    full_adder add0(in1[0], in2[0], 0, out[0], c[1]);
    full_adder add[14:1](in1[14:1], in2[14:1], c[14:1], out[14:1], c[15:2]);
    full_adder add15(in1[15], in2[15], c[15], out[15], overflow);           
endmodule