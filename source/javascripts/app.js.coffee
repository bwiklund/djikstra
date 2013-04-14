perlin = new ClassicalNoise()

$ ->

  width = 80
  scale = 5

  recPerlin = (x,y,z,n) ->
    noise = 0
    for i in [0..n]
      s = Math.pow(2,i)
      noise += (perlin.noise(x*s,y*s,z*s)*0.5+0.5) / s / 2
    noise


  cells = [0...width].map (y) -> [0...width].map (x)->
    #oceanic 
    # coast = 120
    # cell = new @djik.Cell(x,y)# oceanic
    # noise = 0.7*(perlin.noise(1+x*0.2,1+y*0.2,0)*0.5+0.5)
    # noise += 1.3*(perlin.noise(1+x*0.018,1+y*0.016,0)*0.5+0.5)
    # noise /= 2
    # cost = 10 + 240*noise
    # if coast < cost < 140
    #   cost = coast
    # if cost < coast
    #   safeness = (cost-coast)/coast
    #   cost = 40 - safeness * 30
    
    # streets
    # cost = 2000
    # if x%6 == 0 then cost = 80
    # if y%6 == 0 then cost = 80
    # if y%6 == 0 and x%6 == 0 then cost = 150
    # if y == 20 then cost = 30
    # if cost == 2 then if Math.random() < 0.1 then cost = 10000


    cell = new @djik.Cell(x,y)

    ms = 0.03 
    cost = recPerlin(x*ms,y*ms,0,5)
    # cost *= (perlin.noise(1+x*ms*3,1+y*ms*3,10)*0.5+0.5)
    cost += 0.2
    # cost = 0.5
    cell.cost = cost
    cell


  cq().framework(
    onStep: ->
      for row,y in cells
        for node,x in row
          if node.path
            node.cost *= 0.99
            #node.cost += 0.01
          node.resetPathing()
      djik.solvePath(cells)

    onRender: ->

      @clear('#333')
      for row,y in cells
        for node,x in row
          g = ~~( 255 * node.cost )
          color = if node.path then "#f9c" else cq.color(g,g,g,1.0).toRgba()
          @fillStyle color
          @save().scale(scale,scale)
          @fillRect y,x,1,1
          @restore()

  ).appendTo("body")