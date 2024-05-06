loadi 5 0x05   // r5 = 5
loadi 6 0x09   // r6 = 9
mult 4 6 5     // (multiply value in register 1 by value in register 2, and place the result in register 4)
bne 5 6 0x02   // (if values in registers 5 and 6 are not equal, branch 2 instructions forward)
loadi 4 0x04   // r4 = 4
sub 4 4 0x05   // r4 = r4 - 5
srl 4 4 0x02   //(apply logical shift right 2 times on value in register 4, and place the result in register 4)
sll 4 4 0x02     //(apply logical shift left 2 times on value in register 4, and place the result in register 4)

