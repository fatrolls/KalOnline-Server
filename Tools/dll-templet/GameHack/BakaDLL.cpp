#include <windows.h>

// basic file operations
#include <iostream>
#include <fstream>
#include <stdio.h>
// xxx
using namespace std;
#pragma pack(1)

#define ASM			void __declspec(naked)
#define	EXPORT		__declspec(dllexport) __cdecl
#define	THREAD		DWORD WINAPI
#define Naked __declspec( naked )
#define INST_NOP 0x90
#define INST_CALL 0xe8
#define INST_JMP 0xe9
#define INST_BYTE 0x00
#define SHORT_JZ 0x74

LPVOID MemcpyEx(DWORD lpDest, DWORD lpSource, int len)
{
	DWORD oldSourceProt,oldDestProt=0;
	 VirtualProtect((LPVOID)lpSource,len,PAGE_EXECUTE_READWRITE,&oldSourceProt);
 	  VirtualProtect((LPVOID)lpDest,len,PAGE_EXECUTE_READWRITE,&oldDestProt);
	   memcpy((void*)lpDest,(void*)lpSource,len);
	  VirtualProtect((LPVOID)lpDest,len,oldDestProt,&oldDestProt);
	 VirtualProtect((LPVOID)lpSource,len,oldSourceProt,&oldSourceProt);
	return (LPVOID)lpDest;
};

DWORD Intercept(int instruction, DWORD lpSource, DWORD lpDest, int len)
{
	
//	if(!lpDest || !lpSource || len <= 4) //ich brauch auch 2bytes
//		return FALSE;                    //lpDest = neu_adresse for SHOT_JZ
    DWORD realtarget;
    LPBYTE buffer = new BYTE[len];
	
	memset(buffer,0x90,len); //Fill out with nops

	if (instruction != INST_NOP && len >= 5)
	{
	buffer[(len-5)] = instruction; //Set the start of the call @ the end
	//so we can return normally if the code is unpatched (unhook patches while patchfunction is running)
	DWORD dwJMP = (DWORD)lpDest - (lpSource + 5 + (len-5));
	memcpy(&realtarget,(void*)(lpSource+1),4);
	realtarget = realtarget+lpSource+5;
	memcpy(buffer + 1 + (len-5),&dwJMP,4);
	}
	if (instruction == SHORT_JZ)
	{
		buffer[0]=instruction;
		buffer[1]=(BYTE)lpDest;
	}
	if (instruction == INST_BYTE)
	{
		buffer[0]=(BYTE)lpDest;
	}
	MemcpyEx(lpSource, (DWORD) buffer, len);// Call to intercept
	delete[] buffer;
	return realtarget;
}



BOOL WINAPI DllMain(HINSTANCE hInst,DWORD reason,LPVOID)
	{
	if (reason == DLL_PROCESS_ATTACH)
		{
		  //DLL LOADING
		}
	if (reason == DLL_PROCESS_DETACH)
		{
		 //DLL UNLOADING
		}

	return 1;
	}