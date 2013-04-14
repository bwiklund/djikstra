perlin = new ClassicalNoise()
recPerlin = (x,y,z,n) ->
  noise = 0
  for i in [0..n]
    s = Math.pow(2,i)
    noise += (perlin.noise(x*s,y*s,z*s)*0.5+0.5) / s / 2
  noise



class OurCell extends @djik.Cell
  init: ->
    ms = 0.03 
    @height = recPerlin(@x*ms,@y*ms,0,5)
    @height += 0.2
    @road = 0

  color: ->
    @height - @road

  cost: ->
    Math.pow(2,2+@height) - @road



$ ->

  width = 80
  cells = [0...width].map (y) -> [0...width].map (x)-> new OurCell(x,y)

  cq().framework(
    onStep: ->
      for row,y in cells
        for node,x in row
          node.road *= 0.995
          if node.path
            node.road += 0.01
            #node.cost += 0.01
          node.resetPathing()
      djik.solvePath(cells)

    onRender: ->
      scale = 5
      @clear('#333')
      for row,y in cells
        for node,x in row

          c = ~~ ( 255 * node.color() )
          color = if node.path then cq.color(0,0,0,1) else cq.color(c,c,c,1.0)
          #shade = cq.color(r,g,b,0.5)

          @save().scale(scale,scale)
          @fillStyle(color.toRgba()).fillRect x,y,0.98,0.98
          #@fillStyle(shade.toRgba()).fillRect x,y-c*30,1,4
          #@fillStyle(color.toRgba()).fillRect x,y-c*30,1,1
          @restore()

  ).appendTo("body")
