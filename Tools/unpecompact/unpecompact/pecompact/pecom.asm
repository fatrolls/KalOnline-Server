;prosty unpacker dla pecompact napisany przez mirz
;wszystkie uwagi, bledy itp. wysylaj na e-mail:
;mirz@o2.pl

.386
.model flat,stdcall

OPTION CASEMAP:NONE

;biblioteki

include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib
include comdlg32.inc
includelib comdlg32.lib

SetBreakpoint 		PROTO :DWORD			;procedura do stawiania breakpoint
SprawdzPE			PROTO					;procedura do sprawdzania PE
SyganturaPeCompact	PROTO					;procedura do sprawdzania czy jest PeCompact2.X
SzukajOEP			PROTO
UsunBreakpoint		PROTO :DWORD,:BYTE		;procedura sluzacza do usuwania breakpointa
SzukajIID			PROTO
Dump				PROTO
Zapisz				PROTO

.CONST

.DATA

	ofn 				OPENFILENAME <>
	FilterString		db "Pliki (*.exe)",0,"*.exe",0,0
	szTitle				db "[Un-PeCompact 0.1b] by mirz - Wybierz cel...",0
	blad				db "B³¹d",0
	bladPlik			db "Niemogê uzyskaæ dostêpu do pliku",0
	bladNieznany		db "Nieznany b³¹d",0
	bladPamiec			db "Niemogê zaalokowaæ pamiêci",0
	bladPE				db "Niepoprawne PE !!!",0
	bladProces			db "Niemogê stworzyæ procesu",0
	bladPECompact		db "Nie znalaz³em PECompact2.x :(",0
	brak				db "Ostrze¿enie",0
	PEComp				db "PECompact2",0
	rozwalic			db "[Un-PeCompact 0.1b]",0
	znalazlem			db "Znalazlem PECompact 2.X",0dh,0Ah,
							"Czy chcesz go rozpakowaæ?",0
	break				db 0CCh		;int3
	naprawSize			db 06Ah
	naprawWhere			db 05Ah
	naprawIAT			db 0FFh
	AddressOfEntryPoint	DD 0
	SizeOfImage			DD 0
	ImageBase			DD 0
	NumberOfSections	DD 0
	porownanie			DD 0
	patchOEP			DD 0
	patchSize			DD 0
	patchIAT			DD 0
	sizeVirtual			DD 0
	patchWhere			DD 0
	where				DD 0
	patchIID			DD 0
	addressIID			DD 0
	breakFixIDD			DW 08AE9h
	breakFixIDD1		DD 090000000h
	usunIID				DB 085h
	OEP					DD 0
	naprawOEP			DB 05Dh
	Characteristics		DD 0
	unpacked			db "unpacked.exe",0
	ok					DB "ok",0
	zrobione			DB "Zrobione :)",0
	
.DATA?

	buffer 					db 512 dup(?)
	hFile					HANDLE ?
	pFile					HANDLE ?
	MapSize					dd ?
	SizeReadWrite			DWORD ?
	startupinfo				STARTUPINFO <>
	PI_						PROCESS_INFORMATION <>
	DBE						DEBUG_EVENT <>
	context					CONTEXT <>
	MapAddress				dd ?
	hMemory					HANDLE ?
	pMemory					DWORD ?
	pMapVirtual				DD ?
	
.CODE

start:
	
	mov ofn.lStructSize,SIZEOF ofn
	mov ofn.lpstrFilter,OFFSET FilterString
	mov ofn.lpstrFile,OFFSET buffer
	mov ofn.nMaxFile,512
	mov ofn.lpstrTitle,OFFSET szTitle
	mov ofn.Flags,OFN_FILEMUSTEXIST OR OFN_PATHMUSTEXIST
	invoke GetOpenFileName,addr ofn						;okno dialogowe z plikiem do otwarcia
	.if eax==TRUE
		invoke CreateFile,addr buffer,GENERIC_READ,FILE_SHARE_READ,\		
					NULL,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,NULL
		.if EAX==INVALID_HANDLE_VALUE					;jezeli nie moze uzyskac dostepu do pliku
			invoke MessageBox,0,ADDR bladPlik,ADDR blad,MB_ICONERROR
			jmp koniec
		.endif
		mov [hFile],eax							;uchwyt do pliku
		invoke GetFileSize,hFile,NULL
		mov [MapSize],eax
		invoke VirtualAlloc,NULL,EAX,MEM_COMMIT,PAGE_EXECUTE_READWRITE		;zaalokuj pamieæ
		.if !EAX
			invoke MessageBox,0,ADDR bladPamiec,ADDR blad,MB_ICONERROR
			jmp koniecPamiec
		.endif
		mov [MapAddress],eax
		invoke ReadFile,hFile,EAX,MapSize,ADDR SizeReadWrite,NULL			;czytaj plik
		invoke SprawdzPE
		test eax,eax
		je koniecPamiec			;skacz jezeli blad
		invoke GetStartupInfo,ADDR startupinfo
		invoke CreateProcess,addr buffer,NULL, NULL, NULL, FALSE,\			;tworzymy proces
						DEBUG_PROCESS OR DEBUG_ONLY_THIS_PROCESS,\
						NULL, NULL, ADDR startupinfo, ADDR PI_
		.if !EAX
			invoke MessageBox,0,ADDR bladProces,ADDR blad,MB_ICONERROR		;blad nie moge stworzyc procesu
			jmp koniecPamiec
		.endif
		invoke GlobalAlloc,GPTR,SizeOfImage
		mov  hMemory,eax
		invoke GlobalLock,hMemory
		mov  pMemory,eax
		invoke ReadProcessMemory,PI_.hProcess,ImageBase,pMemory,SizeOfImage,0		;czytaj proces
		invoke SzukajOEP
		.while TRUE
			invoke WaitForDebugEvent,ADDR DBE,INFINITE
			.if !eax
				invoke MessageBox,0,ADDR bladNieznany,ADDR blad,MB_ICONERROR	;dupa cos poszlo nie tak
				.break
			.endif
			.if DBE.u.Exception.pExceptionRecord.ExceptionCode==EXCEPTION_BREAKPOINT
				mov context.ContextFlags,CONTEXT_CONTROL
				invoke GetThreadContext,PI_.hThread,addr context
				mov eax,context.regEip
				.if eax==[patchOEP]
					mov context.ContextFlags,CONTEXT_INTEGER
					invoke GetThreadContext,PI_.hThread,addr context
					mov eax,context.regEax	;w eax bedzie adres OEP
					mov [OEP],eax
					invoke UsunBreakpoint,patchOEP,naprawOEP
					invoke Dump				;zrzuc proces
					invoke Zapisz
					.break
				.elseif eax==[patchSize]
					mov context.ContextFlags,CONTEXT_INTEGER
					invoke GetThreadContext,PI_.hThread,addr context
					mov ebx,context.regEbx			;pobierz ebx
					add ebx,4						;teraz idz do rozmiaru
					invoke ReadProcessMemory,PI_.hProcess,ebx,pMemory,4,0
					mov eax,pMemory					
					mov eax,dword ptr[eax]
					mov [sizeVirtual],eax			;wpisz rozmiar to sie pozniej przyda
					invoke UsunBreakpoint,patchSize,naprawSize
				.elseif eax==[patchWhere]			
					mov context.ContextFlags,CONTEXT_INTEGER
					invoke GetThreadContext,PI_.hThread,addr context
					mov ebx,context.regEax			;pobierz wartosc eax dzieki temu bedziesz wiedzial
					mov [where],ebx					;gdzie program zaalokowal pamiec
					invoke UsunBreakpoint,patchWhere,naprawWhere
				.elseif eax==[patchIAT]
					mov context.ContextFlags,CONTEXT_INTEGER
					invoke GetThreadContext,PI_.hThread,addr context
					invoke VirtualAlloc,NULL,sizeVirtual,MEM_COMMIT,PAGE_EXECUTE_READWRITE	;zaladuj potrzebna pamiec
					mov [pMapVirtual],eax
					mov ebx,context.regEdi
					sub ebx,[where]
					mov edx,[sizeVirtual]
					sub edx,ebx						;teraz mamy ile musimy przeczytac
					mov ebx,context.regEdi
					invoke ReadProcessMemory,PI_.hProcess,ebx,pMapVirtual,edx,0
					invoke SzukajIID
					invoke VirtualFree,pMapVirtual,sizeVirtual,MEM_DECOMMIT		;po skonczonej operacji mozemy zwolnic
					invoke UsunBreakpoint,patchIAT,naprawIAT
				.elseif eax==[patchIID]
					mov context.ContextFlags,CONTEXT_INTEGER
					invoke GetThreadContext,PI_.hThread,addr context
					mov eax,context.regEcx					;pobierz wlasciwy adres IID
					mov [addressIID],eax
					mov eax,[patchIID]						;zeby nam tego nie popsul
					inc eax
					invoke WriteProcessMemory,PI_.hProcess,EAX,addr breakFixIDD,2,NULL
					mov eax,[patchIID]
					add eax,3
					invoke WriteProcessMemory,PI_.hProcess,EAX,addr breakFixIDD1,4,NULL
					invoke UsunBreakpoint,patchIID,usunIID
				.endif
				invoke ContinueDebugEvent,DBE.dwProcessId,DBE.dwThreadId,DBG_CONTINUE
			.elseif DBE.dwDebugEventCode==EXIT_PROCESS_DEBUG_EVENT
				invoke MessageBox,0,ADDR bladNieznany,ADDR blad,MB_ICONERROR
				.break
			.endif
			invoke ContinueDebugEvent,DBE.dwProcessId,DBE.dwThreadId,DBG_EXCEPTION_NOT_HANDLED
		.endw
		invoke TerminateProcess,PI_.hProcess,NULL		;zabij proces
		invoke Sleep,500								;przeczekaj na zabicie
		invoke CloseHandle,PI_.hProcess					;zamknij uchwyt
		invoke CloseHandle,PI_.hThread					;zamknij uchwyt
		invoke GlobalUnlock,pMemory		;zwolnij pamiec
		invoke GlobalFree,hMemory
koniecPamiec:
		invoke CloseHandle,hFile				;zamknij uchwyt do pliku
		invoke VirtualFree,MapAddress,MapSize,MEM_DECOMMIT
	.endif
koniec:
	invoke ExitProcess,0

SetBreakpoint PROC BaseAddress:DWORD	;ustawiamy breakpoint na komendy

	pushad
	dec [BaseAddress]		;trzeba zmienic adres
	invoke WriteProcessMemory,PI_.hProcess,BaseAddress,addr break,1,NULL	;ustawiamy breakpoint na komende
	popad
	Ret
SetBreakpoint EndP

SprawdzPE PROC

	mov edi,MapAddress
	assume edi:ptr IMAGE_DOS_HEADER
	.if [edi].e_magic==IMAGE_DOS_SIGNATURE
		add edi,[edi].e_lfanew
		assume edi:ptr IMAGE_NT_HEADERS
		.if [edi].Signature==IMAGE_NT_SIGNATURE
			invoke SyganturaPeCompact
		.else
			invoke MessageBox,0,ADDR bladPE,ADDR blad,MB_ICONERROR	;blad jezeli pe jest nie poprawne
			xor eax,eax
		.endif
	.else
		invoke MessageBox,0,ADDR bladPE,ADDR blad,MB_ICONERROR
		xor eax,eax
	.endif
	Ret
SprawdzPE EndP

SyganturaPeCompact PROC

	assume edi:ptr IMAGE_NT_HEADERS
	mov eax,[edi].OptionalHeader.AddressOfEntryPoint			;to pozniej sie przyda do szukania OEP i nietylko
	mov [AddressOfEntryPoint],eax
	mov eax,[edi].OptionalHeader.ImageBase						;to bedzie potrzebne do czytania procesu
	mov [ImageBase],eax
	mov eax,[edi].OptionalHeader.SizeOfImage					;to tak samo
	mov [SizeOfImage],eax
	xor eax,eax
	mov ax,[edi].FileHeader.NumberOfSections
	mov [NumberOfSections],eax
	add edi,IMAGE_NT_HEADERS
	assume edi:ptr IMAGE_SECTION_HEADER
	mov ebx,[NumberOfSections]
	.while ebx!=0
		lea eax,[edi].Name1
		.if dword ptr[eax]=='EDOC'		;czy sekcja code
			mov eax,[edi].Characteristics
			mov [Characteristics],eax							;to sie pozniej przyda
			mov eax,[edi].PointerToRawData						;pobierz gdzie jest RAWDATA
			add eax,MapAddress									;dodaj to do MapAddress
			add eax,18h											;teraz jestesmy przy sygnaturze PECompact2.x
			mov [porownanie],eax
			invoke lstrcmp,porownanie,addr PEComp				;sprawdz czy jest PECompact
			.if !EAX
				invoke MessageBox,0,ADDR znalazlem,ADDR rozwalic,MB_ICONQUESTION + MB_YESNO		;pytaj
				.if eax==6		
					mov eax,1	;jezeli tak to kontynuuj 
				.else
					xor eax,eax	;jezeli nie to koniec
				.endif
				.break
			.else
				invoke MessageBox,0,ADDR bladPECompact,ADDR brak,MB_ICONWARNING	;nieznalazl
				xor eax,eax
				.break
			.endif
		.endif
		add edi,IMAGE_SECTION_HEADER
		dec ebx
	.endw
	Ret
SyganturaPeCompact EndP

SzukajOEP PROC

	mov eax,[pMemory]					;tutaj wskaznik do procesu
	add eax,[AddressOfEntryPoint]		;idz do Entry Point
	inc eax								;zwieksz o jeden
	mov ebx,[eax]						;pobierz to co mialo byc wrzucone do eax
	sub ebx,[ImageBase]					;odejmij od tego image base
	mov eax,pMemory						
	add eax,ebx							;teraz dodaj wartosc co miala byc w eax
	add eax,5							;idz za 1 komende
	mov ebx,eax							;wsadz to do ebx
	add ebx,[SizeOfImage]				;dodaj imagebase i teraz mozesz przystapic do szukania
	.while eax!=ebx
		.if dword ptr[eax]==0595F5E5Ah			;skok do OEP
			.if dword ptr[eax+4]==0E0FF5D5Bh
				add eax,6
				push eax
				sub eax,[pMemory]
				add eax,[ImageBase]
				mov [patchOEP],eax
				invoke SetBreakpoint,eax
				pop eax
				.break
			.endif
		.elseif dword ptr[eax]==890C4B8Bh		;szukaj magic call dla IAT
			.if dword ptr[eax+4]==0D7FF144eh
				add eax,7
				push eax
				sub eax,[pMemory]
				add eax,[ImageBase]
				mov [patchIAT],eax
				invoke SetBreakpoint,eax
				pop eax
			.endif
		.elseif dword ptr[eax]==00100068h		;petla do szukania rozmiaru virtual
			.if dword ptr[eax+4]==00473FF00h
				push eax
				dec eax
				sub eax,[pMemory]
				add eax,[ImageBase]
				mov [patchSize],eax
				invoke SetBreakpoint,eax
				pop eax
			.endif
		.elseif dword ptr[eax]==050F88B5Ah		;stawiamy breapoint za call edi
			inc eax
			push eax
			sub eax,[pMemory]
			add eax,[ImageBase]
			mov [patchWhere],eax				;to sie przyda do pozniejszego pobrania adresu zeby odbudowac IID
			invoke SetBreakpoint,eax
			pop eax
		.endif
		inc eax
	.endw
	Ret
SzukajOEP EndP

UsunBreakpoint PROC BaseAddress:DWORD,napraw:BYTE			;usuwamy breakpoint

	pushad
	mov context.ContextFlags, CONTEXT_i486 or CONTEXT_FULL
	invoke GetThreadContext,PI_.hThread,ADDR context
	dec context.regEip
	dec [BaseAddress]
	xor ebx,ebx
	lea ebx,[napraw]
	invoke WriteProcessMemory,PI_.hProcess,BaseAddress,ebx,1,0
	invoke ReadProcessMemory,PI_.hProcess,ImageBase,pMemory,SizeOfImage,0
	invoke SetThreadContext,PI_.hThread,ADDR context
	popad
	Ret
UsunBreakpoint EndP

SzukajIID PROC

	mov eax,[pMapVirtual]			;gdzie zaladowales
	mov ebx,context.regEdi			;call edi <-wartosc edi
	sub ebx,[where]					;odejmij od tego gdzie zalokowales
	mov edx,[sizeVirtual]			;przenies jaki rozmiar zaladowal
	sub edx,ebx						;odejmij rozmiar dzieki temu wiem ile przeszukac
	mov ebx,eax
	add ebx,edx
	.while eax!=ebx					;do ilu ma szukac
		.if dword ptr[eax]==08B909090h		;szukaj IID <- IMAGE_IMPORT_DESCRIPTOR
			.if dword ptr[eax+4]==0C985344Eh
				add eax,7
				sub eax,pMapVirtual
				add eax,context.regEdi
				mov [patchIID],eax
				invoke SetBreakpoint,EAX
				.break
			.endif
		.endif
		inc eax
	.endw
	Ret
SzukajIID EndP

Dump PROC

	mov edi,pMemory
	assume edi:ptr IMAGE_DOS_HEADER
	add edi,[edi].e_lfanew
	assume edi:ptr IMAGE_NT_HEADERS
	push [addressIID]			;popraw tablice importow
	pop [edi].OptionalHeader.DataDirectory[SIZEOF IMAGE_DATA_DIRECTORY].VirtualAddress
	mov eax,[edi].OptionalHeader.ImageBase
	sub [OEP],eax
	push OEP				;OEP
	pop [edi].OptionalHeader.AddressOfEntryPoint
	movzx eax,[edi].FileHeader.NumberOfSections
	mov [NumberOfSections],eax
	add edi,SIZEOF IMAGE_NT_HEADERS
	assume edi:ptr IMAGE_SECTION_HEADER
	xor ebx,ebx
	.while ebx!=[NumberOfSections]		;napraw sekcje
		lea eax,[edi].Name1
		.if dword ptr[eax]=='EDOC'		;czy sekcja code
			push [Characteristics]		;napraw sekcje
			pop[edi].Characteristics
		.endif
		push [edi].VirtualAddress
		pop [edi].PointerToRawData
		push [edi].Misc.VirtualSize
		pop [edi].SizeOfRawData
		add edi,SIZEOF IMAGE_SECTION_HEADER
		inc ebx
	.endw
	Ret
Dump EndP

Zapisz PROC

	lea eax,buffer
	invoke lstrlen,eax
	lea ebx,buffer
	add ebx,eax
	xor ecx,ecx
	.while eax!=0
		mov cl,byte ptr[ebx]
		.if cl==5Ch				;szukaj \
			.break
		.endif
		dec ebx
		dec eax
	.endw
	inc ebx						;teraz w ebx jest nasz plik
	mov eax,ebx
	invoke lstrcpy,eax,OFFSET unpacked	;teraz juz mam sciezke i plik
	INVOKE CreateFile,ADDR buffer,\		;stworz plik unpacked.exe
					GENERIC_READ OR GENERIC_WRITE,\
					FILE_SHARE_READ OR FILE_SHARE_WRITE,\
					NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,\
					NULL
	.if eax!=INVALID_HANDLE_VALUE			;sprawdz czy wszystko poszlo okej
		mov pFile,eax
		invoke WriteFile,pFile,pMemory,SizeOfImage,ADDR SizeReadWrite,NULL 		;wpisz proces do pliku
		invoke CloseHandle,pFile												;zamknij uczwyt do pliku
		invoke MessageBox,0,addr zrobione,addr ok,MB_OK+MB_ICONASTERISK			;wszystko poszlo okej
	.else
		invoke MessageBox,0,ADDR bladPlik,ADDr blad,MB_ICONERROR
	.endif
	Ret
Zapisz EndP

end start