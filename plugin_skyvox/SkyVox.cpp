#include "SkyVox.h"
#include<string>
#include<fstream>
#include <streambuf>
#include <vector>
#include <winsock.h>
#include <windows.h>
#include <iostream>
#include <stdio.h>
#include <stack> 

using namespace std;
//#pragma comment(lib, "ws2_32.lib")

#define PATH_PIPE "\\\\.\\pipe\\SkyVox"
#define BUFFER_SIZE 256

namespace SkyVox {
	static DWORD myThreadID;
	static HANDLE myHandle;
	static std::stack<string> stackMessage;
    static HANDLE mutexMessagesStack;

	static BSFixedString SkyPop(StaticFunctionTag *base) {
		string message = "";

		WaitForSingleObject(mutexMessagesStack, INFINITE);
		if (!stackMessage.empty()) {
			message = stackMessage.top();
			_MESSAGE("Send to Papyrus  -> %s", message);
			stackMessage.pop();
		}
		ReleaseMutex(mutexMessagesStack);

		return BSFixedString(message.c_str());
	}
	
	bool RegisterFuncs(VMClassRegistry* registry) {
		using namespace std;

		unsigned int myCounter = 0;
		myThreadID;
		mutexMessagesStack = CreateMutex(NULL, FALSE, NULL);
		myHandle = CreateThread(0, 0, pipeThread, &myCounter, 0, &myThreadID);

		registry->RegisterFunction(new NativeFunction0 <StaticFunctionTag, BSFixedString>("SkyPop", "SkyVoxScript", SkyPop, registry));

		return true;
	}

	DWORD WINAPI  pipeThread(LPVOID lpParameter) {
		_MESSAGE("Opning Pipe");

		HANDLE hPipe;
		char buffer[BUFFER_SIZE] = { 0 };
		DWORD dwRead;


		hPipe = CreateNamedPipe(TEXT(PATH_PIPE),
			PIPE_ACCESS_DUPLEX | PIPE_TYPE_BYTE | PIPE_READMODE_BYTE, 
			PIPE_WAIT,
			1,
			256,
			256,
			NMPWAIT_USE_DEFAULT_WAIT,
			NULL);
		while (hPipe != INVALID_HANDLE_VALUE)
		{
			if (ConnectNamedPipe(hPipe, NULL) != FALSE)   // wait for someone to connect to the pipe
			{
				if (ReadFile(hPipe, buffer, BUFFER_SIZE - 2, &dwRead, NULL) != FALSE)
				{
					buffer[dwRead] = '\0';
					WaitForSingleObject(mutexMessagesStack, INFINITE);
					if (dwRead > 2) {
						_MESSAGE("Pipe Read > %s", buffer);
						stackMessage.push(buffer);
						memset(&buffer, 0, BUFFER_SIZE);

					}
					ReleaseMutex(mutexMessagesStack);
				}
			}

			DisconnectNamedPipe(hPipe);
		}
		_MESSAGE("Pipe Closed");

		return 0;
	}

} 



