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
    # cost *= (perlin.noise(1+x*ms*3,1+y*ms*3,10)*0.5+0.5)
    @height += 0.2

  cost: ->
    @height

$ ->

  width = 80
  cells = [0...width].map (y) -> [0...width].map (x)-> new OurCell(x,y)

  cq().framework(
    onStep: ->
      for row,y in cells
        for node,x in row
          if node.path
            node.height *= 0.99
            #node.cost += 0.01
          node.resetPathing()
      djik.solvePath(cells)

    onRender: ->
      scale = 5
      @clear('#333')
      for row,y in cells
        for node,x in row
          g = ~~( 255 * node.cost() )
          color = if node.path then "#f9c" else cq.color(g,g,g,1.0).toRgba()
          @fillStyle color
          @save().scale(scale,scale)
          @fillRect y,x,1,1
          @restore()

  ).appendTo("body")