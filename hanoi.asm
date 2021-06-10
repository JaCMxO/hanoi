#hanoi.asm
#Towers of Hanoi solution using MIPS assembler
#author: Jaime Camacho

.data			#data in memory

.text			#programm code
main:
	addi	$s0, $zero, 8			#set number of discs
	lui		$s1, 0x1001				#load start direction of tower A
	addi 	$s2, $s1, 4				#load start direction of tower B
	addi 	$s3, $s1, 8				#load start direction of tower C
	add		$a0, $zero, $s0			#pass disc number as argument
	add 	$a1, $zero, $s1			#pass start direction of tower A pointer
	jal 	initHanoi				#call initHanoi routine
	addi	$a1, $a1, -0x20			#get base tower direction
	add		$s5, $zero, $a1			#save  base tower direction
	andi	$s5, $s5, 0xffff		#keep lower part of base tower direction
	add		$a0, $zero, $s0			#pass disc number as argument
	addi	$a1, $zero, 1			#pass source number as argument
	addi	$a2, $zero, 3			#pass target number as argument
	addi	$a3, $zero, 2			#pass auxiliary number as argument
	jal		hanoi					#call hanoi routine
	j		exit					#end of programm

initHanoi:
	add		$t0, $zero, $zero		#init control variable
	addi	$a0, $a0, -1			#decrement number of discs for comparison

initCycle:
	sub 	$t1, $a0, $t0			#make cycle comparison
	srl 	$t1, $t1, 31			#check sign bit
	bne 	$t1, $zero, return		#t1 != 0 ? jump:continue
	addi	$t0, $t0, 1				#increment control variable
	sw		$t0, ($a1)				#store control variable in tower A
	addi	$a1, $a1, 0x20			#point to next store location
	j		initCycle				#repeat cycle

hanoi:
	### PUSH stack ###
	addi	$sp, $sp, -20			#decrement sp to store a word in stack
	sw		$ra, 0($sp)				#save return direction in stack
	sw		$a0, 4($sp)				#save a0 in stack
	sw		$a1, 8($sp)				#save a1 in stack
	sw		$a2, 12($sp)			#save a2 in stack	
	sw		$a3, 16($sp)			#save a3 in stack	
	
	### if(a0 == 1) ###
	addi	$at, $zero, 1			#save comparison value
	bne		$a0, $at, continue		#a0 != 1 ? jump:continue
	jal 	moveDisc				#call moveDisc routine
	j		hanoi_return			#return
	
continue:
	### else ###
	#define the new arguments before making recursive call
	addi	$a0, $a0, -1			#decrement number of discs
	add 	$at, $zero, $a2			#save to temp a2
	add		$a2, $zero, $a3			#save to a2 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi
	
	add 	$at, $zero, $a2			#save to temp a2
	add		$a2, $zero, $a3			#save to a2 a3
	add		$a3, $zero, $at			#save to a3 temp 
	
	jal		moveDisc				#call moveDisc routine
	add 	$at, $zero, $a1			#save to temp a1
	add		$a1, $zero, $a3			#save to a1 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi
	
	add 	$at, $zero, $a1			#save to temp a1
	add		$a1, $zero, $a3			#save to a1 a3
	add		$a3, $zero, $at			#save to a3 temp 
	
	j		hanoi_return			#return routine hanoi

moveDisc:
	addi	$sp, $sp, -4			#move sp
	sw		$ra, ($sp)				#save ra to call another function
	
	add		$s6, $zero, $a1			#save a1 (source) as argument
	jal		decodeTower				#call decodeTower routine
	add		$s7, $s1, $v0			#get source tower direction
	add		$s6, $zero, $a2			#save a2 (target) as argument
	jal		decodeTower				#call decodeTower routine
	add		$s6, $s1, $v0			#get target tower direction
	add		$s6, $s6, $s5			#point to base tower direction

forMovDiscS:
	lw		$t0, ($s7)				#get first number of source tower
	beq		$t0, $zero, repeatForEx	#t0 == 0 ? jump:continue
	add		$at, $zero, $t0			#get top number from source tower
	sw		$zero, ($s7)			#make top number from source tower zero

forMovDiscT:
	lw		$t1, ($s6)				#get first number of  base target tower
	bne		$t1, $zero, repeatForIn	#t1 != 0 jump:continue
	sw		$at, ($s6)				#save temp value in the new tower

	lw		$ra, ($sp)				#recover ra before returning
	addi 	$sp, $sp, 4				#move sp to original position
	jr 		$ra						#return

repeatForIn:
	addi	$s6, $s6, -0x20			#point to next value
	j		forMovDiscT				#repeat for cycle
	
repeatForEx:
	addi 	$s7, $s7, 0x20			#point to next value
	j		forMovDiscS				#repeat for cycle

decodeTower:
case1:
	addi	$at, $zero, 1			#save comparison value
	bne 	$s6, $at, case2			#s6 != 1 ? jump:continue
	add		$v0, $zero, $zero		#set return value
	jr		$ra						#return
	
case2:
	addi	$at, $zero, 2			#save comparison value
	bne 	$s6, $at, case3			#s6 != 1 ? jump:continue
	addi	$v0, $zero, 4			#set return value
	jr		$ra						#return

case3:
	addi	$v0, $zero, 8			#set return value
	jr		$ra						#return

hanoi_return:
	### POP stack ###
	lw 		$ra, 0($sp)				#recover return value from stack
	lw		$a0, 4($sp)				#recover a0 from stack
	lw		$a1, 8($sp)				#recover a0 from stack
	lw		$a2, 12($sp)			#recover a0 from stack
	lw		$a3, 16($sp)			#recover a0 from stack
	addi	$sp, $sp, 20			#return sp to original position
	
return:
	jr		$ra						#return
	
exit:
