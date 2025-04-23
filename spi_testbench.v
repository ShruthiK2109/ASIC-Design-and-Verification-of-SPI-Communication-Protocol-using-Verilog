`timescale 1ns/1ps

module SPI_tb;

// inputs
reg clk;   // System clock
reg rst;   // Reset signal
reg enable;  // enable the master to start operation

reg [31:0] data_out;   // Data to be sent
reg [7:0] commands;  // Data to be sent
reg [23:0] Address;   // Data to be sent

// outputs

wire SCLK;  // Serial Clock
wire MOSI;  // Master Out Slave In
wire MISO;  // Data received from the slave (miso)

// internal registers
// wire [1:0] current_state, next_state;
// reg[1:0] clk_count;
// reg[31:0] shift_reg;
// reg [4:0] shift_count;

spi uut (
.clk (clk),
.rst (rst),
.enable (enable),
.data_out (data_out),
.commands (commands),
.address (Address),
.SCLK (SCLK),
.MOSI (MOSI),
.MISO (MISO)

//.current_state(current_state),
//.next_state(next_state),
//.clk_count(clk_count),
//.shift_reg(shift_reg),
//.shift_count(shift_count)
);

initial
begin
clk = 1'b1;
enable = 1'b0;
rst = 1'b1;
end

always #1 clk =~clk;

initial 
begin
commands = 8'b0;
Address = 24'b0;
data_out = 32'b0;

#20
rst = 1'b0;
enable = 1'b1;
commands = 8'b1101001;
Address = 24'b001010101010101010101100;
data_out = 32'b10001011100101010111101101100101;

#1000;
Address = 24'b001010101010101010101100;
data_out = 32'hAAAAAAAA;
enable = 1'b1;

#3000;
$finish;
end
endmodule
