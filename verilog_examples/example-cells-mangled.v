//
// example-cells.net 
// Example cell library
//
// 31 Mar 2004, Will Toms
//
//


`timescale 1ns/1ps
`define gate_delay 0.090


module __AND2 (out, in0, in1);
  output out;
  input in0, in1;

  and #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __AND3 (out, in0, in1, in2);
  output out;
  input in0, in1, in2;

  and #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2);
endmodule

module __AND4 (out, in0, in1, in2, in3);
  output out;
  input in0, in1, in2, in3;

  and #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2, in3);
endmodule

module __OR2 (out, in0, in1);
  output out;
  input in0, in1;

  or #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __OR3 (out, in0, in1, in2);
  output out;
  input in0, in1, in2;

  or #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2);
endmodule

module __OR4 (out, in0, in1, in2, in3);
  output out;
  input in0, in1, in2, in3;

  or #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2, in3);
endmodule

module __NAND2 (out, in0, in1);
  output out;
  input in0, in1;

  nand #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __NAND3 (out, in0, in1, in2);
  output out;
  input in0, in1, in2;

  nand #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2);
endmodule

module __NAND4 (out, in0, in1, in2, in3);
  output out;
  input in0, in1, in2, in3;

  nand #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2, in3);
endmodule

module __NOR2 (out, in0, in1);
  output out;
  input in0, in1;

  nor #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __NOR3 (out, in0, in1, in2);
  output out;
  input in0, in1, in2;

  nor #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2);
endmodule

module __NOR4 (out, in0, in1, in2, in3);
  output out;
  input in0, in1, in2, in3;

  nor #(`gate_delay, `gate_delay) I0 (out, in0, in1, in2, in3);
endmodule

module __XOR2 (out, in0, in1);
  output out;
  input in0, in1;

  xor #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __XNOR2 (out, in0, in1);
  output out;
  input in0, in1;

  xnor #(`gate_delay, `gate_delay) I0 (out, in0, in1);
endmodule

module __MUTEX (inA, inB, outA, outB);
  input inA, inB;
  output outA, outB;
 	__UDP_mutex_top_half  #(`gate_delay, `gate_delay) M1(outA, inA, inB, outB);
	__UDP_mutex_bottom_half  #(`gate_delay, `gate_delay) M2(outB, inB, inA, outA);
endmodule

module __BUF (out, in);
  output out;
  input in;

  buf #(`gate_delay, `gate_delay) I1 (out, in);
endmodule

module __BUFF (out, in);
  output out;
  input in;

  assign out = in;
endmodule

module __INV (out, in);
  output out;
  input in;

  not #(`gate_delay, `gate_delay) I0 (out, in);
endmodule

module __LATCH (enable, in, out);
  input enable, in;
  output out;
	
  __UDP_LATCH #(`gate_delay, `gate_delay) U0 (out, enable, in);
endmodule

module __MUX2 (out, in0, in1, sel);
  input in0, in1, sel;
  output out;
	
	__UDP_MUX2 #(`gate_delay, `gate_delay) U0 (out, in0, in1, sel);
endmodule

module __NMUX2 (out, in0, in1, sel);
  input in0, in1, sel;
  output out;

	__UDP_NMUX2 #(`gate_delay, `gate_delay) U0 (out, in0, in1, sel);
endmodule

module __DEMUX2 (in, out0, out1, sel);
  input in, sel;
  output out0, out1;
	__UDP_demux2_top_half #(`gate_delay, `gate_delay) U0 (out0, in, sel);
	__UDP_demux2_bottom_half #(`gate_delay, `gate_delay) U1 (out1, in, sel);
endmodule

module __NKEEP (nout, in);
  input in;
  output nout;

	__UDP_NKEEP #(`gate_delay, `gate_delay) G1 (nout, in);
endmodule

module __TRIBUF (enable, in, out);
  input enable, in;
  output out;

	bufif1 #(`gate_delay, `gate_delay) G1 (out, in, enable);
endmodule

module __TRIINV (enable, in, out);
  input enable, in;
  output out;

  notif1 #(`gate_delay, `gate_delay) G1 (out, in, enable); 
endmodule

module __C2 (out, in0, in1);
  output out;
  input in0, in1;

  __UDP_C2 #(`gate_delay, `gate_delay) U0 (out, in0, in1);
endmodule

module __C3 (out, in0, in1, in2);
  output out;
  input in0, in1, in2;

	__UDP_C3 #(`gate_delay, `gate_delay) U0 (out, in0, in1, in2);
endmodule

module __NC2P (out, ins, inp);
  input ins, inp;
  output out;
	__UDP_NC2P  #(`gate_delay, `gate_delay) U0 (out, ins, inp);
endmodule

module __C2N (out, ins, inn);
  input ins, inn;
  output out;
	__UDP_C2N  #(`gate_delay, `gate_delay) U0 (out, ins, inn);
endmodule

module __VDD (one);
  output one;
  supply1 vdd;

  assign one = vdd;
endmodule

module __GND (zero);
  output zero;
  supply0 gnd;

  assign zero = gnd;
endmodule

primitive __UDP_NKEEP(nout, in);

   output nout;
   input in;
   reg nout;

   initial nout = 1'b1; 
	 
   table
   //	in	:  out' :  out
		
		0	:	?	:	1 ;
    	x	:	1	:	1 ;
		1	:	?	:	0 ;
		x	:	0	:	0 ;
		x	:	x	:	x ;

   endtable

endprimitive

primitive __UDP_demux2_top_half(out, in, sel);

   output out;
   input in, sel;
   
   table
   // 	in  s   :	o0
	
		0	0	:	0 ;
		1	0	:	1 ;
		?	1	:	0 ;

   endtable

endprimitive

primitive __UDP_demux2_bottom_half(out, in, sel);

   output out;
   input in, sel;
   
   table
   //	in	s	:	o0

		0	1	:	0 ;
		1	1	:	1 ;
		?	0	:	0 ;

   endtable

endprimitive
primitive __UDP_MUX2(out, i0, i1, sel);

   output out;
   input i0, i1, sel;
   
   table
   //			s		o
   // 	i	i   e		u
   // 	0	1   l		t
	
		0	?	0	:	0 ;
		1	?	0	:	1 ;
		?	0	1	:	0 ;
		?	1	1	:	1 ;
		0	0	?	:	0 ;
		1	1	?	:	1 ;

   endtable

endprimitive

primitive __UDP_NMUX2(out, i0, i1, sel);

   output out;
   input i0, i1, sel;
   
   table
   // 			s   o
   //	i	i	e   u
   // 	0   1	l   t
	
		0	?	0	:	1 ;
		1	?	0	:	0 ;
		?	0	1	:	1 ;
		?	1	1	:	0 ;
		0	0	?	:	1 ;
		1	1	?	:	0 ;

   endtable

endprimitive

primitive __UDP_C2(out, in0, in1);

   output out;
   input in0, in1;
   reg out;
   table
   //  in0  in1 : out'  :	out

		0	0	:	?	:	0 ;
		0	?	:	0	:	0 ;
		?	0	:	0	:	0 ;
		?	1	:	1	:	1 ;
		1	?	:	1	:	1 ;
		1	1	:	?	:	1 ;
		x	x	:	x	:	x ;

   endtable

endprimitive



primitive __UDP_C3(out, in0, in1, in2);

   output out;
   input in0, in1, in2;
   reg out;
   table
	//	in0	in1	in2	:  out' :  out

		0	0	0	:	?	:	0 ;
		0	?	?	:	0	:	0 ;
		?	0	?	:	0	:	0 ;
		?	?	0	:	0	:	0 ;
		1	?	?	:	1	:	1 ;
		?	1	?	:	1	:	1 ;
		?	?	1	:	1	:	1 ;
		1	1	1	:	?	:	1 ;
		x	x	x	:	x	:	x ;

   endtable

endprimitive

primitive __UDP_NC2P(s, ins, inp);

   output s;
   input ins, inp;
   reg s;
   table
	// ins inp	: s_old	:	s

		0	x	:	x	:	1 ;
		0	?	:	?	:	1 ;
		1	0	:	1	:	1 ;
		1	?	:	0	:	0 ;
		1	1	:	?	:	0 ;
		x	x	:	x	:	x ;

   endtable

endprimitive


primitive __UDP_C2N(out, ins, inn);

   output out;
   input ins, inn;
   reg out;
   table
   //  ins  inn : out'  :	out

		0	0	:	?	:	0 ;
		0	?	:	0	:	0 ;
		?	1	:	1	:	1 ;
		1	?	:	?	:	1 ;
		x	x	:	x	:	x ;

   endtable

endprimitive


primitive __UDP_mutex_top_half(G, R1, R2, G2state);

   output G;
   input R1, R2, G2state;
   //reg G;
   
   table
   //  R1   R2   G2state   G

       0     ?     ?   :   0;
       1     ?     1   :   0;
       1     ?     0   :   1;
       1     ?     x   :   1;
       x     x     x   :   x;

   endtable

endprimitive

primitive __UDP_mutex_bottom_half(G, R1, R2, G2state);

   output G;
   input R1, R2, G2state;
   reg G;
   
   table
   //  R1   R2   G2state  Gold  G

       0     ?     ?      : ? :   0;
       1     ?     1      : ? :   0;
       1     0     0      : ? :   1;
       1     x     0      : ? :   1;
       1     ?     x      : ? :   1;
       1     1     0      : 0 :   0;
       1     1     0      : 1 :   1;
       x     x     x      : ? :   x;

   endtable

endprimitive

primitive __UDP_LATCH(out, en, in);
		
		output	out;
		input	en, in;
		reg		out;
		
		initial out = 1'b0;
		
		table
	//	en	in	:  out'	:  out
		1	1	:	?	:	1 ;
		1	0	:	?	:	0 ;
		0	?	:	?	:	- ;	
		x	0	:	?	:	- ;
		x	1	:	?	:	- ;
				
	endtable

endprimitive 

