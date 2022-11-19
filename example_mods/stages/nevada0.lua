function onCreate()
	makeLuaSprite('bg', 'backgrounds/nevada0/bg', -350 - 700, -300 - 400)

	makeLuaSprite('bg2', 'backgrounds/nevada0/bg2', -1100 - 700, -460 - 400)
	scaleObject('bg2', 1.4, 1.4)

	addLuaSprite('bg', false)
	addLuaSprite('bg2', false)
end
