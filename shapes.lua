-- shapes.lua
-- geometric shapes: point, circle, line, polygon (closed), polyline (open)

function makePoint ( inX, inY )
   return { shape="point", point= {x= inX, y= inY} }
end

function makeLine ( p1, p2 )
   return { shape="line", points= {p1, p2} }
end

function makePolygon ( points )
   return { shape="polygon", points= points}
end

function makePolyline ( points )
   return { shape="polyline", points= points }
end

function makeCircle ( center, radius )
   return { shape="circle", center= center, radius= radius}
end

function shapeToString ( inShape )
--   p ( 'shapeToString begin')
   s = ""
   if inShape ~= nil then
      if inShape.shape then
	 if inShape.shape == 'line' then
	    local p1 = inShape.points[1].point
	    local p2 = inShape.points[2].point
	    s = "line ".. p1.x.. ','.. p1.y.. ' '.. p2.x.. ','.. p2.y
	 elseif inShape.shape == 'point' then
	    s = "point ".. inShape.point.x.. ','.. inShape.point.y
	 elseif inShape.shape == 'polyline' then
	    local pts= inShape.points
	    s = 'polygon '
	    for i=1,#pts do
	       s = s.. pts[i].point.x.. ','.. pts[i].point.y.. ' '
	    end
	 elseif inShape.shape == 'polygon' then
	    local pts= inShape.points
	    s = 'polyline '
	    for i=1,#pts do
	       s = s.. pts[i].point.x.. ','.. pts[i].point.y.. ' '
	    end
	 elseif inShape.shape == 'circle' then
	    local pt= inShape.center.point
	    s= 'circle '.. pt.x.. ','.. pt.y.. ' radius '.. inShape.radius
	 end
      end
   end
   return s
end


function scaleMetersToLongLat ( shape )
end
