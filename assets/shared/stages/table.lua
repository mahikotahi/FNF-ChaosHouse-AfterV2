function onCreate()
    makeLuaSprite('buckmock', 'buckmock', 0,0);
    scaleObject("buckmock", 10.0, 10.0)
    screenCenter("buckmock")
    --addLuaSprite('buckmock');

    makeLuaSprite('bfbod', 'Boyfriend Body', defaultBoyfriendX + 200,defaultBoyfriendY + 300);
    scaleObject("bfbod", 1.0, 1.0)
    addLuaSprite('bfbod');

    makeLuaSprite('Table', 'Table', 0, 460);
    scaleObject("Table", 10.0, 4.0)
    screenCenter("Table", 'x')
    addLuaSprite('Table', true);

    --doTweenAlpha('hudFunne', 'camHUD', 0, 0.9, 'linear')

end