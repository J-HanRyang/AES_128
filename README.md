# AES_128
AES 128 encryption module

## **⚡ Overview :**
This project is a Verilog implementation of the AES-128 encryption and decryption core. <br>
A key feature of this design is the inclusion of a standard AMBA APB interface, <br>
allowing this core to be easily integrated into a larger System-on-a-Chip (SoC).

## **🛠 Tools :**
Verilog, Xcelium, Linux

## **🏛️ Architecture :**
The architecture is controlled by a central FSM, **AesCtrl**, which manages the overall encryption/decryption process. <br>
The **AesCore** module contains the main datapath, which iteratively performs the AES rounds. <br>
Each round consists of four fundamental transformations: SubBytes, ShiftRows, MixColumns, and AddRoundKey <br>
The entire IP is wrapped with an ApbIfBlk to handle communication with a system bus.

## **📜 Results :**
A functional AES-128 core capable of encrypting and decrypting 128-bit data blocks was successfully implemented and verified through simulation.

<br>

#### *Referenced Document*
[Docs]()
