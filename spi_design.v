`timescale 1ns/1ps

module spi(
input wire clk,   // System clock
input wire rst,   // Reset signal
input wire enable, // Enable the master to start operation
input wire [31:0] data_out,  // Data to be sent
input wire [7:0] commands,  // Commands to be sent
input wire [23:0] address,   // Address to be sent
// output reg CS,    // Chip select (Active Low)
output reg SCLK,    // Serial Clock
output reg MOSI,   // Master Out Slave In
input wire MISO    // data received from the slave (MISO)
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter TRANSFER = 2'b10;
parameter STOP = 2'b11;
// parameter CS_ON = 1'b0;
// parameter CS_OFF = 1'b1;

reg [1:0] current_state, next_state;
reg [31:0] shift_reg = 0;
reg [5:0] shift_count = 0; // Adjusted for correct counting
reg [5:0] bit_index = 0; // Changed to a bit_index instead of integers
reg clk_div = 1'b0; // Clock divider for SCLK

always @(posedge clk or posedge rst) begin
if (rst) begin
current_state <= IDLE;
SCLK <= 1'b1;
// CS <= CS_OFF;
end

else begin
current_state <= next_state;
// Toggle SCLK ev ery 2 clock cycles
clk_div <= clk_div;
end
end

always @(posedge clk) begin
case (current_state)
IDLE: begin
// CS <= CS_OFF;
if (enable) begin
shift_reg <= {address, commands}; // Prepare the shift register
next_state <= START;
shift_count <= 0;
bit_index <=0;
end

else begin
next_state <= IDLE;
end
end

START: begin
// CS <= CS_ON; // Activate chip select
next_state <= TRANSFER;
end

TRANSFER: begin
if (SCLK) begin
shift_reg <= data_out;
MOSI <= shift_reg[31 - bit_index]; // Send MSB first
bit_index = bit_index + 1;
if (bit_index == 32)
begin
MOSI <= 32'b0;
next_state <= STOP; // Move to STOP state after 32 bits transmitted
end

else begin
next_state <= TRANSFER;
end
end
end

STOP: begin
// CS <= CS_OFF; // Deactivate chip select
next_state <= IDLE; // Go to IDLE state
end

default: begin
next_state <= IDLE; // safety default
end 
endcase
end 
endmodule






