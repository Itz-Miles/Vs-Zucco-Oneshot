function onCreate()
	makeLuaSprite('back', 'bgschool/back', -1000, 150);
	scaleObject('back', 1.2, 1.2);
	addLuaSprite('back', false);
	
	
	makeLuaSprite('front', 'bgschool/front', -1000, 150);
	scaleObject('front', 1.2, 1.2);
	addLuaSprite('front', false);
	
	
	makeAnimatedLuaSprite('zucco', 'bgschool/zucco', -200, 550)
	luaSpriteAddAnimationByPrefix('zucco', 'idle', 'zucco', 24, true);
	scaleObject('zucco', 1.2, 1.2);
	addLuaSprite('zucco', false);

	makeLuaSprite('overlay', 'bgschool/overlay', -1000, 150);
	scaleObject('overlay', 1.2, 1.2);
	addLuaSprite('overlay', true);
	
	

	if not lowQuality then

	end

	
	close(true);
end