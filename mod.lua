function create()
    dofile(formCompletePath("spriteFrame.lua"))

    SpriteFrame.create() -- this inits the classes

    -- Pong
    createSprite("ball", "ball", math.floor(1280/2-25), math.floor(720/2-25)) -- Make our ball in the middle of the screen

    ballStuff = {
        x = 0,
        y = 0,
        DX = math.random(2) == 1 and 100 or -100,
        DY = math.random(-100, 100)
    } -- Define our balls variables

    -- Make the paddles and define their variables
    createSprite("paddle", "paddle", 0, 0)
    createSprite("paddle", "paddle2", math.floor(1280-15), 0)

    paddleStuff = {
        x = 0,
        y = 0,
        speed = 10,
    }

    paddleStuff2 = {
        x = 0,
        y = 0,
        speed = 10,
    }

    shizLoaded = true -- idk if this actually worked or not, but it's here just in case

    -- Set our players scores and make them into text objects
    score = 0
    score2 = 0

    scoreTXT = Text:new('scoretxt', 'arial', 'Score: ' .. score, 24, 200, 25)
    scoreTXT2 = Text:new('scoretxt2', 'arial', 'Score: ' .. score2, 24, 1000, 25)

    SCREEN_X_0 = -1280/2
    SCREEN_X_1280 = 1280/2

    DONTPRESS = Text:new('dontpress', 'arial', 'DONT PRESS ANYTHING', 24, 520, 400)

    -- Deltatime

    time = 0
    lastTime = 0
    deltaTime = 0
end

function update(beat)
    time = getTime()
    deltaTime = time - lastTime
    SpriteFrame.update()
    globalBeat = beat -- make the beat global so we can use it in other functions, ended up unused... For now...

    if beat > 0 then -- text, tells the user to not touch a key cuz it will break (and idk why, avg4k just dies lmao)
        DONTPRESS.text = ""
        DONTPRESS.x = -400
        DONTPRESS.y = -400
    end

    if shizLoaded then
        -- Ball
        ballStuff.x = ballStuff.x + ballStuff.DX * deltaTime
        ballStuff.y = ballStuff.y + ballStuff.DY * deltaTime

        if ballStuff.x >= 1280/2+25 then
            ballStuff.x = 1279/2
            ballStuff.DX = -ballStuff.DX
            score = score + 1
            scoreTXT.text = 'Score: ' .. score
        end

        if ballStuff.x <= -(1300/2) then
            ballStuff.x = -(1279/2)
            ballStuff.DX = -ballStuff.DX
            score2 = score2 + 1
            scoreTXT2.text = 'Score: ' .. score2
        end

        if ballStuff.y >= (720/2)-50 then
            ballStuff.y = (720/2)-51
            ballStuff.DY = -ballStuff.DY
        end

        if ballStuff.y <= -(720/2)+15 then
            ballStuff.y = -(720/2)+15
            ballStuff.DY = -ballStuff.DY
        end

        -- Set the balls position
        activateSpriteMod("ball", "movex", beat, 0, "linear", ballStuff.x)
        activateSpriteMod("ball", "movey", beat, 0, "linear", ballStuff.y)

        -- Paddle
        if paddleStuff.y >= (720)-180 then
            paddleStuff.y = (720)-180
        end

        if paddleStuff.y <= 0 then
            paddleStuff.y = 0
        end

        -- Set the paddles position
        activateSpriteMod("paddle", "movey", beat, 0, "linear", paddleStuff.y)

        -- Paddle 2

        if paddleStuff2.y >= (720)-180 then
            paddleStuff2.y = (720)-180
        end

        if paddleStuff2.y <= 0 then
            paddleStuff2.y = 0
        end

        -- Set the second paddles position
        activateSpriteMod("paddle2", "movey", beat, 0, "linear", paddleStuff2.y)

        -- Collision
        -- since paddles y works like 720 and the balls y works like 720/2...
        -- its all weird...
        -- so ig just add 720/2 to the ball's y value lmao

        if ballStuff.x >= -(1280/2) and ballStuff.x <= -(1280/2)+15 then
            if ballStuff.y+720/2 >= paddleStuff.y and ballStuff.y+720/2 <= paddleStuff.y+180 then
                ballStuff.DX = -ballStuff.DX
                ballStuff.DY = math.random(-4, 4)
            end
        end

        if ballStuff.x-25 <= 1280/2 and ballStuff.x-25 >= 1280/2-15 then
            if ballStuff.y+720/2 >= paddleStuff2.y and ballStuff.y+720/2 <= paddleStuff2.y+180 then
                ballStuff.DX = -ballStuff.DX
                ballStuff.DY = math.random(-4, 4)
            end
        end
    end

    lastTime = time
end

function key_pressed(id)
    id = tonumber(id) or 1 -- Make sure id isn't nil so it doesn't try to compare it to a number and break
    if shizLoaded then
        -- W and S controls player 1
        -- Up and Down arrow controls player 2
        if id == 1073741906 then -- up arrow
            paddleStuff2.y = paddleStuff2.y - paddleStuff2.speed * 4
        elseif id == 1073741905 then -- down arrow
            paddleStuff2.y = paddleStuff2.y + paddleStuff2.speed * 4
        elseif id == 119 then -- w
            paddleStuff.y = paddleStuff.y - paddleStuff.speed * 4
        elseif id == 115 then -- s
            paddleStuff.y = paddleStuff.y + paddleStuff.speed * 4
        end
    end
end