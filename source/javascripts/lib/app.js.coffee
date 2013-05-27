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
    Math.max 0.00001, @height - @road



class CitySimulator
  constructor: (@width) ->
    @cells = [0...@width].map (y) => [0...@width].map (x) -> new CityCell(x,y)

  step: ->
    for row,y in @cells
      for node,x in row
        node.road *= 0.997
        if node.path
          node.road += 0.013
          #node.cost += 0.01
        node.resetPathing()

    randIndex = => Math.floor Math.random()*@width
    start = @cells[randIndex()][randIndex()]
    dest = @cells[randIndex()][randIndex()]
    new djik.Solver(@cells,start,dest)



$ ->

  city = new CitySimulator 80
  drawScale = 5


  cq(city.width*drawScale,city.width*drawScale).framework(

    onStep: ->
      city.step()

    onRender: ->
      @clear('#333').save().scale(drawScale,drawScale)
      for row,y in city.cells
        for node,x in row
          c = ~~ ( 255 * node.color() )
          c = Math.min 255, Math.max 0, c
          color = if node.path then cq.color([0,0,0,1]) else cq.color([c,c,c,1.0]) #    
          @fillStyle(color.toHex()).fillRect x,y,0.98,0.98
      @restore()

  ).appendTo("body")
