local love = require"love"
function love.conf(app)
    app.window.width = 1920
    app.window.height = 1020
    app.window.title = "Asteroids"
    app.window.icon = "mark.jpg"
end