#hanoi.asm
#Towers of Hanoi solution using MIPS assembler
#author: Jaime Camacho

.data			#data in memory

.text			#programm code
main:
	addi	$s0, $zero, 4			#set number of discs
	lui		$s1, 0x1001				#load start direction of tower A
	
	lui		$s7, 0x1001				#tower A pointer
	addi	$s6, $s7, 4				#tower B pointer
	addi	$s5, $s7, 8				#tower C pointer
	
	
	add		$a0, $zero, $s0			#pass disc number as argument
	add		$a1, $zero, $s1			#pass start direction of tower A pointer
	jal		initHanoi				#call initHanoi routine
	#addi	$a1, $a1, -0x20			#get base tower direction
	add		$s4, $zero, $a1			#save  base tower direction
	andi	$s4, $s4, 0xffff		#keep lower part of base tower direction
	
	add		$s6, $s6, $s4			#tower B base pointer
	add		$s5, $s5, $s4			#tower C base pointer
	
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
	sub		$t1, $a0, $t0			#make cycle comparison
	srl		$t1, $t1, 31			#check sign bit
	bne		$t1, $zero, return		#t1 != 0 ? jump:continue
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
	jal		moveDisc				#call moveDisc routine
	j		hanoi_return			#return

continue:
	### else ###
	#define the new arguments before making recursive call
	addi	$a0, $a0, -1			#decrement number of discs

	#swap	a2, a3
	add		$at, $zero, $a2			#save to temp a2
	add		$a2, $zero, $a3			#save to a2 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi

	#swap	a2, a3
	add		$at, $zero, $a2			#save to temp a2
	add		$a2, $zero, $a3			#save to a2 a3
	add		$a3, $zero, $at			#save to a3 temp 

	jal		moveDisc				#call moveDisc routine

	#swap	a1, a3
	add		$at, $zero, $a1			#save to temp a1
	add		$a1, $zero, $a3			#save to a1 a3
	add		$a3, $zero, $at			#save to a3 temp
	jal		hanoi					#make recursive call hanoi

	#swap	a1, a3
	add		$at, $zero, $a1			#save to temp a1
	add		$a1, $zero, $a3			#save to a1 a3
	add		$a3, $zero, $at			#save to a3 temp 

hanoi_return:
	### POP stack ###
	lw		$ra, 0($sp)				#recover return value from stack
	lw		$a0, 4($sp)				#recover a0 from stack
	lw		$a1, 8($sp)				#recover a1 from stack
	lw		$a2, 12($sp)			#recover a2 from stack
	lw		$a3, 16($sp)			#recover a3 from stack
	addi	$sp, $sp, 20			#return sp to original position
	jr		$ra

moveDisc:
#s7 -> tower A pointer
#s6 -> tower B pointer
#s5 -> tower C pointer

# en un principio, el apuntador A está hasta arriba
# en un principio, el apuntador B está hasta abajo en la torre B
# en un principio, el apuntador C está hasta abajo en la torre C

# cada que se usa un apuntador se debe quedar en la posición actual para después poderse moverse


casef1:
	addi	$at, $zero, 1			#save comparison value
	bne		$a1, $at, casef2		#a1 != 1 ? jump:continue
	j		movfA					#call movfA routine

casef2:
	addi	$at, $zero, 2			#save comparison value
	bne		$a1, $at, movfC			#a1 != 1 ? movfC:continue
	j		movfB					#call movfB routine
	
movfA:
	lw		$t0, ($s7)				#get first number of source tower
	sw		$zero, ($s7)			#make top number from source tower zero
	
	addi	$s2, $s4, -0x20			#tower base offset
	add		$s3, $zero, $s7			#pass to s3 the pointer to A
	andi	$s3, $s3, 0xffff		#get low part
	sub		$s3, $s3, $s2			#compare if is base
	beq		$s3, $zero, caset1		#if is base, no need to move pointer
	
	addi	$s7, $s7, 0x20			#point to next number
	j		caset1					#move to tower

movfB:
	lw		$t0, ($s6)				#get first number of source tower
	sw		$zero, ($s6)			#make top number from source tower zero
	addi	$s6, $s6, 0x20			#point to next number
	j		caset1					#move to tower

movfC:
	lw		$t0, ($s5)				#get first number of source tower
	sw		$zero, ($s5)			#make top number from source tower zero
	addi	$s5, $s5, 0x20			#point to next number
	
caset1:
	addi	$at, $zero, 1			#save comparison value
	bne		$a2, $at, caset2		#a1 != 1 ? jump:continue
	j		movtA					#call movtA routine

caset2:
	addi	$at, $zero, 2			#save comparison value
	bne		$a2, $at, movtC			#a1 != 1 ? movtC:continue
	j		movtB					#call movtB routine

movtA:
	addi	$s2, $s4, -0x20			#tower base offset
	add		$s3, $zero, $s7			#pass to s3 the pointer to A
	andi	$s3, $s3, 0xffff		#get low part
	sub		$s3, $s3, $s2			#compare if is base
	beq		$s3, $zero, stoAval		#if is base, no need to move pointer

	addi	$s7, $s7, 0x20			#point to next number
stoAval:
	sw		$t0, ($s7)				#store the value in target tower
	j		return					#return

movtB:
	addi	$s6, $s6, -0x20			#point to next number 
	sw		$t0, ($s6)				#store the value in target tower
	j		return					#return

movtC:
	addi	$s5, $s5, -0x20			#point to next number 
	sw		$t0, ($s5)				#store the value in target tower

return:
	jr		$ra						#return

exit:
