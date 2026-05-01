---@class LambdaMod
LambdaMod["VERSION"] = "3.0"
LambdaMod["BRANCH"] = "main"
LambdaMod["BUILD"] = "0301"
LambdaMod["GAME_VERSION"] = "1.1"
LambdaMod["DEVELOPMENT"] = true

_G["LAMBDAMOD_VERSION"] 	 = LambdaMod.VERSION
_G["LAMBDAMOD_BRANCH"] 	  = LambdaMod.BRANCH
_G["LAMBDAMOD_BUILD"] 	   = LambdaMod.BUILD
_G["LAMBDAMOD_GAME_VERSION"] = LambdaMod.GAME_VERSION

LambdaMod["MONTHS"] = {
	"Jan",
	"Feb",
	"Mar",
	"Apr",
	"May",
	"Jun",
	"Jul",
	"Aug",
	"Sep",
	"Oct",
	"Nov",
	"Dec"
}

LambdaMod.ConsoleColor = 
{
    CONSOLE_DEFAULT = 0,
    CONSOLE_CYAN = 1,
    CONSOLE_WARNING = 2,
    CONSOLE_ERROR = 3,
    CONSOLE_LUAPLUS = 4,
    CONSOLE_GREEN = 5,
    CONSOLE_BLUE = 6
}

LambdaMod["BUILD_DATA"] = {
	day = "1",
	month = "May",
	year = "2026"
}

---@class COLOR
LambdaMod["COLOR"] = {
    CYAN    = Color(0, 255, 255, 255),
    WARNING = Color(255, 255, 0, 255),
    RED     = Color(255, 0, 0, 255),
    LUAPLUS = Color(255, 120, 255, 255),
    GREEN   = Color(0, 255, 0, 255),
    BLUE    = Color(0, 100, 255, 255)
}

    
---@class _COLOR : COLOR
LambdaMod["_COLOR"] = LambdaMod["COLOR"]

LambdaMod.ExposeToGlobal( LambdaMod.ConsoleColor )