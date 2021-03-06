; Copyright 2002 Sergey Lebedev
; Licensed under the Apache License, Version 2.0

; main module

.486
.MODEL FLAT
Global Generate: near
Global Init: near

.CODE
_main:

include	compiler.inc			;�������� �������� �������
include math.inc			;������ ������ ����������
include synth.inc                       ;����
include	disk.inc                        ;������ � .wav 

.CODE
Init	proc
; ��� ���� ������� ����� ������� ������ �����
	pushad
	lea	ebp,Synth_Buf		; ��������� �� ������ ��� ������� �����
					; �� ������ -  SYNTH_TMP_MEM_SIZE
	call	Init_Synth              ; ��� ������������� �����
	popad
	retn
Init	endp

Generate proc
; ��������� �����
; esi - script ptr
; ecx - script len
; edi - wav ptr
	pushad

	mov	Text_Script_Len,ecx
	mov	Wav_File_Ptr,edi

	lea	edi,Text_Script_Buf
	rep	movsb

	mov	ecx,Text_Script_Len
        lea	esi,Text_Script_Buf
	lea	edi,Inner_Script_Buf
	call	Compile            ; ������� �������� ������� (���������)
				   ; �� ���������� (�������)
				   ; �� ����, � ����� �� ����� - ����� ���
				   ; ��������� ������ �������
				   ; ����� � compiler.inc
				   ; ����� ��������	

	lea	esi,Inner_Script_Buf  ;��������� �� ������ ��� ����� 
	lea	edi,Tmp_Sample2    ; ����� ��� ������
	call	Do_Sample

	lea	esi,Tmp_Sample2    ; ������� ����� � .wav (��� ���������� 
				   ; ����� ��� �������)
	mov	edi,Wav_File_Ptr   ; � ����� ���� �� ����� ����� ->
	call	Raw2Wav            ; ������������ disk.inc

	popad
		
	mov	eax,Riff_Len	   ; ��������� ����� �����
				   ; ����� ����� ����� ���������
	retn
Generate	endp

.DATA?
Wav_File_Ptr	dd	?
Synth_Buf	db	SYNTH_TMP_MEM_SIZE dup (?)
Tmp_Sample2	dw	MAX_SAMPLE_SIZE_ dup(?)

Inner_Script_Buf db	INNER_SCRIPT_MAX_LEN dup (?)
Text_Script_Buf	db	SCRIPT_MAX_LEN dup (?)
Text_Script_Len	dd	?
end _main