# Doubled_Ones_Counter_SD2

This repository contains a solution to the **Doubled Ones Counter** problem proposed during a recitation session for the **Digital Systems Design II** course at the University of São Paulo.

The complete problem statement and explanations for the proposed solution are provided.

## Problem statement

In the problem, a base project is provided implementing a top-entity called *onescounter*. This  entity computes the Hamming Weight of a bit vector, that is the number of indexes $i$ in the bit vector satisfying $v(i) = 1$.

The goal of the problem is to implement a second functionality, activated by a mode bit, that counts pairs $(i, i+1)$ in the bit vector satisfying $v(i) = v(i+1) = 1$.

## Pseudocode

In the problem, a hardware implementation is provided for the pseudocode below.

```
while (1){
    while ( Start == 0);
    Done = 0;
    Data = Input;
    Ocount = 0;
    Mask = 1;
    Reg_modo = modo;

    while ( Data > 0){
        Mask = (not Reg_modo) || Data(1);
        Ocount += Data(0) & Mask;
        Data >>= 1;
    }
    Output = Ocount;
    Done = 1;
}
```