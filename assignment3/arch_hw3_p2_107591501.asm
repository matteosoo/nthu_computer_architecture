.data
str_a:		.asciiz  "input a: "
str_b:		.asciiz  "input b: " 

ans:		.asciiz  "ans: "
newline: 	.asciiz "\n"

dbg1:           .asciiz  "large = "
dbg2: 	        .asciiz  "\nsmall = "
dbg3: 	        .asciiz  "\nans = "
.text

# main
_MAIN:
	# int a, b, c, d = 0, 0, 0, 0;
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	addi $t2, $zero, 0
	addi $t3, $zero, 0
	
	la $a0, str_a	# print input a
	li $v0, 4
	syscall
	li $v0, 5	# scanf
	syscall
	move $t0, $v0	# store a in $t0
	
	la $a0, str_b	# print input b
	li $v0, 4
	syscall
	li $v0, 5	# scanf
	syscall
	move $t1, $v0	# store b in $t1
  	
  	# c = recursive(a);
  	add $a0, $zero, $t0
  	jal, _Recursive
  	add $t2, $zero, $v0
	
	# d = function(b, c);
	move $a0, $t1
	move $a1, $t2
	jal, _Function
	add $t3, $zero, $v0
		 	 	 
	# printf("ans: %d", c);
	la $a0, ans      
	li $v0, 4	  
	syscall
	add $a0, $zero, $t2  # $a0 = c 
  	li $v0, 1	    
	syscall	
	
	# printf("ans: %d", d);
	la $a0, ans      
	li $v0, 4	  
	syscall
	add $a0, $zero, $t3  # $a0 =  d
  	li $v0, 1	    
	syscall	           
	jal  _newline    
	
	j _Exit            


_Recursive:
	# ra, a0 , s1 recursive(x-3) , s2 recursive(x-2), s3 recursive(x-1) 5 in total
        addi $sp, $sp, -20
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $s0, 8($sp)
        sw $s1, 12($sp)
        sw $s2, 16($sp)
         
      	# if x >= 0xFF:
      	addi $t0, $zero, 255
      	bge $a0, $t0, if_1
      	# if x >= 0xF:
      	addi $t0, $zero, 15
      	bge $a0, $t0, if_2
	addi $v0, $zero, 1	# return 1
	j, _End_recursive

if_1:     
  	addi $a0, $a0, -3   	# x = x-3
     	jal, _Recursive
     	lw $a0, 4($sp)     	# restore the $a0 (x)
     	move $s1, $v0 		# s1 = recursive(x-3)
      
  	addi $a0, $a0, -2   	# x = x-2
     	jal, _Recursive
     	lw $a0, 4($sp)     	# restore the $a0 (x)
     	move $s2, $v0 		# s1 = recursive(x-2)
      
     	add $v0, $zero, $s1 	# v0 = s1 (recursive(x-3))
     	add $v0, $v0, $s2	# v0 += s2 (recursive(x-2))
     	
if_2:     
  	addi $a0, $a0, -1   	# x = x-1
     	jal, _Recursive
     	lw $a0, 4($sp)     	# restore the $a0 (x)
     	move $s1, $v0 		# s1 = recursive(x-1)
      
     	add $v0, $zero, $s1 	# v0 = s1 (recursive(x-1))
     	addi $v0, $v0, 1	# v0 += 1
	
_End_recursive:  
	lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $s0, 8($sp)
        lw $s1, 12($sp)
        lw $s2, 16($sp)
        addi $sp, $sp, 20
        jr $ra

_Function:
	# ra, a0 ,a1, function(x-1, y), function(x, y-1) 5 in total
        addi $sp, $sp, -20
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sw $a1, 8($sp)
        sw $s0, 12($sp)
        sw $s1, 16($sp)
        
      	bgt $a0, $zero, cond_1 	# if x > 0 then
      	addi $v0, $zero, 1    	# return 1
      	j, _End_function
       
cond_1:  
	bgt $a1, $zero, cond_2  # if y > 0 then
      	addi $v0, $zero, 1     	# return 1
       	j, _End_function
       	
cond_2: 
	addi $a0, $a0, -1   	# x = x-1
      	jal, _Function
      	move $s0, $v0  		# s0 = function(x - 1, y)
      	lw $a0, 4($sp)     	# restore the $a0 (x)
      
      	addi $a1, $a1, -1   	# y = y - 1
      	jal, _Function
     	move $s1, $v0  		# s1 = function(x, y - 1)
      	lw $a1, 8($sp)    	# restore the $a1(y)
      
      	add $v0, $zero, $s0 	# v0 = s0 (function(x-1, y))
      	add $v0, $v0, $s1	# v0 += s1 (function(x, y-1))
      
_End_function:  
	lw $ra, 0($sp)
        lw $a0, 4($sp)
        lw $a1, 8($sp)
        lw $s0, 12($sp)
        lw $s1, 16($sp)
        addi $sp, $sp, 20
        jr $ra


_newline:
	la $a0, newline  	# load address of string to print
	li $v0, 4		# ready to print string
	syscall	        	# print
	jr $ra          	# return


# terminated	
_Exit:
	li $v0, 10
	syscall