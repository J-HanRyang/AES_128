# AES_Top
This directory contains the top-level modules of the AES-128 core.

## **AesCtrl :**
The main FSM controller that governs the entire operation. <br>
It acts as the brain of the system, directing all processes, including key loading, data I/O, and round iteration.

## **AesCore :**
The primary datapath where the actual data processing occurs. <br>
It includes the state registers and the round function (RoundFunc), playing a central role in transforming the 128-bit data in each round.
