perlin = new ClassicalNoise()

$ ->


  w = h = 50
  map = []
  scale = 10



  cq().framework(
    onStep: ->
    onRender: ->
      width = 50
      cells = [0...width].map (y) -> [0...width].map (x)-> 
        coast = 120
        cell = new @djik.Cell(x,y)# oceanic
        noise = 0.7*(perlin.noise(1+x*0.2,1+y*0.2,0)*0.5+0.5)
        noise += 1.3*(perlin.noise(1+x*0.018,1+y*0.016,0)*0.5+0.5)
        noise /= 2
        cost = 10 + 240*noise
        if coast < cost < 140
          cost = coast
        if cost < coast
          safeness = (cost-coast)/coast
          cost = 40 - safeness * 30
        
        # streets
        # cost = 2000
        # if x%6 == 0 then cost = 80
        # if y%6 == 0 then cost = 80
        # if y%6 == 0 and x%6 == 0 then cost = 150
        # if y == 20 then cost = 30
        # if cost == 2 then if Math.random() < 0.1 then cost = 10000
        
        cell.cost = cost
        cell

      cells = window.djik.solvePath(cells)
      @clear('#333')
      for row,y in cells
        for node,x in row
          color = if node.path then "#f9c" else cq.color(0,0,0,node.cost / 300).toRgba()
          @fillStyle color
          @save().scale(scale,scale)
          @fillRect y,x,1,1
          @restore()

  ).appendTo("body")