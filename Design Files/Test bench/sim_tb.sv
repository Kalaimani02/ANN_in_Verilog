`timescale 1ns / 1ps

`include "include.v"

`define MaxTestSamples 30

module sim_tb(

    );
    
    reg reset;
    reg clock;
    reg [`dataWidth-1:0] in;
    reg in_valid;
    reg [`dataWidth-1:0] in_mem [784:0];
    reg [23:0] [7:0] fileName;
    wire intr;
    reg [31:0] RdData;
    wire [31:0] rdata;
    reg [`dataWidth-1:0] expected;

    wire [31:0] numNeurons[31:1];
    wire [31:0] numWeights[31:1];
    
    assign numNeurons[1] = 30;
    assign numNeurons[2] = 30;
    assign numNeurons[3] = 10;
    assign numNeurons[4] = 10;
    
    assign numWeights[1] = 784;
    assign numWeights[2] = 30;
    assign numWeights[3] = 30;
    assign numWeights[4] = 10;
    
    integer right=0;
    integer wrong=0;
    
    NNConnect dut(
    .aclk(clock),
    .aresetn(reset), 
    .in_data(in),
    .in_data_valid(in_valid),
	.rdata(rdata), 
    .intr(intr)
    );
	 
	 
	initial
    begin
        clock = 1'b0;
    end
	 
	 always
        #3 clock = ~clock;
		  
	 function [7:0] to_ascii;
      input integer a;
      begin
        to_ascii = a+48;
      end
    endfunction
    
    task readOutput();        
    begin

		assign RdData = rdata;

    end
    endtask
  
    
    task sendData();
    integer t;
    begin
        $readmemb(fileName, in_mem);
        @(posedge clock);
        for (t=0; t <784; t=t+1) begin
            @(posedge clock);
            in <= in_mem[t];
            in_valid <= 1;
        end 
        @(posedge clock);
        in_valid <= 0;
        expected = in_mem[t];
    end
    endtask
   
    integer i;
    integer start;
    integer testDataCount;
    integer testDataCount_int;
    initial
    begin
        reset = 0;
        in_valid = 0;
        #100;
        reset = 1;
        #100

        start = $time;

        $display("Configuration completed",,,,$time-start,,"ns");
        start = $time;
        for(testDataCount=0;testDataCount<`MaxTestSamples;testDataCount=testDataCount+1)
        begin
            testDataCount_int = testDataCount;
            fileName[0] = "t";
            fileName[1] = "x";
            fileName[2] = "t";
            fileName[3] = ".";
            fileName[4] = "0";
            fileName[5] = "0";
            fileName[6] = "0";
            fileName[7] = "0";
            i=0;
            while(testDataCount_int != 0)
            begin
                fileName[i+4] = to_ascii(testDataCount_int%10);
                testDataCount_int = testDataCount_int/10;
                i=i+1;
            end 
            fileName[8] = "_";
            fileName[9] = "a";
            fileName[10] = "t";
            fileName[11] = "a";
            fileName[12] = "d";
            fileName[13] = "_";
            fileName[14] = "t";
            fileName[15] = "s";
            fileName[16] = "e";
            fileName[17] = "t";
            sendData();
            @(posedge intr);
            readOutput();
            if(RdData==expected)
                right = right+1;
            $display("%0d. Accuracy: %f, Detected number: %0x, Expected: %x",testDataCount+1,right*100.0/(testDataCount+1),RdData,expected);
        end
        $display("Accuracy: %f",right*100.0/testDataCount);
        $stop;
    end
endmodule