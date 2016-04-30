#include "skse/PapyrusNativeFunctions.h"

namespace SkyVox
{
	/**
	 * Papyrus function
	 * @return BSFixedString Return the content of the pipe
	 */
	BSFixedString SkyPop(StaticFunctionTag *base);

	DWORD WINAPI  pipeThread(LPVOID lpParameter);

	bool RegisterFuncs(VMClassRegistry* registry);
}