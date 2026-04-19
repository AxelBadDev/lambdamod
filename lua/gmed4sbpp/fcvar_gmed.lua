local FCVAR = FCVAR or _E.FCVAR

-- Partial GMOD/GMED Implemention

for key, value in pairs(FCVAR) do
	_G["FCVAR_" .. key] = value
end