loadi 0 0x05   // r4 = 5
loadi 1 0x09   // r1 = 9
mov 2 1        // r2 = r1
add 3 2 0      // r3 = r2 + r0
sub 4 3 1      // r4 = r3 + r1
loadi 0 0x75   // r0 = 0x75
loadi 1 0x92   // r1 = 0x92
and 5 1 0      // r5 = r1 & r0
or 6 5 2       // r6 = r5 | r2
j 0xFB		    // jump to line 4