function onCreate()

	makeAnimatedLuaSprite('zucco', 'zucco', -450, 430)
	luaSpriteAddAnimationByPrefix('zucco', 'idle', 'zucco', 24, true);
	scaleObject('zucco', 1.2, 1.2);
	addLuaSprite('zucco', true);

	makeLuaSprite('overlay', 'overlay', -1500, 50);
	scaleObject('overlay', 1.2, 1.2);
	addLuaSprite('overlay', true);
	
	

	if not lowQuality then

	end

	
	close(true);
end