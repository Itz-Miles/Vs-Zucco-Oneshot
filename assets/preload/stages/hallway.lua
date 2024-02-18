function onCreate()
	--add these later
		makeAnimatedLuaSprite('zucco', 'zucco', -450, 430)
		luaSpriteAddAnimationByPrefix('zucco', 'idle', 'zucco', 24, true);
		scaleObject('zucco', 1.2, 1.2);
		addLuaSprite('zucco', false);
	
		makeLuaSprite('light', 'light', -2155, -150)
		scaleObject('light', 2.412, 2.028)
		addLuaSprite('light', true)
		setProperty('light.origin.x', 0)
		setProperty('light.origin.y', 0)
		setBlendMode('light', "add")
		addLuaSprite('light', true);	
		close(true);
	end