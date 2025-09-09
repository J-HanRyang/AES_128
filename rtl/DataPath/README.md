# DataPath + Key_Expansion
This directory contains the modules that perform the core round transformations of the AES algorithm. <br>
The **RoundFunc** module enhances reusability by combining the four fundamental transformation stages listed below.

<div align="center">
  <img width="480" height="500" alt="image" src="https://github.com/user-attachments/assets/df1dd507-a35d-4efa-a7ea-5299fcb97f47" />
</div>

<br>

## **SubBytes :**
Performs the non-linear byte substitution using a predefined S-Box.

## **ShiftRows :**
A permutation step that cyclically shifts the bytes in each row of the state according to the AES specification.

## **MixColumns :**
A diffusion operation that mixes the bytes in each column through a matrix multiplication over GF(2^8).

## **AddRoundKey :**
Performs a bitwise XOR operation between the current state data and the corresponding round key.

<br>

## **KeyExpansion :**
akes the initial 128-bit cipher key as input and generates all the round keys required for the 10 rounds of the AES-128 algorithm. <br>
It internally performs operations such as **RotWord**, **SubWord**, and an **Rcon** XOR to calculate the subsequent round keys.
