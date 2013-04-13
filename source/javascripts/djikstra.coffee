




@djik.Cell = class Cell
  constructor: (@x,@y)->
    @cost = 0
    @score = Infinity
    @done = false

  label: ->
    ""+(parseInt(@cost)||".")


#coast = 120


@djik.solvePath = (cells) ->

  find_path = (start,dest) ->
    
    rander = -> parseInt Math.random()*cells.length
    start = cells[rander()][rander()]#cells[0][0]#
    dest = cells[rander()][rander()]#cells[width-1][width-1]#

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
        #if (n.cost < coast && c.cost > coast) || (n.cost > coast && c.cost < coast)
        #  score += 500
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
