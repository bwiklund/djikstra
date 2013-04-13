

perlin = new ClassicalNoise()

class Cell
  constructor: (@x,@y)->
    @cost = 0
    @score = Infinity
    @done = false

  label: ->
    ""+(parseInt(@cost)||".")



coast = 120



@pathfinder = {}
@pathfinder.solve = ->
  width = 30
  cells = [0...width].map (y) -> [0...width].map (x)-> 
    cell = new Cell(x,y)
    # oceanic
    ###
    noise = 0.7*(perlin.noise(1+x*0.2,1+y*0.2,0)*0.5+0.5)
    noise += 1.3*(perlin.noise(1+x*0.018,1+y*0.016,0)*0.5+0.5)
    noise /= 2
    cost = 10 + 240*noise
    if coast < cost < 140
      cost = coast
    if cost < coast
      safeness = (cost-coast)/coast
      cost = 40 - safeness * 30
    ###
    # streets
    cost = 2000
    if x%6 == 0 then cost = 80
    if y%6 == 0 then cost = 80
    if y%6 == 0 and x%6 == 0 then cost = 150
    if y == 20 then cost = 30
    if cost == 2 then if Math.random() < 0.1 then cost = 10000
    
    cell.cost = cost
    cell


  # $scope.style = (cell) ->
  #   style = ""
  #   style += "color: rgba(0,#{parseInt(cell.cost-10)},0,1);"
  #   style += "background: rgba(0,#{parseInt(cell.cost)},50,1)"
  #   style += if cell.path then ";font-weight: bold; color: #fff" else ""



  find_path = (start,dest) ->
    
    rander = -> parseInt Math.random()*width
    start = cells[0][0]#cells[rander()][rander()]
    dest = cells[width-1][width-1]#cells[rander()][rander()]

    starttime = new Date().getTime()

    open = []

    start.score = 0

    c = start

    cell_sort = (a,b) -> if a.score > b.score then 1 else -1

    while true
      if !c? then return
      if c == dest
        c.done = true
        break #we win

      for y in [c.y-1..c.y+1]
        for x in [c.x-1..c.x+1]
          #if Math.abs(c.x-x)+Math.abs(c.y-y) == 2 then continue
          try
            n = cells[y][x]
            if n?
              if !n.done
                if !(n in open)
                  open.push n
          catch err

      for n in open
        if n.cost == Infinity then n.done = true; continue;
        score = c.score+Math.sqrt( Math.pow( c.x-n.x,2 ) + Math.pow( c.y-n.y,2 ) ) * n.cost
        if (n.cost < coast && c.cost > coast) || (n.cost > coast && c.cost < coast)
          score += 500
        if score < n.score
          n.score = score
          n
        else
          undefined

      c.done = true

      open = open.filter (n) -> n?
      open = open.filter (n) -> !n.done

      open.sort cell_sort

      c = open[0]

    if !c? then return
    console.log new Date().getTime() - starttime
    #backtrack
    while true
      c.path = true
      break if c == start
      neig = []
      for y in [c.y-1..c.y+1]
        for x in [c.x-1..c.x+1]
          #if Math.abs(c.x-x)+Math.abs(c.y-y) == 2 then continue
          try
            n = cells[y][x]
            neig.push n if n? && n != c
          catch err

      neig.sort cell_sort

      c = neig[0]

    console.log "(ms) pathfinder:",new Date().getTime() - starttime



  # $scope.toggle = (cell) ->
  #   if cell.cost == Infinity
  #     cell.cost=10
  #   else
  #     cell.cost = Infinity
  #   for y in cells
  #     for x in y
  #       x.score = Infinity
  #       x.done = false
  #       x.path = false
  #   find_path()

  find_path()
  cells
