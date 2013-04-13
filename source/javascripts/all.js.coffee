# hello

# djikstra = 

#   Node: class

#   Solver: class
#     # takes a (square) array of travel cost, outputs correct path
#     constructor: (@grid) ->
#       @solve()

#     solve: ->
#       w = h = Math.sqrt( @grid.length ) #hardcoded square for simplicity
#       console.log 'hi'


#= require ./djikstra

$ ->
  w = h = 50
  map = []
  scale = 20


  cells = pathfinder.solve()

  console.log cells[5][5].cost
  cq().framework(
    onStep: ->
    onRender: ->
      @clear('#333')
      for row,y in cells
        for node,x in row
          @fillStyle cq.color(0,0,0,node.cost / 300).toRgba()
          @save().scale(scale,scale)
          @fillRect y,x,1,1
          @restore()

  ).appendTo("body")