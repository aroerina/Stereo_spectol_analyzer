# ext_dout output Strove address
.equ	ADR_SW,			0x01
.equ	ADR_RO,			0x02
.equ	ADR_FW,			0x04
.equ	ADR_MUX,		0x08
.equ	ADR_SC_THRU,	0x10
.equ	ADR_LOADER,		0x20

# ext_din input Strove address
.equ	ADR_STATUS,		0x01
.equ	F_ROMQ,			0x02
.equ	SC_H,			0x04

# module status
.equ ST_STARTSEQ,		0x01
.equ ST_FFTEND	,		0x02
.equ ST_READY_SW,		0x04
.equ ST_READY_RO,		0x08
.equ ST_READY_FW,		0x10

.equ H_ROM_DEPTH,		59	#F_ROM_DEPTH=61 + -2
.equ F_ROM_DEPTH,		305
.equ NUM_FROM_SUB_HROM,	244

movi r31,1	#r31 = 1

main_loop:
	movi	r20,2							#r20:loopvar two_times_loop
	
	wait_startseq:
		import	r0,	ADR_STATUS				#wait start	pulse
		testi	r0,	ST_STARTSEQ
	bz	wait_startseq
	
	two_times_loop:
		addi	r20,1
	
		export	r0,	ADR_LOADER				#START LOADER
		export	r31,ADR_SC_THRU				#SC_THRU ON

		wait_fftc_end:
			import	r0,	ADR_STATUS
			testi	r0,	ST_FFTEND
		bz		wait_fftc_end

		export	r0,ADR_RO					#Start RO

		wait_ro_0:
			import	r0,	ADR_STATUS
			testi	r0,	ST_READY_RO
		bz		wait_ro_0

		export	r0,ADR_RO				#Start RO
		export	r30,ADR_SC_THRU			#SC_THRU OFF

		wait_ro_1:
			import	r0,	ADR_STATUS
			testi	r0,	ST_READY_RO
		bz		wait_ro_1

		#補完を必要とする区間の描画
		movi r16,H_ROM_DEPTH					# r16 = 1	loop var1
		loop_for_complement_section:		
			import	r1,	SC_H					# r1 = H	
			export	r0,	ADR_RO					#START RO & SC
			
			complement_loop_start:
				subi r1,1						# H-1
				bc	complement_loop_end			# loop times :H
				
				wait_sw_0:						#wait SW
					import	r0, ADR_STATUS
					testi	r0, ST_READY_SW
				bz	wait_sw_0
				
				export	r0, ADR_SW				#start SW
				b		complement_loop_start
			complement_loop_end:
			
			subi	r16,1	#loop var1-1		#loopvar1 > H_ROM_DEPTH
		bnz		loop_for_complement_section	
			
		wait_ro_2:
			import	r0,	ADR_STATUS
			testi	r0,	ST_READY_RO
		bz		wait_ro_2
		
		export r0,ADR_SW	#START SW
		export	r31,ADR_SC_THRU				#SC_THRU ON
		
		#補完が必要ない区間の描画
		movi	r16,NUM_FROM_SUB_HROM
		loop_for_noncomplemention_section:
			wait_sw_1:
				import	r0,ADR_STATUS
				testi	r0,ST_READY_SW
			bz	wait_sw_1
			
			export	r0,0x03
			subi	r16,1					#!(loopvar > NUM_FROM_SUB_HROM)
		bnz		loop_for_noncomplemention_section
		
		subi	r20,1						#!(loopvar_two_times_loop) > 2)
	bnz		two_times_loop
b	main_loop