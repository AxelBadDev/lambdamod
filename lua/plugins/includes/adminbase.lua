--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary {
  name = "Admin Base",
  description = "Basic admin interface",
  author = "AxelBadDev"
  version = LAMBDAMOD_VERSION,
  api = 13,
  url = "https://github.com/AxelBadDev/lambdamod"
}

function LIBRARY:ParseTargets( pArgs, pPlayer )
  return LibAdmin.ParseTargets( pArgs, pPlayer )
end  