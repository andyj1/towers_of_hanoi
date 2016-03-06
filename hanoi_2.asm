#
# School: The Cooper Union
# Course: ECE151A Spring 2016
# Assignment: Towers of Hanoi in MIPS 
# Group members: Andy Jeong, Brenda So, Gordon Macshane
# Date: 3/7/2016
#
# Note:
# 	The number of disks should be >= 3 (integer)
# 	The number of pegs should be >= 3 (integer)
#

.data
title: 	.asciiz "Tower of Hanoi\n"
disk:	.asciiz "Disks: \n"
pole:	.asciiz "Pegs: \n"
finish:	.asciiz "Finished. "
# times:	.asciiz "times."
#errinput:	.asciiz "Invalid inputs"
.text
	.globl main
main:
		# title print out
		la $v0, 4
		la $a0, title
		syscall
		# disk input prompt
		la $v0, 4
		la $a0, disk
		syscall	
		# takes in input: disks
		li $v0, 5
		syscall
		move $t0, $v0
		move $s0, $t0
		# pole input prompt
		la $v0, 4
		la $a0, pole
		syscall
		# takes in input: pole 
		li $v0, 5
		syscall
		move $t1, $v0
		move $s1, $t1
		# conditions for disks and poles inputs
		#sgt $s4, $s0, 3	# disks have to be greater than 3
		#sgt $s4, $s1, 3	# poles have to be greater than 3
		#bne $s5, $zero, error	# if disks or poles are less than 3, exit
#########################################
# input received:   $s0:  # of disks  $s1: # of poles
#########################################
		add $a1, $sp, $zero # $a1 = $sp
		addi $t2, $zero, 4 	# size of each word
		mult $t2, $s0 		
		mflo $t2 			# size of each stack ( = 1 word * number of disks )
		add $a2, $t2, $a1		# spare stack @ $sp + (4)(disks)
		add $a3, $a2, $t2	 	# final stack start address @ $sp + 2* (4)(disks) 
		move $s2, $t2  # size of each stack stored in $s2
		# assign n to a temp register t3
		la $t3, ($s0)
		j load
		lw $ra, 0($sp)
# a1: first stack
# a2: spare stack
# a3: final stack
load:
		la $ra, 0($sp) # $sp : start of the first stack
		subi $sp,$sp,4 	# sp = sp - (1 word)
		sw  $t3, ($sp)
		addi $t3, $t3, -1	# n = n - 1
		bne $t3, $zero, load	# if n =/= 0, loop back to 'load'
		sub $a1, $a1, $s2
		add $s4, $zero, $a1	#t4 is the temporary source
		add $s5, $zero, $a2	#t5 is the temporary spare
		add $s6, $zero, $a3	#t6 is temporary destination
		add $s3, $zero, $a3
		sw $a1, 0($s3)
		j moveTower		#go to movetower
#s4: source
# s5: destination
# s6: spare

moveTower:				#move tower from source peg to destination peg
		sw $ra, 0($s3)
		sw $s4, 4($s3)
		sw $s5, 8($s3)
		sw $s6, 12($s3)
		addi $s3, $s3, 16	#move s3 down by 2 items
		slti $t3, $t0, 2	#test if disks == 0
		beq $t3,$zero,L1 	#if disks are not zero, go to L1
		#I am still working onthe part below
		add $sp, $zero, $s4	#where disk moving is supposed to happen
		
		lw $t7, 0($sp)		#pop first disk from current location
		sw $zero, 0($sp)	#after popping, set popped value to zero
		addi $sp, $sp, 4	#pop 1 item from stack
		add $s4, $zero, $sp	#reset temporary 
		add $sp, $zero, $s6	#go to temporary final destination
		subi $sp, $sp, 4
		sw $s4, -12($s3)	#save newest value of s4
		
		sw $t7, 0($sp)		#save number into temporary final destination
		subi $s6, $s6, 4	#move pointer up
		sw $s6, -4($s3)		#save the newest value of s6
		jr $ra			#go back to L1

		
L1:		
				
		add $t7, $zero, $s5	#save t7 into t5
		add $s5, $zero, $s6	#set temporary spare as temporary destination
		add $s6, $zero, $t7	#set temporary destination as temporary spare
		addi $t0, $t0, -1	#decrease t0
		jal moveTower		#recursion call
		#the following code move disks
		addi $t0, $t0, 1	#move t0 back up
		
		subi $s3, $s3, 12	#pop 3 items up
		lw $s4, 0($s3)
		lw $s5, 8($s3)		#load destination back
		lw $s6, 4($s3)		#load spare back
		subi $s3, $s3, 16
		
		add $sp, $zero, $s4	#where disk moving is supposed to happen
		lw $t7, 0($sp)		#pop first disk from current location
		sw $zero, 0($sp)	#after popping, set popped value to zero
		addi $sp, $sp, 4	#pop 1 item from stack
		add $s4, $zero, $sp	#reset temporary 
		add $sp, $zero, $s6	#go to temporary final destination
		subi $sp, $sp, 4
		sw $s4, -12($s3)
		sw $t7, 0($sp)		#save number into temporary final destination
		subi $s6, $s6, 4	#move pointer up
		
		sw $s4, 0($s3)		#save temp source to memory
		sw $s5, 4($s3)		#save temp spare to memory
		sw $s6, 8($s3)		#save temp destination to memory
		addi $s3, $s3, 12	#move s3 down by 2 items
		#end of following code
		
		add $t7, $zero, $s4
		add $s4, $zero, $s5	#set temporary source as temporary spare
		add $s5, $zero, $t7	#set temporary spare as temporary source
		subi $t0, $t0, 1
		jal moveTower		#go to moveTower2
		addi $t0, $t0, 1	
		#subi $s3, $s3, 8	#pop 2 items up
		#lw $s4, 0($s3)		#load destination back
		#lw $s5, 4($s3)
		#lw $s6, 8($s3)		#load spare back
		add $ra, $zero, $sp 
		la $s7, ($s5)		# address of 3 retrieved from $s5
		lw $t7, 0($s7)  	# t7 =  3
		add $t8, $zero, $s0
		beq $t8, $t7, setZero
			
		#la $t5, ($s5)
		#la $t5, 0($s5)
		#sw $zero, 0($t5)
		#add $t4, $zero,  $t4	
		beq $t0, $s1, exit
		lw $ra, -16($s3)
		
		jr $ra
		
#error:
#		li $v0, 4
#		la $a0, errinput
#		syscall

#		li $v0, 10
#		syscall
setZero:
		
		add $t0, $s1, -1
		mult $t0, $s1
		mflo $t6			
		addi $t4, $zero, 4
		mult $t6, $t4
		mflo $t6
		add $s7, $s7, $t6
		sw $t7, 0($s7)
		sw $zero, 0($s5)	
		
exit:	
		#output finish call
		li $v0, 4
		la $a0, finish
		syscall
	
		# return 1
		#li $v0, 1
		#la $a0, ($v0)
		#syscall
		
		# terminate
		# li $v0, 10
		# syscall

		# testing for the data output
		# addi $sp, $sp,4	
		# li $v0, 4 
		# sw $a0, ($sp)
		# syscall
		
