.data
str_a:		.asciiz "input a: "
str_b:		.asciiz "input b: "
str_c:		.asciiz "input c: "
result:		.asciiz "result = "
newline: 	.asciiz "\n"
.text

# main
_Main:
	# int a, b, c, d = 0, 0, 0, 0;
	addi $s0, $zero, 0
	addi $s1, $zero, 0
	addi $s2, $zero, 0
	addi $s3, $zero, 0
	
	la $a0, str_a	# print input a
	li $v0, 4
	syscall
	li $v0, 5	# scanf
	syscall
	move $s0, $v0	# store a in $s0
	
	la $a0, str_b	# print input b
	li $v0, 4
	syscall
	li $v0, 5	# scanf
	syscall
	move $s1, $v0	# store b in $s1
	
	la $a0, str_c	# print input c
	li $v0, 4
	syscall
	li $v0, 5	# scanf
	syscall
	move $s2, $v0	# store c in $s2
	
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	jal _Add	# execute add function
	addi $s1, $v1, 0
	
	addi $a0, $s1, 0
	addi $a1, $s2, 0
	jal _Msub	# execute msub function
	
	move $s3, $v0	# store result number in $s3
	
	la $a0, result	# print "result = "
	li $v0, 4
	syscall
	
	li $v0, 1	# print result number
	move $a0, $s3
	syscall
	j _Exit		# jump to Exit

# msub (args: $a0, $a1)
_Msub:
	slt $t0, $a1, $a0
	beq $t0, 1, XLarger
	# $t1 is int large, $t2 is int small
	# $t2 = x < $t1 = y
	addi $t1, $a1, 0
	addi $t2, $a0, 0
	j WhileLoop
	
	XLarger:
		# $t1 = x > $t2 = y
		addi $t1, $a0, 0
		addi $t2, $a1, 0
	WhileLoop:
		slt $t0, $t1, $t2
		beq $t0, 1, ExitLoop
		Loop:
			sub $t1, $t1, $t2
			j WhileLoop
	ExitLoop:
	addi $v0, $t1, 0
	jr $ra
	
# add
_Add:
	move $a0, $s0
	move $a1, $s1
	add $t0, $a0, $a1	# x+y
	add $v1, $0, $t0	# save result of x+y
	jr $ra			# return

# terminated	
_Exit:
	li   $v0, 10
  	syscall
	
