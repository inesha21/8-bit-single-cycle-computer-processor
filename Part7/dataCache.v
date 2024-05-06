`include "comparator.v"
`include "mux4to1.v"
`include "dcacheFSM_skeleton.v"

`timescale  1ns/100ps


module data_cache (
  input clock,
  input reset,
  input read,
  input write,
  input [7:0] address,
  input [7:0] writedata,
  output [7:0] readdata,
  output busywait,
  output mem_Read,
  output mem_Write,
  output [5:0] mem_Address,
  output [31:0] mem_Writedata,
  input [31:0] mem_Readdata,
  input mem_BusyWait
);

  // declare cache memory array 32x8-bits and other arrays
  reg [31:0] cache [7:0];
  reg [2:0] cacheTag [0:7];
  reg cacheDirty [0:7];
  reg cacheValid [0:7];

  reg [1:0] Offset;
  reg [2:0] Index;
  reg [2:0] Tag;

  /* Separate address to tag index and offset */
  always @(address) begin
    if (read || write) begin
      #1
      Offset = address[1:0];
      Index = address[4:2];
      Tag = address[7:5];    
    end
  end

  // check whether there is a hit
  wire comparatorOut;
  wire hit, dirty;
  wire [2:0] comparatorTagIN;
  assign comparatorTagIN = cacheTag[Index];
  comparator comparator_inst(Tag, comparatorTagIN, comparatorOut);
  assign hit = cacheValid[Index] && comparatorOut;
  assign dirty = cacheDirty[Index];

  // Extract data from data block and assign
  wire [7:0] dataExtractMuxOut;
  wire [31:0] data;
  assign data = cache[Index];
  mux4to1 mux4to1_inst(data[7:0], data[15:8], data[23:16], data[31:24], Offset, dataExtractMuxOut);
  assign #1 readdata = dataExtractMuxOut;

  // Detecting an incoming cache memory access
  reg Busywait;
  reg READACCESS, WRITEACCESS;
  always @(read, write) begin
    Busywait = (read || write) ? 1 : 0;
    READACCESS = (read && !write) ? 1 : 0;
    WRITEACCESS = (!read && write) ? 1 : 0;
  end

  // Reading & writing cache memory
  always @(posedge clock) begin
    if (READACCESS & hit) begin
      Busywait = 0;
      READACCESS = 0;
    end
    if (WRITEACCESS & hit) begin
      Busywait = 0;
      WRITEACCESS = 0;
      
      // Set dirty bit to 1 as cache and memory inconsistent
      #1 cacheDirty[Index] = 1'b1;            
      
      // Write data to the correct block in cache
      case (Offset)                         
        2'b11: cache[Index][31:24] = writedata;
        2'b10: cache[Index][23:16] = writedata;
        2'b01: cache[Index][15:8] = writedata;
        2'b00: cache[Index][7:0] = writedata;
      endcase 
    end
  end

  /* Set 32-bit data block provided by data memory
     to the correct place in cache */
  always @(mem_BusyWait) begin
    if (!mem_BusyWait) begin
      #1
      cache[Index] = mem_Readdata;
      cacheValid[Index] = 1'b1;
      cacheDirty[Index] = 1'b0;
      cacheTag[Index] = Tag;
    end
  end

  /* When there is a miss occurred and
     the block is dirty (to complete WRITE_BACK state) */
  reg [2:0] Tag1;
  reg [31:0] writedata1;  
  always @(hit) begin
    if (!hit && dirty) begin
      writedata1 = cache[Index];
      Tag1 = cacheTag[Index];
    end
  end

  // Cache controller to handle data memory control signals
  wire controllerBusywait;                                  
  dcache dcache_inst(clock, reset, read, write, address, writedata1, controllerBusywait, mem_BusyWait, Tag, Tag1, Index, hit, dirty, mem_Read, mem_Write, mem_Writedata, mem_Address);

  /* Overall busywait is set to zero whenever cache controller busywait 
     and cache memory busywait both are set to zero */
  assign busywait = (Busywait || controllerBusywait) ? 1 : 0; 
  
  // Reset cache memory
  integer i;
  always @(posedge reset) begin
    if (reset) begin
      for (i = 0; i < 8; i = i + 1) begin
        cache[i] = 0;
        cacheTag[i] = 0;
        cacheDirty[i] = 0;
        cacheValid[i] = 0;
      end
      Busywait = 0;
      READACCESS = 0;
      WRITEACCESS = 0;
    end
  end
endmodule

