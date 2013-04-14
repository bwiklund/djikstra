


@djik.Cell = class Cell
  constructor: (@x,@y)->
    @cost = 0
    @resetPathing()

  #calculateHeuristic: (x,y) ->
  #  @heuristic = 0.2*Math.sqrt( Math.pow(@x-x,2) + Math.pow(@y-y,2) )

  label: ->
    ""+(parseInt(@cost)||".")

  resetPathing: ->
    @done = false
    @path = false
    @score = Infinity
    #@heuristic = 0



cell_sort = (a,b) -> 
  # as = a.score + a.heuristic
  # bs = b.score + b.heuristic
  # as-bs
  a.score - b.score



class Solver
  constructor: (@cells) ->
    @start = @cells[@rander()][@rander()]#cells[0][0]#
    @dest = @cells[@rander()][@rander()]#cells[width-1][width-1]#
    @starttime = new Date().getTime()

    @solve()

  rander: -> parseInt Math.random()*@cells.length

  solve: ->

    # for row in @cells
    #   for cell in row
    #     cell.calculateHeuristic @dest.x, @dest.y

    @open = []
    @start.score = 0
    @c = @start
    @traverse()
    if !@c? then return
    @backTrack()

    console.log "(ms) pathfinder:",new Date().getTime() - @starttime

  traverse: ->
    while true
      break if !@c?
      if @c == @dest
        @c.done = true
        break #we win

      @addOpenCells()
      @scoreOpenCells()
      @filterAndSortOpenCells()

      @c = @open[0]


  addOpenCells: ->
    for y in [@c.y-1..@c.y+1]
      for x in [@c.x-1..@c.x+1]
        if Math.abs(@c.x-x)+Math.abs(@c.y-y) == 2 then continue
        n = @cells[y]?[x]
        if n? && !n.done && !(n in @open)
          @open.push n


  scoreOpenCells: ->
    for n in @open
      if n.cost == Infinity then n.done = true; continue;
      score = @c.score + Math.sqrt( Math.pow( @c.x-n.x,2 ) + Math.pow( @c.y-n.y,2 ) ) * n.cost
      #if (n.cost < coast && c.cost > coast) || (n.cost > coast && c.cost < coast)
      #  score += 500
      if score < n.score
        n.score = score
    @c.done = true


  filterAndSortOpenCells: ->
    #@open = @open.filter (n) -> n?
    @open = @open.filter (n) -> !n.done
    @open.sort cell_sort


  backTrack: ->
    while true
      @c.path = true
      break if @c == @start
      neig = []
      for y in [@c.y-1..@c.y+1]
        for x in [@c.x-1..@c.x+1]
          if Math.abs(@c.x-x)+Math.abs(@c.y-y) == 2 then continue
          try
            n = @cells[y][x]
            neig.push n if n? && n != @c
          catch err

      neig.sort cell_sort

      @c = neig[0]


@djik.solvePath = (cells) ->
    
  new Solver(cells)
