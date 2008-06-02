

// A Verilog example taken from comp.lang.verilog



//-----------------------Cache Coherence Protocol-----------------------------

// This finite-state machine (Melay type) reads bus 

// per cycle and changes the state of each block in cache.



module cache_coherence ( 

	new_state, 

	Cache_Sector_Fill, 

	Invalidate,  

	AdrRetry,

	RMS, 

	RME, 

	WM, 

	WH,  

	SHR, 

	SHW, 

	state, 

	READ_DONE, 

	clk, 

	reset, 

	send_abort, 

	write_back_done,

	AllInvDone);



input RMS, RME, WM, WH, SHR, SHW, READ_DONE, clk, 

      reset, send_abort, write_back_done, AllInvDone;



input [2:0] state;



output [2:0] new_state;

output Cache_Sector_Fill, Invalidate, AdrRetry;



reg Cache_Sector_Fill, Invalidate, AdrRetry ;

reg [2:0] new_state; 



// The four possible states (symbolic names) for a sector 

// in the cache plus 2 mandatory states



parameter /*[2:0]*/ // synopsys enum state_info

	INVALID = 3'b000,

	SHARED_1 = 3'b001,

	EXCLUSIVE = 3'b010,

	MODIFIED = 3'b011,

	Cache_Fill = 3'b100,

	start_write_back = 3'b101,

	/* start_write_back = 5, */

	WaitUntilAllInv = 3'b110;



// Declare current_state and next_state variable.

reg [2:0] 	/* synopsys enum state_info */	present_state;

reg [2:0]	/* synopsys enum state_info */	next_state;

// synopsys state_vector present_state



/* Combinational */

always @(present_state or RMS or RME or WM or WH or SHW or READ_DONE 

         or SHR or write_back_done or AllInvDone or send_abort or state or reset) 

begin

	Cache_Sector_Fill = 0; 	// Default values

	Invalidate = 0; 

	AdrRetry = 0; 

	next_state = present_state; 

	if (reset) next_state = state; else 

	begin

	case(present_state) 	// synopsys full_case

		INVALID: 

			// ReadMiss (shared/exclusive), Write Miss

			if (RMS || RME || WM)  			 

			begin

				Cache_Sector_Fill = 1;

				next_state = Cache_Fill ;

			end

			else 

			begin 

				next_state = INVALID;

			end



		Cache_Fill:	

			/* During This State Cache is filled with the sector,

			   But if any other processor have that copy in modified 

			   state, it sends an abort signal. If no other cache has

			   that copy in modified state. Requesting processor waits

			   for the read from memory to be done.

			*/

			if (send_abort) 

			begin 

				next_state = INVALID;

			end

			else if (READ_DONE) 

			begin

				if (RMS) 

				begin

					next_state = SHARED_1;

				end

				else if (RME) 

				begin 

					next_state = EXCLUSIVE;	

				end

				else if (WM)

				begin

					Invalidate = 1;

					next_state = WaitUntilAllInv;

				end 

				else 

				begin 

					next_state = Cache_Fill ;

				end

			end	

			else 

			begin 

				next_state = Cache_Fill ;

			end

			

		SHARED_1:	  

			if (SHW) // Snoop Hit on a Write.

			begin 

				next_state = INVALID;		

			end

			else if (WH) // Write Hit				

			begin

				Invalidate = 1;

				next_state = WaitUntilAllInv;

			end 

			else 

			begin // Snoop Hit on a Read or Read Hit or any other

				next_state = SHARED_1; 		

			end



		WaitUntilAllInv:

			/* In this state Requesting Processor waits for the 

			   all other processor's to invalidate its cache copy.

			*/



			if (AllInvDone) 

			begin 

				next_state = MODIFIED;

			end

			else 

			begin 

				next_state = WaitUntilAllInv;

			end



		EXCLUSIVE: 

								

			if (SHR) // Snoop Hit on a Read:

			begin

				AdrRetry = 0;

				next_state = SHARED_1;  

			end 					

			else if (SHW) // Snoop Hit on a Write 

			begin

				next_state = INVALID;	

			end

			else if (WH) // Write Hit

			begin

				next_state = MODIFIED;	

			end

			else 

			begin // Read Hit 

				next_state = EXCLUSIVE;		

			end



		MODIFIED:  	

			if (SHW) // Snoop Hit on a Write 

			begin

				next_state = INVALID;		

			end

			else if (SHR) // Snoop Hit on a Read 			

			begin

				AdrRetry = 1;

				next_state = start_write_back;

			end

			else // Read Hit or Write Hit or anything else.

			begin

				next_state = MODIFIED; 		

			end



		start_write_back: 

			/* In this state, Processor waits until other processor 

			   has written back the modified copy.

			*/

			if (write_back_done) 

			begin

				next_state = SHARED_1; 

			end

			else

			begin 

				next_state = start_write_back;

			end

			

	endcase

	end

	

end



/* Sequential */

always @(posedge clk) 

begin

	present_state = next_state;

	new_state = next_state;

end

endmodule





//--------------Test File: Maintaining Cache coherence in 2-processor Systems------

/* Test File for Maintaining Cache Coherence in 2-processor system */



module cache;



reg RMS, RME, WM, WH, RH, SHR, SHW, clk, READ_DONE , reset, send_abort, write_back_done, AllInvDone, PA, PB, countE;

reg [2:0] state, SectorInCacheA, SectorInCacheB;

reg [3:0] count;

integer file1;



parameter CYCLE = 10;



wire [2:0] new_state;

wire Cache_Sector_Fill, Invalidate;



cache_coherence u1 (

	new_state, 

	Cache_Sector_Fill, 

	Invalidate, 

	AdrRetry, 

	RMS, RME, 

	WM, WH, 

	SHR, SHW, 

	state, READ_DONE, clk, reset, send_abort, write_back_done, AllInvDone); 



initial

begin

	$display("Example: maintaining cache coherence in 2-processor system");



	file1 = $fopen("cache.list");

	$fdisplay(file1, "Example: maintaining cache coherence in 2-processor system");



	/* The states of sector in both caches are initialized to Invalid (0). */

	SectorInCacheA = 0; SectorInCacheB = 0;

 

	/* Signals set/rest by cache controller */

	// Write Hit

	WH = 0;



	// ReadMiss (Shared)

	RMS = 0;



	// WriteMiss

	WM  = 0;



	// Snoop hit on read operation

	SHR = 0;



	// Snoop hit on write operation

	SHW = 0;



	// This signal is set/reset,

	// when a cache controller starts or finish reading a sector from memory

	READ_DONE = 0;



	// This signal is set when all other cache controllers 

	// invalidate their copy.

	AllInvDone = 0;



	// This signal is set when cache controller finishes updating memory.

	write_back_done = 0;



	// This signal is set when snoopy cache controller sends 

	// AdrRetry Signal to retry the operation. 

	send_abort = 0;



	// Present State of the Sector is INVALID in PA's local cache.

	// So, it puts the address of this sector on the bus and starts

	// reading this sector from memory.



	state = SectorInCacheA ; PA = 1; PB = 0; RME = 1; 

	reset = 1; #6 reset = 0;



	// After 15 time units Processor B will declare  

	// Snoop Hit on the Read operation done by Processor A.

	#40 PA = 0; PB = 1; RME = 0; RMS = 1; state = SectorInCacheB; 

	reset = 1;#10 reset = 0;



	#50 PB = 0; PA = 1; SHR = 1; state = SectorInCacheA; 

	reset = 1; #10 reset = 0;

	

	#20 SHR = 0; WH = 1; state = SectorInCacheA; 

	reset = 1; #10 reset = 0;



	#50 PA = 0; PB = 1; RMS = 1; WH = 0; state = SectorInCacheB; 

	reset = 1; #10 reset = 0;



	#30 SHR = 1; RMS = 0; PA = 1; PB = 0; state = SectorInCacheA; 

	reset = 1; #10 reset = 0;

	

	#20 PB = 1; PA = 0; SHR = 0; state = SectorInCacheB; 

	reset = 1; #10 reset = 0;



	// PA states writing back.

	#20 PB = 0; PA = 1; state = SectorInCacheA; 

	reset = 1; #10 reset = 0;



	// This signal is broadcast on the bus to tell every body that 

	// Processor B has written back its Modified data back to the Memory 

	// to make everything consistent. After 5 time units it is set back to 

	// Zero. 



	#30 write_back_done = 1;

	#10 write_back_done = 0;



	// PB retry.

	#10 PA = 0; PB = 1; RMS = 1; state = SectorInCacheB; 

	reset = 1; #10 reset = 0;



//	#100 $stop;

//	#100 $finish;

end



always @(new_state)

begin

	if (PA == 1) SectorInCacheA = new_state ;

	else if (PB == 1) SectorInCacheB = new_state ;

end



always @(posedge clk)

begin

	if (Invalidate)

	begin	

		#10 SectorInCacheB = 0;

		#10 AllInvDone = 1;

		#15 AllInvDone = 0;

	end

	else if (Cache_Sector_Fill)

	begin

		count = 0;

		countE = 1;



		// Intialize the Read_Done variable to 0; it 

		// it will be set to 1 by this test file after

		// some delay.

		READ_DONE = 0;

	end

	else if (AdrRetry)

	begin

		countE = 0;

		send_abort = 1;

		#40 send_abort = 0;

	end

end



always @(posedge clk)

begin

	if (READ_DONE == 1) READ_DONE = 0;

	if (countE == 1)

	begin

		if ( count == 2 )

		begin

			READ_DONE = 1;

			countE = 0;

		end

		else count = count + 1;

	end

$display("SHit %b Abort %b RD_DONE %b WB_DONE %b Cache_Sector_Fill %b Inv %b AllInvDone %b stateA %b stateB %b", SHR, send_abort, READ_DONE, write_back_done, Cache_Sector_Fill, Invalidate, AllInvDone, SectorInCacheA, SectorInCacheB);



// Added for v2v testing



$fdisplay(file1, $time,,"SHit %b Abort %b RD_DONE %b WB_DONE %b Cache_Sector_Fill %b Inv %b AllInvDone %b stateA %b stateB %b", SHR, send_abort, READ_DONE, write_back_done, Cache_Sector_Fill, Invalidate, AllInvDone, SectorInCacheA, SectorInCacheB);



end



initial clk = 0;



always #(CYCLE/2) clk = ~clk ;



endmodule 

//---------------------------------THANKS-------------------------------------------

  