function onCreate()
	makeLuaSprite('bg', 'backgrounds/nevada1.5/bg', -450, -150)
	scaleObject('bg', 1.2, 1.2)

	if dadName == "TrickyPhase1.5" then
		makeLuaSprite('bg2', 'backgrounds/nevada1.5/bg2alt', -1100 - 800, -460 - 300)
	else
		makeLuaSprite('bg2', 'backgrounds/nevada1.5/bg2', -1100 - 800, -460 - 300)
	end
	scaleObject('bg2', 1.4, 1.4)

	addLuaSprite('bg', false)
	addLuaSprite('bg2', false)
end
