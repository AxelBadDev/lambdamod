HUD = {
	PRINTNOTIFY = 1,
	PRINTCONSOLE = 2,
	PRINTTALK = 3,
	PRINTCENTER = 4
}

-- Another GMED Compatibility lololololol
-- why? why not. if you don't like this, go ahead and try to fight me bitch
for key, value in pairs(HUD) do
	_G["HUD_" .. key] = value
end