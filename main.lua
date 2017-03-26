local points = {
    { x = 150, y = 400, r = 5 },
    { x = 400, y = 200, r = 3 },
    { x = 650, y = 400, r = 5 }
}

local offset = {}
local hovered = nil
local dragging = nil
local curve = nil
local timer = 0

function dashLine( p1, p2, dash, gap )
   local dy, dx = p2.y - p1.y, p2.x - p1.x
   local an, st = math.atan2( dy, dx ), dash + gap
   local len = math.sqrt( dx*dx + dy*dy )
   local nm	= ( len - dash ) / st
   love.graphics.push()
      love.graphics.translate( p1.x, p1.y )
      love.graphics.rotate( an )
      for i = 0, nm do
         love.graphics.line( i * st, 0, i * st + dash, 0 )
      end
      love.graphics.line( nm * st, 0, nm * st + dash,0 )
   love.graphics.pop()
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function love.load()
    love.graphics.setBackgroundColor(255, 250, 240)
    calcCurve()
end

function calcCurve()
    local p = {}
    for _, point in pairs(points) do
        table.insert(p, point.x)
        table.insert(p, point.y)
    end
    curve = love.math.newBezierCurve(p)
end

function love.mousepressed(x, y, button)
    if button == 1 and hovered then
        dragging = hovered
        offset.x = x - dragging.x
        offset.y = y - dragging.y
        calcCurve()
    end
end

function love.update(dt)
    timer = timer + 0.05
    points[2].y = lerp(400, 600, math.sin(timer))
    calcCurve()
end

function love.mousereleased(x, y, button)
    if button == 1 and dragging then
        dragging = nil
    end
end

function love.mousemoved(x, y)
    if dragging then
        dragging.x = x - offset.x
        dragging.y = y - offset.y
        calcCurve()
    else
        hovered = nil
        for _, p in pairs(points) do
            local dist = math.sqrt((x - p.x) * (x - p.x) + (y - p.y) * (y - p.y))
            if dist <= p.r then 
                hovered = p 
            end
        end
    end
end

function love.draw()
    -- lines
    love.graphics.setColor(200, 200, 200, 120)
    for i = 1, #points-1 do
        dashLine(points[i], points[i+1], 5, 5)
    end

    -- rendered curve
    love.graphics.setColor(178, 34, 34)
    love.graphics.line(curve:render(5))

    -- control points
    if #points > 2 then
        love.graphics.setColor(132, 112, 255)
        for i = 2, #points-1 do
            love.graphics.circle('fill', points[i].x, points[i].y, points[i].r)
        end
    end

    -- points
    love.graphics.setColor(151, 151, 151)
    love.graphics.circle('fill', points[1].x, points[1].y, points[1].r)
    love.graphics.circle('fill', points[#points].x, points[#points].y, points[#points].r)

    -- hovered point
    if hovered then
        love.graphics.setColor(0, 0, 0, 50)
        love.graphics.circle('line', hovered.x, hovered.y, hovered.r + 2)
    end

end

