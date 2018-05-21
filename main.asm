INCLUDE Irvine32.inc
INCLUDE macros.inc

BUFFER_SIZE = 5000

.DATA
KEY BYTE ?
s_welcome_key  BYTE 'Enter Key: ',0
s_welcome_filename  BYTE 'Enter file name: ',0
s_welcome  BYTE 'Enter your choice: ',0
s_welcome_id  BYTE 'ID: ',0
s_welcome_name  BYTE 'Name: ',0
s_welcome_grade  BYTE 'Grade: ',0
s_welcome_grade_alpha  BYTE 'Alpha Grade: ',0
s_sort_inc BYTE 'Enter 1 to Sort as Increasing',0
s_sort_dec BYTE 'Enter 2 to Sort as Decreasing',0
s1  BYTE 'Enter 1 to Enroll Student',0
s2  BYTE 'Enter 2 to Update Grade from Student',0
s3  BYTE 'Enter 3 to Delete Student',0
s4  BYTE 'Enter 4 to Display Student Data use Student Id',0
s5  BYTE 'Enter 5 to Save to File',0
s6  BYTE 'Enter 6 to Retrieve Data From File',0
s7  BYTE 'Enter 7 to Create Report',0
s_id  BYTE 'Enter student ID: ',0
temp byte 15 Dup(?),0
temp1 byte 3 Dup(?),0
s_name BYTE 'Enter student Name: ',0
s_grade BYTE 'Enter student grade: ' ,0
msg_err BYTE 'Error Id' ,0
student_id BYTE 100 Dup(?)
student_id_sorted BYTE 100 Dup(?)
student_name_sorted BYTE 100 Dup(?)
student_grade_sorted BYTE 100 Dup(?)
student_grade_alpha_sorted BYTE 100 Dup(?)
student_id_file BYTE 100 Dup(?)
student_id_file_sorted BYTE 100 Dup(?)
student_id_temp BYTE 3 Dup(?)
student_id_tempsize = ($ - student_id_temp)
student_name byte  2000 Dup(?)
student_grade byte 2000 Dup(?)
student_grade_alpha byte 2000 Dup(?)
c_id_file dword 0
c_name dword 0
c_grade dword 0
c_grade_alpha dword 0
Counter_Of_size dword 0
counter_report_id_file dword 0
counter_report_name dword 0
counter_report_grade dword 0
counter_report_grade_alpha dword 0
counter_id DWORD 0
counter_id_temp DWORD 0
new_count DWORD 0
counter_name DWORD 0
counter_grade DWORD 0
counter_grade_alpha DWORD 0
cnt_e_student DWORD 0
counter_delete_name DWORD 0
counter_grade_alpha_delete DWORD 0
counter_grade_2 DWORD 0
Dec_alpha DWORD 0
bufferOutput BYTE BUFFER_SIZE DUP(?)
filenameRead BYTE BUFFER_SIZE DUP(?)
fileHandle HANDLE ?
stringLength DWORD ?
bytesWritten DWORD ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "File Size [output.txt]: ",0
SizeinFile dword ?
counter_length_delm dword 0
Arr BYTE 3 DUP(?)
valID BYTE 0
valName BYTE 0

.CODE		
main PROC

whilelop:
call display1
mov ebx,1
cmp eax,ebx
;;if user enter 1
je EnrollStudent1
jmp skip2
EnrollStudent1:
call fun_EnrollStudent
jmp whilelop
;;;;end of 1
;;;;;;;;; if not enter 1 and possible enter 2
skip2:
mov ebx,2
cmp eax,ebx
je UpdateGrade2
jmp skip3
UpdateGrade2:
call UpdateGrade_fun
jmp whilelop
;;;;end of 2
;;;;;;;;; if not enter 2 and possible enter 3
skip3:
mov ebx,3
cmp eax,ebx
je DeleteStudent3
jmp skip4
DeleteStudent3:
call DeleteStudent_fun
jmp whilelop

skip4:
mov ebx,4
cmp eax,ebx
je DisplayStudentData_label
jmp skip5
DisplayStudentData_label:
call DisplayStudentData_fun
jmp whilelop

skip5:
mov ebx,5
cmp eax,ebx
je SavetoFile_label
jmp skip6
SavetoFile_label:
call SavetoFile
jmp quit

skip6:
mov ebx,6
cmp eax,ebx
je DisplayFromFile_label
jmp skip7
DisplayFromFile_label:
call DisplayFromFile
jmp whilelop

skip7:
mov ebx,7
cmp eax,ebx
je Report_label
jmp quit
Report_label:
mov edx, offset s_sort_inc
call writestring
call crlf
mov edx, offset s_sort_dec
call writestring
call crlf
mov edx , offset s_welcome
call writestring 

call readint
   mov ebx,1
   cmp ebx ,eax
   je lab_inc
   mov ebx,2
   cmp ebx,eax
   je lab_dec
   lab_dec:
	call BubbleSort_dec
	jmp skipFinal
	lab_inc:
	call BubbleSort_inc
skipFinal:
call FunReport
call SavetoFileSorted
jmp quit

quit:
exit 
main ENDP
;;;;;;;;;;;;;;;;;;;;; to display the first screen
display1 PROC 
mov edx , offset s1
call writestring 
call crlf
mov edx , offset s2
call writestring 
call crlf 
mov edx , offset s3
call writestring
call crlf 
mov edx , offset s4
call writestring 
call crlf 
mov edx , offset s5
call writestring
call crlf 
mov edx , offset s6
call writestring 
call crlf 
mov edx , offset s7
call writestring 
call crlf 
mov edx , offset s_welcome
call writestring 

call readint
ret 
display1 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
st_id_dis PROC
;;;;;enter id string edx point to s_id
mov edx , offset s_id
call writestring
ret
st_id_dis ENDP

fun_EnrollStudent PROC 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; id input 
call st_id_dis  ; display enter id string  make user enter id  and put id in edx
mov edx, offset student_id_temp
mov ecx, lengthof student_id_temp
call readstring 

mov edx, offset student_id_file
add edx, counter_id_temp
mov ebx ,offset student_id_temp
mov ecx , eax 
push eax
lpp3:
	mov al , [ebx]
	mov [edx] , al
	add edx , 1
	add ebx , 1
LOOP lpp3
	pop eax
	cmp eax, 3
	je skip2
	mov edi, 3
	sub edi,eax
	mov ecx,edi
	lpp12:
	mov al,' '
	mov [edx],al
	add edx,1
	loop lpp12
	skip2:
	add counter_id_temp, 3

	mov edx,OFFSET student_id_temp
    mov ecx, student_id_tempsize
    call ParseDecimal32

mov esi, offset student_id
mov edi, offset student_id_sorted
add esi, counter_id
add edi, counter_id
mov [esi], eax
mov [edi], eax
add counter_id ,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end id fun
;;;;;;;;;;;;;;;;;;;;;;diplay enter name
mov edx , offset s_name
call writestring 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end of display
;;;;;;;;;;;;;;;;;add student name and com with * edi point to student
mov edx , offset temp
mov ecx, lengthof temp
call readstring
mov edx , offset temp
mov ebx ,offset student_name
add ebx,counter_name
mov ecx , eax 
push eax
lpp:
	mov al , [edx]
	mov [ebx] , al
	add edx , 1
	add ebx , 1
LOOP lpp
pop eax
cmp eax,10
je skip
mov edi,10
sub edi,eax
mov ecx,edi
lpp1:
mov al,' '
mov [ebx],al
add ebx,1
loop lpp1
skip:
add counter_name,10

ret
fun_EnrollStudent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateGrade_fun PROC
call st_id_dis  ; display enter id string  make user enter id 
;;;;;;;;;string enter grade edi point to  s_grade
call readint 
mov ebx,eax
mov edx , offset s_grade
call writestring 
;;;;;;;;;end of enter grade;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;search for id and if found put grade in indx and indx=esi
mov esi,offset student_id
mov ecx, lengthof student_id
mov counter_grade,0
push eax
mov eax,counter_grade_2

pop eax
l_grade:
  cmp ebx,[esi]  ;ebx=id
je lab_equ
   add counter_grade,2
  add esi,1
loop l_grade

jmp notfound
lab_equ:
add counter_grade_2,2
mov edx , offset temp1
mov ecx, lengthof temp1
mov esi,offset student_grade_alpha
add esi , counter_grade_alpha
call readstring
push eax
call  ParseDecimal32

cmp eax,90
jge A

cmp eax,80							; this is the else part so we'll compare if its Greater than 80
jge B

cmp eax,70									; at this point we know the score is less than 80 so check the others
jge CC

cmp eax,60
jge D

cmp eax,0									; at this point we know it's less than 60 so it's fail but we have to make sure its not less than zero
jge  F

A:
mov al, 'A'
mov [esi], al
JMP ENDCHECK   ; TO SKIP MOVING TO THE error part
B:
mov al, 'B'
mov [esi], al
JMP ENDCHECK
CC:
mov al, 'C'
mov [esi], al
JMP ENDCHECK

D:
mov al, 'D'
mov [esi], al
JMP ENDCHECK

F:
mov al, 'F'
mov [esi], al				
JMP ENDCHECK

ENDCHECK:
add counter_grade_alpha, 1
pop eax
mov edx , offset temp1
mov ebx ,offset student_grade
add ebx,counter_grade
mov ecx , eax 
push eax
lpp:
	mov al , [edx]
	mov [ebx] , al
	add edx , 1
	add ebx , 1
LOOP lpp
pop eax
skip:
jmp ski1
notfound: 
mov edx , offset msg_err
call writestring 
ski1:

ret
UpdateGrade_fun ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DeleteStudent_fun PROC 
call st_id_dis  ; display enter id string  make user enter id  and put id in edx
 call readint 
mov esi,offset student_id
mov ecx, lengthof student_id
mov counter_grade,0
mov counter_grade_alpha_delete,0
mov counter_delete_name , 0
l_delete:
  cmp al,[esi]  ;al=id
je lab_equ
   add  counter_grade,2
   add counter_delete_name, 10
   add counter_grade_alpha_delete,1
   add esi,1
loop l_delete
jmp notfound
lab_equ:
   mov edi , offset student_grade
   add edi ,  counter_grade
   mov al,0
   mov [esi],al  ;make id 0
  mov ecx,2
   lip:
   mov al,'0'
   mov [edi],al
   add edi,1
   loop lip
   mov esi, offset student_name
   mov ecx,10
   add esi,counter_delete_name
lp_del:
  mov al,' '
  mov [esi],al
  add esi ,1
loop lp_del 
mov ebx , offset student_grade_alpha
add ebx , counter_grade_alpha_delete
mov al,' '
mov [ebx], al

jmp ski3
notfound: 
mov edx , offset msg_err
call writestring 

ski3:

ret 
DeleteStudent_fun ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; display student info 
DisplayStudentData_fun PROC 
call st_id_dis  ; display enter id string  make user enter id  and put id in edx
call readint
mov esi,offset student_id
mov ecx, lengthof student_id
mov ebx , offset student_grade_alpha
mov counter_grade,0
mov counter_delete_name,0
mov counter_grade_alpha ,0
l_delete:
  cmp al,[esi]  ;ebx=id
  
je lab_equ
   
   add counter_grade,2
   add counter_delete_name , 10
   add counter_grade_alpha,1
   add esi,1
loop l_delete
jmp notfound
lab_equ:
   mov edx, offset s_welcome_id
	call writestring
   mov al, [esi]  ;display id 
   call writedec
   call crlf
   mov edx, offset s_welcome_name
	call writestring
   mov esi, offset student_name
   mov ecx,10
   add esi,counter_delete_name
lp_del:
  mov al, [esi]
  call writechar
  add esi ,1
loop lp_del 
call crlf
mov edx, offset s_welcome_grade
	call writestring
   mov edi,offset student_grade
   add edi ,counter_grade
   mov ecx,2
   lip:
   mov al,[edi]
   call writechar
   add edi,1
   loop lip
   call crlf 
mov edx, offset s_welcome_grade_alpha
call writestring
add ebx,counter_grade_alpha
mov al,[ebx]
call writechar
call crlf

jmp ski3
notfound: 
mov edx , offset msg_err
call writestring 
call crlf 
ski3:

ret 
DisplayStudentData_fun ENDP

Write_File proc

mov edx , offset s_welcome_filename
call writestring 

mov edx ,offset filenameRead
mov ecx, lengthof filenameRead
call readstring

; Create a new text file.
mov edx,OFFSET filenameRead
call CreateOutputFile
mov fileHandle,eax

; Check for errors.
cmp eax, INVALID_HANDLE_VALUE ; error found?
jne file_ok ; no: skip
mov edx,OFFSET str1 ; display error
call WriteString
jmp quit
file_ok:

;mov stringLength,lengthof bufferOutput

COMMENT @
mov ecx,stringLength ; Input a string
mov esi, 0	; index 0 in buffer

Encrypt:
	mov al, KEY
	xor bufferOutput[esi], al	; translate a byte
	inc esi	; point to next byte
	loop Encrypt
@

; Write the buffer to the output file.
mov eax,fileHandle
mov edx,OFFSET bufferOutput
mov ecx,stringLength

call WriteToFile
mov bytesWritten,eax
call CloseFile

COMMENT @
; Display the return value.
mov edx,OFFSET str2 ; "Bytes written"
call WriteString

mov eax,bytesWritten
call WriteDec
call Crlf
@

quit:

ret
Write_File endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Read_File proc

mov edx , offset s_welcome_filename
call writestring 

mov edx ,offset filenameRead
mov ecx, lengthof filenameRead
call readstring

; Open the file for input.
mov edx,OFFSET filenameRead
call OpenInputFile
mov fileHandle,eax

; Check for errors.
cmp eax,INVALID_HANDLE_VALUE ; error opening file?
jne file_ok ; no: skip
mWrite <"Cannot open file",0dh,0ah>
jmp quit ; and quit
file_ok:

; Read the file into a bufferOutput.
mov edx,OFFSET bufferOutput
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size ; error reading?
mWrite "Error reading file. " ; yes: show error message
call WriteWindowsMsg
jmp close_file

check_buffer_size:
cmp eax,BUFFER_SIZE ; bufferOutput large enough?
jb buf_size_ok ; yes
mWrite <"Error: Buffer too small for the file",0dh,0ah>
jmp quit ; and quit
buf_size_ok:
mov bufferOutput[eax],0 ; insert null terminator
mov SizeinFile, eax

COMMENT @
mWrite "File size [output.txt]: "
call WriteDec ; display file size
call Crlf
@

cmp eax,0
je quit

COMMENT @
mov ecx, eax ; Input a string
mov esi, 0	; index 0 in bufferOutput
Decrypt:
	mov al, KEY
	xor bufferOutput[esi], al	; translate a byte
	inc esi	; point to next byte
	loop Decrypt
@

COMMENT @
; Display the bufferOutput.
mov edx,OFFSET bufferOutput ; display the bufferOutput
call WriteString
call Crlf
@

close_file:
mov eax,fileHandle
call CloseFile
quit:

ret
Read_File endp

SavetoFile proc

mov edx , offset s_welcome_key
call writestring 
call readdec
mov KEY, al

;COMMENT @
mov esi, offset student_id_file
mov ebx, offset student_name
mov edx, offset student_grade
mov edi, offset bufferOutput
mov new_count,0
mov eax, 0
add eax, counter_id

mov ecx,eax
L1:
	push ecx
	mov ecx, 3
	LLID:
		mov al, [esi]
		mov [edi], al
		inc edi
		inc esi
		loop LLID
	mov al,'@'
	mov [edi],al
	inc edi 

	mov ecx, 10
	LL1:
		mov al, [ebx]
		mov [edi],al
		inc edi
		inc ebx
		loop LL1
		mov al,'@'
	mov [edi],al
	inc edi 
	mov ecx, 2
	LL2:
		mov al, [edx]
		;call writechar
		mov [edi],al
		inc edi
		inc edx
		loop LL2
	mov al,'@'
	mov [edi],al
	inc edi 
	pop ecx
	push edx
	mov edx,offset student_grade_alpha
	add edx,new_count
	mov al,[edx]
	mov [edi],al
	inc edi 
	add new_count ,1
	pop edx
	mov al,13
	mov [edi],al
	inc edi
	mov al,10
	mov [edi],al
	inc edi
	loop L1

mov eax, 0
add eax, counter_id_temp
add eax, counter_name
add eax, counter_grade_2
add eax,counter_grade_alpha
add eax,counter_grade_alpha
add eax,counter_grade_alpha
add eax,counter_grade_alpha
sub counter_grade_alpha, 1
add eax,counter_grade_alpha
add eax,counter_grade_alpha
mov stringLength, eax
call Write_File
;@

ret
SavetoFile endp

DisplayFromFile proc

mov edx , offset s_welcome_key
call writestring 
call readdec
mov KEY, al

call Read_File

mov ecx, SizeinFile
mov esi, offset bufferOutput

LoopLength:
	mov al, [esi]
	cmp al, '@'
	je OutLen
	jmp skipIT
	OutLen:
		add counter_length_delm, 1
	skipIT:
	inc esi
	loop LoopLength
	mov eax, counter_length_delm
	mov edx,0
	mov edi,3
	div edi

mov ecx, eax
mov esi, 0
mov ebx, offset student_id
mov edx, offset student_id_file
mov edi, offset bufferOutput
mov new_count,0

L1Out:
  
	push ecx
	
	call FUNC_ID_Name_Grade

	pop ecx
	
	push edx
	mov edx, offset student_grade_alpha
	add edx,new_count
	mov al, [edi]
	mov [edx], al
	inc edi
	add new_count, 1
	add counter_grade_alpha ,1
	pop edx
	add edi, 2
	loop L1Out

ret
DisplayFromFile endp

FUNC_ID_Name_Grade PROC

mov ecx, 3
	LL1OutID:
		mov al, [edi]
		mov student_id_temp[esi], al
		mov [edx], al
		inc edx
		inc edi
		inc esi	
		loop LL1OutID
	inc edi
	mov esi, 0
	add counter_id_temp, 3

push edx
	mov edx,OFFSET student_id_temp
    mov ecx,3
    call ParseDecimal32
	mov [ebx], al
	inc ebx
	add counter_id ,1
	pop edx

	mov ecx, 10
	add esi, counter_name
	add counter_name ,10

	LL1Out:
		mov al, [edi]
		mov student_name[esi], al
		inc edi
		inc esi	
		loop LL1Out
	inc edi
	mov esi, 0

	mov ecx, 2
	add esi, counter_grade_2
	add counter_grade_2 ,2
	LL2Out:
		mov al, [edi]
		;call writechar
		mov student_grade[esi],al
		inc edi
		inc esi
		loop LL2Out
	inc edi
	mov esi, 0

ret
FUNC_ID_Name_Grade endp

BubbleSort_inc PROC

mov ecx, counter_id
dec ecx 
Loop1: 
	push ecx 
	mov esi, offset student_id_sorted
	Loop2:
		 mov al, [esi] 
		 cmp [esi+1], al 
		 jg Done 
		 xchg al, [esi+1] 
		 mov [esi], al
		Done:
		add esi,1
	loop Loop2
	pop ecx
loop Loop1

ret
BubbleSort_inc ENDP

BubbleSort_dec PROC

mov ecx, counter_id
dec ecx 
Loop1: 
	push ecx 
	mov esi, offset student_id_sorted
	Loop2:
		 mov al, [esi] 
		 cmp [esi+1], al 
		 jl Done 
		 xchg al, [esi+1] 
		 mov [esi], al
		Done:
		add esi,1
	loop Loop2
	pop ecx
loop Loop1

ret
BubbleSort_dec ENDP


FunReport PROC
mov esi,offset student_id_sorted
mov ecx, counter_id
L50:
	call LoopFun
	loop L50

ret
FunReport ENDP

LoopFun PROC
	push ecx
	mov ecx, counter_id
	mov al, [esi]
	mov edi, offset student_id
	L51:
		cmp al, [edi]
		je yes
		inc edi
		add counter_report_id_file, 3
		add counter_report_name, 10
		add counter_report_grade, 2
		add counter_report_grade_alpha, 1
	
		loop L51
	yes:
		mov ecx, 3
		L522:
			mov ebx, counter_report_id_file
			mov al, student_id_file[ebx]
			mov ebx, c_id_file
			mov student_id_file_sorted[ebx], al
			inc c_id_file
			inc counter_report_id_file
			loop L522

		mov ecx, 10
		L52:
			mov ebx, counter_report_name
			mov al, student_name[ebx]
			mov ebx, c_name
			mov student_name_sorted[ebx], al
			inc c_name
			inc counter_report_name
			loop L52

		mov ecx, 2
		L53:
			mov ebx, counter_report_grade
			mov al, student_grade[ebx]
			mov ebx, c_grade
			mov student_grade_sorted[ebx], al
			inc c_grade
			inc counter_report_grade
			loop L53

		mov ebx, counter_report_grade_alpha
		mov al, student_grade_alpha[ebx]
		mov ebx, c_grade_alpha
		mov student_grade_alpha_sorted[ebx], al
		inc c_grade_alpha

		pop ecx
		inc esi
		mov counter_report_id_file, 0
		mov counter_report_name, 0
		mov counter_report_grade, 0
		mov counter_report_grade_alpha, 0

ret
LoopFun ENDP

SavetoFileSorted proc

mov edx , offset s_welcome_key
call writestring 
call readdec
mov KEY, al

;COMMENT @
mov esi, offset student_id_file_sorted
mov ebx, offset student_name_sorted
mov edx, offset student_grade_sorted
mov edi, offset bufferOutput
mov new_count,0
mov eax, 0
add eax, counter_id

mov ecx,eax
L1:
	push ecx
	mov ecx, 3
	LLID:
		mov al, [esi]
		mov [edi], al
		inc edi
		inc esi
		loop LLID
	mov al,'@'
	mov [edi],al
	inc edi 

	mov ecx, 10
	LL1:
		mov al, [ebx]
		mov [edi],al
		inc edi
		inc ebx
		loop LL1
		mov al,'@'
	mov [edi],al
	inc edi 
	mov ecx, 2
	LL2:
		mov al, [edx]
		;call writechar
		mov [edi],al
		inc edi
		inc edx
		loop LL2
	mov al,'@'
	mov [edi],al
	inc edi 
	pop ecx
	push edx
	mov edx,offset student_grade_alpha_sorted
	add edx,new_count
	mov al,[edx]
	mov [edi],al
	inc edi 
	add new_count ,1
	pop edx
	mov al,13
	mov [edi],al
	inc edi
	mov al,10
	mov [edi],al
	inc edi
	loop L1

mov eax, 0
add eax, counter_id_temp
add eax, counter_name
add eax, counter_grade_2
add eax,counter_grade_alpha
add eax,counter_grade_alpha
add eax,counter_grade_alpha
add eax,counter_grade_alpha
sub counter_grade_alpha, 1
add eax,counter_grade_alpha
add eax,counter_grade_alpha
mov stringLength, eax
call Write_File
;@

ret
SavetoFileSorted endp

END main