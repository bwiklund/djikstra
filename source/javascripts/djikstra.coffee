cell_sort = (a,b) -> a.score - b.score



@djik.Cell = class Cell
  constructor: (@x,@y)->
    @resetPathing()
    @init()

  init: ->

  resetPathing: ->
    @done = false
    @path = false
    @score = Infinity

  cost: -> 1



@djik.Solver = class Solver
  constructor: (@cells,@start,@dest) ->
    @starttime = new Date().getTime()
    @solve()

  solve: ->

    @open = []
    @start.score = 0
    @c = @start
    @traverse()
    if !@c? then return
    @backTrack()

    #console.log "(ms) pathfinder:",new Date().getTime() - @starttime

  traverse: ->
    while true
      break if !@c?
      if @c == @dest
        @c.done = true
        break #we win

      @addAndScoreNeighbors()
      @sortOpenCells()

      @c = @open.shift()


  addAndScoreNeighbors: ->
    for y in [@c.y-1..@c.y+1]
      for x in [@c.x-1..@c.x+1]
        if Math.abs(@c.x-x)+Math.abs(@c.y-y) == 2 then continue
        n = @cells[y]?[x]

        if n? && !n.done

          if !(n in @open)
            @open.push n

          if n.cost() == Infinity
            n.done = true
            continue

          score = @c.score + n.cost()#Math.sqrt( Math.pow( @c.x-n.x,2 ) + Math.pow( @c.y-n.y,2 ) ) * n.cost()
          if score < n.score
            n.score = score

    @c.done = true


  sortOpenCells: ->
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

