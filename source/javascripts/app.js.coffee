perlin = new ClassicalNoise()
recPerlin = (x,y,z,n) ->
  noise = 0
  for i in [0..n]
    s = Math.pow(2,i)
    noise += (perlin.noise(x*s,y*s,z*s)*0.5+0.5) / s / 2
  noise



class CityCell extends @djik.Cell
  init: ->
    ms = 0.03 
    @height = recPerlin(@x*ms,@y*ms,0,5)
    @road = 0

  color: ->
    @height - @road

  cost: ->
    Math.max 0, @height - @road



$ ->

  width = 80
  scale = 5
  cells = [0...width].map (y) -> [0...width].map (x) -> new CityCell(x,y)

  cq(width*scale,width*scale).framework(

    onStep: ->
      for i in [0..0]
        for row,y in cells
          for node,x in row
            node.road *= 0.997
            if node.path
              node.road += 0.013
              #node.cost += 0.01
            node.resetPathing()



        rander = -> parseInt Math.random()*width
        start = cells[rander()][rander()]
        dest = cells[rander()][rander()]
        new djik.Solver(cells,start,dest)

    onRender: ->
      @clear('#333')
      for row,y in cells
        for node,x in row
          c = ~~ ( 255 * node.color() )
          color = if node.path then cq.color(0,0,0,1) else cq.color(c,c,c,1.0) #
          @save()
          @scale(scale,scale)
          @fillStyle(color.toRgba()).fillRect x,y,0.98,0.98
          @restore()

  ).appendTo("body")
