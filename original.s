/**
we work with hex not binary
r0-6 is general purpose
r7 is related to system calls(communicate to os)
sp is stack pointer(next available ram space)
lr is a link register(stores location of a function will return to)
pc is program counter and it carries next instruction
cpsr is a register used to store info about our program(can for example hold info to tell if a number is negative rather than positive)
Terms:
	LDR move stack to register: ldr reg,=name(looks in .data)
	enabling cpsr register: add s to function of arithmatic
	enabling carry w addition: adc instead of add or adds
	AND/OR/EXCLUSIVE OR: and|orr|eor r0,r1,r2(see _andor)
	negation: see _negation
	logical shift left(LSL):
		take the binary:
			1010(10 in decimal)
			with lsl you get:
				1010
Communicating with OS:
	move a value to r7 then call interrupt(swi 0) and it will query 
Sources while mov:
	Constant values: #value
	Hex: 0x{VALUE}
	register direct address: register,=name
	register indirect address: register, [register]
	register indirect address with offset: register,[register,#numberForOffset] puts the value from the register plus offset(4 to the next) to the new register
	register indirect address w offset and preincrement: same as above add ! after close bracket
	register indirect address w offset and postincrement: ldr register,[register],#number
r7 values:
	1 - end execution 
	

**/
//first vid
.global _exit
_exit:
	mov r0, #30//move to destination(r7),value
	mov r7,#1
	SWI 0//software interrupt
	
_add:
	mov r0,#5
	mov r1,#7
	//initial values
	add r2,r0,r1 //r2 = r0 + r1
	
_subtract:
	mov r0,#7
	mov r1,#4
	//initial values
	sub r2,r0,r1 //r2 = r0 - r1

_checkNegative:
	mov r0,#3
	mov r1,#4
	subs r2,r0,r1
	
_checkCarry://This is used for too large of numbers(over 32 bit)
	mov r0,0xFFFFFFFF
	mov r1,#3
	adc r2,r0,r1 //r2 = r0, + r1 + carry
	
_multiply:
	mov r0,#5
	mov r1,#7
	//initial values
	mul r2,r0,r1 //r2 = r0 * r1
	
_andor:
	mov r0,#0xff
	mov r1,#22
	and r2,r0,r1//ands sets flags
	orr r2,r0,r1
	eor r2,r0,r1

_negation:
	mov r0,#0xff
	mvn r0,r0//move negative version of r0 to r0
	and r0,r0,#0x000000ff//to return the original bits back to 0s 
	//for better understanding:
	mov r0,#0xAA
	mvn r0,r0
	and r0,r0,#0x000000ff
	//returns FFFFFF55->00000055
	
.global _start//global function	
_start://starting point, this is a label(a function)
	ldr r0,=list //load stack to register
	ldr r1, [r0] //puts r0 value into r1
	ldr r2,[r0,#4] 
.data
//This is the data to be put in stack
list:
	.word 4,5,7,5//word is a 32 bit size
