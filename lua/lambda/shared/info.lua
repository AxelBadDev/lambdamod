--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Legacy Infomation
--
--============================================================================--

LambdaMod["INFO"] = 
{
	_VERSION     = LambdaMod["VERSION"] or "fallback-alpha",  --"1.5",
	_BRANCH      = LambdaMod["BRANCH"] or "Unknown",
	_DEVELOPMENT = LambdaMod["DEVELOPMENT"] or true,
	_BUILD       = LambdaMod["BUILD"] or "0",

	_BUILD_DATE  = string.format( 
                        "%s %s %s",	
                        tostring(( LambdaMod["BUILD_DATA"].month or "Jan" )), 
                        tostring(( LambdaMod["BUILD_DATA"].day or "1" )), 
                        tostring(( LambdaMod["BUILD_DATA"].year or "1970" )) 
                   )
}