#hanoi.asm
#Towers of Hanoi solution using MIPS assembler
#author: Jaime Camacho

.data			#data in memory

.text			#programm code
main:
	addi	$s0, $zero, 3			#set number of discs
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
	### Manejo del stack PUSH ###
	addi	$sp, $sp, -4			#decrement sp to store a word in stack
	sw		$ra, ($sp)				#save return direction in stack
	
	### if(a0 == 1) ###
	addi	$at, $zero, 1			#save comparison value
	beq		$a0, $at, moveDisc		#a0 == 1 ? jump:continue
	### else ###
	#define the new arguments before making recursive call
	addi	$a0, $a0, -1			#decrement number of discs
	add 	$at, $zero, $a2			#save to temp a2
	add		$a2, $zero, $a3			#save to a2 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi
	jal		moveDisc				#call moveDisc routine
	addi	$a0, $a0, -1			#decrement number of discs
	add 	$at, $zero, $a0			#save to temp a0
	add		$a0, $zero, $a3			#save to a0 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi
	j		hanoi_return			#return routine hanoi

moveDisc:
	add		$s6, $zero, $a0			#save a0 (source) as argument
	jal		decodeTower				#call decodeTower routine
	add		$s7, $s1, $v0			#get source tower direction
	add		$s6, $zero, $a1			#save a1 (target) as argument
	jal		decodeTower				#call decodeTower routine
	add 	$s6, $zero, $s1			#get base towers direction
	add		$s6, $s6, $v0			#get target tower direction
	add		$s6, $s6, $s5			#point to base tower direction

forMovDiscS:
	lw		$t0, ($s7)				#get first number of source tower
	beq		$t0, $zero, repeatFor	#t0 == 0 ? jump:continue
	add		$at, $zero, $t0			#get top number from source tower
	sw		$zero, ($s7)			#make top number from source tower zero
	#j		repeatFor				#repeat for cycle

forMovDiscT:
	lw		$t1, ($s6)				#get first number of  base target tower
	bne		$t1, $zero, repeatFor	#t1 != 0 jump:continue
	sw		$at, ($s6)				#save temp value in the new tower
	jr		$ra						#return

repeatFor:
	addi	$s6, $s6, -0x20			#point to next value
	addi 	$s7, $s7, 0x20			#point to next value
	j		forMovDiscS				#repeat for cycle

decodeTower:
	addi	$at, $zero, 1			#save comparison value
	beq		$s6, $at, return		#s6 == 1 ? jump:continue
	addi	$at, $zero, 1			#set temp to 1
	sllv	$v0, $at, $s6			#shift to get tower offset
	jr		$ra						#return
	
hanoi_return:
	### Manejo del stack POP ###
	lw 		$ra, ($sp)				#recover return value from stack
	addi	$sp, $sp, 4				#return sp to original position
	
return:
	jr		$ra						#return
	
exit:
