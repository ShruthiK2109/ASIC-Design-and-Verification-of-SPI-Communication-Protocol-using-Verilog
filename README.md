# ASIC-Design-and-Verification-of-SPI-Communication-Protocol-using-Verilog

This design implements a basic SPI (Serial Peripheral Interface) master controller, designed to transmit a sequence of 32 bits over the MOSI (Master Out Slave In) line to an SPI-compatible slave device. The design is governed by a finite state machine (FSM) comprising four states: IDLE, START, TRANSFER, and STOP.

In the IDLE state, the module waits for the enable signal to become active. Upon activation, it concatenates the 24-bit address and the 8-bit commands into a 32-bit shift_reg, initializing the system for transmission. The transition to the START state represents the logical assertion of a start condition for SPI communication.

In the TRANSFER state, the core of the SPI protocol is executed. The 32-bit data from the data_out input is loaded into the shift_reg, and bit-wise transmission occurs via the MOSI line, synchronized with the SPI clock signal SCLK. The transmission is MSB-first, controlled by the bit_index, which increments after each bit transfer. Once all 32 bits have been transmitted, the FSM transitions to the STOP state, signaling the end of the communication session, and subsequently returns to the IDLE state.


![spi block diagram](https://github.com/user-attachments/assets/08069f77-d33d-48ec-907c-ccd86b0505ad)


![spi blk diagram](https://github.com/user-attachments/assets/57f50cc0-97f9-4dc0-810b-baab08b3970f)

