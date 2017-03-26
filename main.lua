local points = {
    { x = 150, y = 400, r = 8 },
    { x = 400, y = 200, r = 5 },
    { x = 650, y = 400, r = 8 }
}

local offset = {}
local hovered = nil
local dragging = nil
local curve = nil

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
    love.graphics.setColor(200, 200, 200, 70)
    for i = 1, #points-1 do
        love.graphics.line(points[i].x, points[i].y, points[i+1].x, points[i+1].y)
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

