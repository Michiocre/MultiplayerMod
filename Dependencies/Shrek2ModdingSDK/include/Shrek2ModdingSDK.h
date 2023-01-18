/*
	Copyright (c) 2021 Kevin J. Petersen https://github.com/kevinjpetersen/
*/

#pragma once
#ifndef SH_INCLUDES
#define SH_INCLUDES
#include <windows.h>
#include <iostream>
#include <filesystem>
#include <list>
#include <vector>
#include <fstream>
#include <ppl.h>
#include <ppltasks.h>
#include <agents.h>
#include <streambuf>
#include <map>
#include <string>
#include <regex>
#include <chrono>
#include <ctime>
#include <cmath>
#include "json.hpp"

using json = nlohmann::json;

#include "Shrek2Logging.h"
#include "Shrek2Fonts.h"
#include "Shrek2Storage.h"
#include "Shrek2Config.h"
#include "Shrek2TimerLib.h"
#include "Shrek2Timer.h"
#include "Shrek2Maps.h"
#include "Shrek2Rect.h"
#include "Shrek2Position.h"
#include "Shrek2Vector2.h"
#include "Shrek2Vector3.h"
#include "Shrek2Trigger.h"
#include "Shrek2Triggers.h"
#include "Shrek2Input.h"
#include "Shrek2StaticVars.h"
#include "Shrek2Utils.h"
#include "Shrek2Memory.h"
#include "Shrek2Pointers.h"
#include "Shrek2Events.h"
#include "Shrek2Functions.h"
#include "Shrek2Sound.h"
#include "Shrek2ActorTypes.h"
#include "Shrek2ActorModels.h"
#include "Shrek2ActorList.h"
#include "Shrek2Inventory.h"

using namespace Concurrency;
#include "Shrek2.h"
namespace fs = std::filesystem;

#endif