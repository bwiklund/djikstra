




@djik.Cell = class Cell
  constructor: (@x,@y)->
    @cost = 0
    @resetPathing()

  label: ->
    ""+(parseInt(@cost)||".")

  resetPathing: ->
    @done = false
    @path = false
    @score = Infinity




class Solver
  constructor: (@cells) ->
    @start = @cells[@rander()][@rander()]#cells[0][0]#
    @dest = @cells[@rander()][@rander()]#cells[width-1][width-1]#
    @starttime = new Date().getTime()

    @solve()

  rander: -> parseInt Math.random()*@cells.length

  solve: ->

    open = []

    @start.score = 0

    @c = @start

    

    while true
      if !@c? then return
      if @c == @dest
        @c.done = true
        break #we win

      for y in [@c.y-1..@c.y+1]
        for x in [@c.x-1..@c.x+1]
          #if Math.abs(c.x-x)+Math.abs(c.y-y) == 2 then continue
          try
            n = @cells[y][x]
            if n?
              if !n.done
                if !(n in open)
                  open.push n
          catch err

      for n in open
        if n.cost == Infinity then n.done = true; continue;
        score = @c.score+Math.sqrt( Math.pow( @c.x-n.x,2 ) + Math.pow( @c.y-n.y,2 ) ) * n.cost
        #if (n.cost < coast && c.cost > coast) || (n.cost > coast && c.cost < coast)
        #  score += 500
        if score < n.score
          n.score = score
          n
        else
          undefined

      @c.done = true

      open = open.filter (n) -> n?
      open = open.filter (n) -> !n.done

      open.sort cell_sort

      @c = open[0]

    if !@c? then return
    
    @backTrack()

    console.log "(ms) pathfinder:",new Date().getTime() - @starttime

  backTrack: ->
    while true
      @c.path = true
      break if @c == @start
      neig = []
      for y in [@c.y-1..@c.y+1]
        for x in [@c.x-1..@c.x+1]
          #if Math.abs(c.x-x)+Math.abs(c.y-y) == 2 then continue
          try
            n = @cells[y][x]
            neig.push n if n? && n != @c
          catch err

      neig.sort cell_sort

      @c = neig[0]



cell_sort = (a,b) -> a.score - b.score


@djik.solvePath = (cells) ->
    
  new Solver(cells)
