loadi 1 0x05
loadi 2 0x01
loadi 3 0x01
loadi 4 0x05
sub 1 1 2
add 5 1 4
swd 5 4     // store r5  val in memory[r4=0x05]
swi 4 0x03  // store r4 val in memory[0x03] 
lwd 1 4     // load to r1 val in (memory[r4=0x05])=9 
lwi 2 0x03  // load to r2 val in (memory[0x03])=5