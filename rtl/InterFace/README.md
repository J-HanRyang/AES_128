# CP InterFace
This directory contains modules for the standard bus interface, which connects the AES core to an external system (e.g., a processor within an SoC). <br>

## **Cp_ApbIfBlk :**
The main interface block that implements the ARM AMBA APB (Advanced Peripheral Bus) slave protocol.

## **Other Cp_\* modules**
Handle control logic and data conversion required for bus communication, such as reading from and writing to registers (RdDtConv, WrDtConv) via the APB.
