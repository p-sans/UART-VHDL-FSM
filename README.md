# UART FSM Design and Verification

## Project Overview
This project is a hardware-verified implementation of a UART communication block. It uses an FSM (Finite State Machine) approach to ensure timing accuracy between asynchronous devices.

## Features
* **Custom Baud Rate Generator:** Easily adaptable for different clock frequencies.
* **16x Oversampling:** The receiver ensures high data integrity by sampling at the midpoint of each bit.
* **Full Simulation:** Testbench results included for loopback verification.

## Simulation Result
The waveform below shows the successful transmission and reception of a test byte.


<img width="1920" height="1021" alt="uart_successful_ss" src="https://github.com/user-attachments/assets/81028159-2b87-4bb5-b1fe-46d4a6b145e5" />

