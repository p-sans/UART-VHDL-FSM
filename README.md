# UART FSM Design and Verification

## Project Overview
This project is a hardware-verified implementation of a UART communication block. It uses an FSM (Finite State Machine) approach to ensure timing accuracy between asynchronous devices.

## Features
* **Custom Baud Rate Generator:** Easily adaptable for different clock frequencies.
* **16x Oversampling:** The receiver ensures high data integrity by sampling at the midpoint of each bit.
* **Full Simulation:** Testbench results included for loopback verification.

## Simulation Result
The waveform below shows the successful transmission and reception of a test byte.

<img src="uart_successful_ss.jpg" width="850">
