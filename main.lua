--[[
    GD50
    Match-3 Remake

    Original Author: Colton Ogden
    cogden@cs50.harvard.edu

    Match-3 has taken several forms over the years, with its roots in games
    like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
    version of this game, as well as Candy Crush from 2012, though all these
    games owe Shariki, a DOS game from 1994, for their inspiration.

    The goal of the game is to match any three tiles of the same variety by
    swapping any two adjacent tiles; when three or more tiles match in a line,
    those tiles add to the player's score and are removed from play, with new
    tiles coming from the ceiling to replace them.

    As per previous projects, we'll be adopting a retro, NES-quality aesthetic.

    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (awesome track):
    http://freemusicarchive.org/music/RoccoW/

    Cool texture generator, used for background:
    http://cpetry.github.io/TextureGenerator-Online/
]]

--initialize nearest neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

--all required assets are in the "dependencies.lua" file
require 'src/Dependencies'

--physical screen
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--background texture's scroll speed
BACKGROUND_SCROLL_SPEED = 88

function love.load(  )

    --window title
    love.window.setTitle('Match 3')

    --RNG seed
    math.randomseed(os.time())

    --init virtual resolution using push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    gSounds.music:setLooping(true)
    gSounds.music:play()

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlatState() end,
        ['game-over'] = function() return GameOverState() end
    }

    gStateMachine:change('start')

    --background scrolling tracker
    backgroundX = 0

    --input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    --add keys pressed this frame to the key table
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.wasPressed[key] then
        return true
    else
        return false
    end
end

function love.update( dt )
    
    --scroll background regardless of state
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt

    --reset to 0 once image finishes scrolling
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}

end

function love.draw(  )
    push:start()

    --scrolling BG stays in every state
    love.graphics.draw(gTextures.background, backgroundX, 0)

    --render based on state machine parameters
    gStateMachine:render()

    push:finish()
end