function onCreate()
	makeLuaSprite('back', 'back', -1000, 150);
	scaleObject('back', 1.2, 1.2);
	addLuaSprite('back', true);
	
	
	makeLuaSprite('front', 'front', -1000, 150);
	scaleObject('front', 1.2, 1.2);
	addLuaSprite('front', true);
	
	
	makeAnimatedLuaSprite('zucco', 'zucco', -200, 550)
	luaSpriteAddAnimationByPrefix('zucco', 'idle', 'zucco', 24, true);
	scaleObject('zucco', 1.2, 1.2);
	addLuaSprite('zucco', true);

	makeLuaSprite('overlay', 'overlay', -1000, 150);
	scaleObject('overlay', 1.2, 1.2);
	addLuaSprite('overlay', true);
	
	

	if not lowQuality then

	end

	
	close(true);
end