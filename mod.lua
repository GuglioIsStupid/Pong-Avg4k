function create()
    dofile(formCompletePath("spriteFrame.lua"))

    SpriteFrame.create() -- this inits the classes

    -- Pong
    createSprite("ball", "ball", math.floor(1280/2-25), math.floor(720/2-25))

    ballStuff = {
        x = 0,
        y = 0,
        DX = math.random(2) == 1 and 4 or -4,
        DY = math.random(-4, 4)
    }

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

    ballStuff.direction = math.random(0, 360)
    ballStuff.directiony = math.random(0, 360)

    shizLoaded = true

    score = 0
    score2 = 0

    scoreTXT = Text:new('scoretxt', 'arial', 'Score: ' .. score, 24, 200, 25)
    scoreTXT2 = Text:new('scoretxt2', 'arial', 'Score: ' .. score2, 24, 1000, 25)

    SCREEN_X_0 = -1280/2
    SCREEN_X_1280 = 1280/2

    DONTPRESS = Text:new('dontpress', 'arial', 'DONT PRESS ANYTHING', 24, 520, 400)
end

function update(beat)
    SpriteFrame.update()
    globalBeat = beat

    if beat > 0 then 
        DONTPRESS.text = ""
        DONTPRESS.x = -400
        DONTPRESS.y = -400
    end

    -- Ball

    if shizLoaded then
        --ballStuff.x = ballStuff.x + ballStuff.ballDX
        --ballStuff.y = ballStuff.y + ballStuff.ballDY

        ballStuff.x = ballStuff.x + ballStuff.DX
        ballStuff.y = ballStuff.y + ballStuff.DY

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

        activateSpriteMod("ball", "movex", beat, 0, "linear", ballStuff.x)
        activateSpriteMod("ball", "movey", beat, 0, "linear", ballStuff.y)

        -- Paddle
        if paddleStuff.y >= (720)-180 then
            paddleStuff.y = (720)-180
        end

        if paddleStuff.y <= 0 then
            paddleStuff.y = 0
        end

        activateSpriteMod("paddle", "movey", beat, 0, "linear", paddleStuff.y)

        -- Paddle 2

        if paddleStuff2.y >= (720)-180 then
            paddleStuff2.y = (720)-180
        end

        if paddleStuff2.y <= 0 then
            paddleStuff2.y = 0
        end

        activateSpriteMod("paddle2", "movey", beat, 0, "linear", paddleStuff2.y)

        -- Collision
        -- since paddles are just 720, and the ball is 720/2,
        -- its all weird........
        -- so just add 720/2 to the ball's y value

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
end

function key_pressed(id)
    id = tonumber(id) or 1
    if shizLoaded then
        if id then 
            consolePrint("Key pressed: " .. tostring(id))
        end
        if id == 1073741906 then -- up arrow
            paddleStuff2.y = paddleStuff2.y - paddleStuff2.speed * 4
        elseif id == 1073741905 then -- down arrow
            paddleStuff2.y = paddleStuff2.y + paddleStuff2.speed * 4
        elseif id == 119 then -- w
            paddleStuff.y = paddleStuff.y - paddleStuff.speed * 4
        elseif id == 115 then -- s
            paddleStuff.y = paddleStuff.y + paddleStuff.speed * 4
        end

        activateSpriteMod("paddle", "movey", globalBeat, 0, "linear", paddleStuff.y)
    end
end