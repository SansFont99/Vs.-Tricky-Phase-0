function onCreate()
	makeLuaSprite('bg', 'backgrounds/nevadaantipathy/bg', -575, -150);

	makeLuaSprite('bg2', 'backgrounds/nevadaantipathy/bg2', -1100 - 800, -460 - 300);
	scaleObject('bg2', 1.4, 1.4);

	addLuaSprite('bg', false);
	addLuaSprite('bg2', false);

	close(true);
end
