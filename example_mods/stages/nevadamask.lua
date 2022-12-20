function onCreate()
	makeLuaSprite('bg', 'backgrounds/nevadamask/bg', -1800, -860)
	scaleObject('bg', 1.4, 1.4)
	addLuaSprite('bg', false)
end

function onCreatePost()
	setProperty('gf.alpha', 0.25)
	setProperty('dad.alpha', 0.25)
	setProperty('iconP2.alpha', healthBarAlpha * 0.25)
end
