######################################################
# #
# Name: Robert Cimarelli Assignment5 #
# Description: Calculates the sum, mean, min, max #
# and variance of a series of numbers. #
# Date: October 5, 2018  #
# Author: Robert Cimarelli  #
######################################################

	.data
MSG1:	.asciiz	"Enter integer values, one per line, terminated by a negative value.\n"
MSG2:	.asciiz	"The Sum is: \n"  	
	.align	2
MIN:	.asciiz	"The Min is: \n"
	.align	2
MAX:	.asciiz	"The Max is: \n"
	.align	2
VAR:	.asciiz	"The Variance is: \n"
	.align 	2	
average: .asciiz "The Average is: \n"
	.align 	2
ARRAY:	.space	400
	.align	2

	.text
	.globl main

main:
	la	$s3,ARRAY	#Put array address in $s3
	move	$t1,$s3
	li	$s1,0 	#$s1 will be the counter
	li	$s6,0 	#sum of entries
	lui	$s5,0x7fff	#load min with high number
#	ori	$s5,$s5,0xffff
	li	$s4,0 #t0 max
	li	$v0,4
	la	$a0,MSG1
	syscall
TOP:
	li	$v0,5 #read in 
	syscall
	move	$s0,$v0 #number that is read in
	blt	$s0,$zero,DONE	#branch less than, checks neg to end loop

	add	$s6,$s6,$s0	#sum
	sw	$s0,0($s3)	#store word $before was $s0,0($s3)
	addiu	$s3,$s3,4	#get next storage location, add 4 to address
	addiu	$s1,$s1,1	#Add one to counter

	blt	$s0,$s5,LESS
	bgt	$s0,$s5,GREATER

	j	TOP #loop
#checking number before process it
LESS:
	move	$s5,$s0
	j	TOP

GREATER:	
	move	$s4,$s0
	j	TOP

DONE:
	
	li	$v0,4
	la	$a0,MSG2
	syscall

	li      $v0,1 #tell it to print an integer #entry+entry?
        move    $a0,$s6
        syscall
	
	li	$v0,4
	la	$a0,MIN
	syscall 

	li	$v0,1
	move	$a0,$s5
	syscall

	li	$v0,4
	la	$a0,MAX
	syscall

	li	$v0,1
	move	$a0,$s4
	syscall

	li	$v0,4
	la	$a0,average
	syscall	

	mtc1	$s6,$f1
	cvt.s.w	$f1,$f1
	mtc1 	$s1,$f2 #move to FP registers (no conversion)
	cvt.s.w	$f2,$f2 #convert from int to single prec

	li	$v0,2
	div.s	$f0,$f1,$f2
	syscall

        
	li      $v0,4
        la      $a0,VAR #variance message
        syscall
	

	li	$t8,0	
	mtc1     $zero,$f4 

VARIANCE:
	lw	$a0,0($t1)
	mtc1    $a0,$f5
        cvt.s.w $f5,$f5
	sub.s   $f6,$f5,$f12 #subtract mean from dat
 	mul.s 	$f3,$f6,$f6 #square
	add.s   $f4,$f4,$f3 #sum of floats
	addiu	$t1,$t1,4	#get next
   	addiu	$s1,$s1,-1	#subtract one from ctr
	addiu	$t8,$t8,1 #counter for new entries
	bne	$s1,$zero,VARIANCE


	li	$t2,1
	sub	$t8,$t8,$t2		


	mtc1	$t8,$f20 #Move ctr to fp
	cvt.s.w	$f2,$f20	#CONVERT
	mov.s	$f20,$f20

	
#	mov.s	$f9,$f9 #works for n-1
		
	li	$v0,2
	div.s	$f30,$f4,$f20	#divide sum by  n-1
	syscall
	
	

	jr	$ra
