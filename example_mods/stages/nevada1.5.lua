function onCreate()
	makeLuaSprite('bg', 'backgrounds/nevada1.5/bg', -450, -150)
	scaleObject('bg', 1.2, 1.2)
	addLuaSprite('bg', false)

	if dadName == "TrickyPhase1.5" then
		makeLuaSprite('bg2', 'backgrounds/nevada1.5/bg2alt', -1900, -760)
	else
		makeLuaSprite('bg2', 'backgrounds/nevada1.5/bg2', -1900, -760)
	end
	scaleObject('bg2', 1.4, 1.4)
	addLuaSprite('bg2', false)
end
