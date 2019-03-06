

.global _start


_start:
        MOV R7, #4    @ these five lines print to prompt
        MOV R0, #1
        MOV R2, #22
        LDR R1, =prompt
        SWI 0

read:
        MOV R7, #3           @These 5 lines read 255 characters
        MOV R0, #0           @from the keyboard
        MOV R2, #255
        LDR R1, =string
        SWI 0
        MOV R4, #0   @index for array
        MOV R5, #65  @ascii for A
        MOV R6, #90  @ascii for Z
        MOV R3, #97  @ascii for a
	MOV R9, #122 @ascii for z

loop:
	CMP R4, R2            @Comparing R4 and R2 to make sure we work all the way through the string
	BEQ write             @Breaking the loop when we have made it all the way throught the string
	LDRB R8, [R1, R4]     @Loading the first byte of the string into the register
	CMP R8, R5            @first check, comparing our character to 'A' 
	BLT skip              @Skipping if it is less than 'A' making it not a letter
	CMP R8, R6            @Comparing with 'Z'
	BGT check             @If it is greater than 'Z' we are checking if it is a lowercase letter


check:
        CMP R8, R9            @Comparing with 'z'
        BGT skip              @Skipping if it is greater than 'z' because it is not a letter
	CMP R8, #77           @Checking if it is in the upper half of the Uppercase letters or a lowercase letter
        BGT change2           @If it is we are going to change2
        B change


change2:
	CMP R8, #96           @comparing with 'a'
	BGT change            @if it is a lowercase letter we're going straight to change
	SUB R8, R8, #13       @If it is an uppercase letter we are subtracting 13 instead of adding 13
	STRB R8, [R1,R4]      @Storing it back in the register
	B skip                @moving onto the next character

cycle:

        SUB R8,R8, #39        @If it is in the upperhalf of the lowercase alphabet it comes here and ends up back 13
        B change              @We take it back to cycle

change:
	ADD R8, R8, #13       @We change our letter by 13
	CMP R8, R9            @If it is past 'z' and out of the alphabet we go to cycle to bring it back down
	BGT cycle             @Sends character to cycle
	STRB R8, [R1,R4]      @Stores the bit back in the register


skip:
	ADD R4, R4, #1        @Skipping to the next character
	B loop                @restarting the loop

write:
	MOV R7, #4
	MOV R0, #1
	MOV R2, #255
	LDR R1, =string
	SWI 0

end:
	MOV R7, #1
	SWI 0

.data


prompt: .ascii "Please enter a string:"


string: .space 256


