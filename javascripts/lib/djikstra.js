(function() {
  var Cell, Solver, cell_sort,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  cell_sort = function(a, b) {
    return a.score - b.score;
  };

  this.djik.Cell = Cell = (function() {

    function Cell(x, y) {
      this.x = x;
      this.y = y;
      this.resetPathing();
      this.init();
    }

    Cell.prototype.init = function() {};

    Cell.prototype.resetPathing = function() {
      this.done = false;
      this.path = false;
      return this.score = Infinity;
    };

    Cell.prototype.cost = function() {
      return 1;
    };

    return Cell;

  })();

  this.djik.Solver = Solver = (function() {

    function Solver(cells, start, dest) {
      this.cells = cells;
      this.start = start;
      this.dest = dest;
      this.starttime = new Date().getTime();
      this.solve();
    }

    Solver.prototype.solve = function() {
      this.open = [];
      this.start.score = 0;
      this.c = this.start;
      this.traverse();
      if (!(this.c != null)) {
        return;
      }
      return this.backTrack();
    };

    Solver.prototype.traverse = function() {
      var _results;
      _results = [];
      while (true) {
        if (!(this.c != null)) {
          break;
        }
        if (this.c === this.dest) {
          this.c.done = true;
          break;
        }
        this.addAndScoreNeighbors();
        this.sortOpenCells();
        _results.push(this.c = this.open.shift());
      }
      return _results;
    };

    Solver.prototype.addAndScoreNeighbors = function() {
      var n, score, x, y, _i, _j, _ref, _ref1, _ref2, _ref3, _ref4;
      for (y = _i = _ref = this.c.y - 1, _ref1 = this.c.y + 1; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; y = _ref <= _ref1 ? ++_i : --_i) {
        for (x = _j = _ref2 = this.c.x - 1, _ref3 = this.c.x + 1; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; x = _ref2 <= _ref3 ? ++_j : --_j) {
          if (Math.abs(this.c.x - x) + Math.abs(this.c.y - y) === 2) {
            continue;
          }
          n = (_ref4 = this.cells[y]) != null ? _ref4[x] : void 0;
          if ((n != null) && !n.done) {
            if (!(__indexOf.call(this.open, n) >= 0)) {
              this.open.push(n);
            }
            if (n.cost() === Infinity) {
              n.done = true;
              continue;
            }
            score = this.c.score + n.cost();
            if (score < n.score) {
              n.score = score;
            }
          }
        }
      }
      return this.c.done = true;
    };

    Solver.prototype.sortOpenCells = function() {
      return this.open.sort(cell_sort);
    };

    Solver.prototype.backTrack = function() {
      var n, neig, x, y, _i, _j, _ref, _ref1, _ref2, _ref3, _results;
      _results = [];
      while (true) {
        this.c.path = true;
        if (this.c === this.start) {
          break;
        }
        neig = [];
        for (y = _i = _ref = this.c.y - 1, _ref1 = this.c.y + 1; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; y = _ref <= _ref1 ? ++_i : --_i) {
          for (x = _j = _ref2 = this.c.x - 1, _ref3 = this.c.x + 1; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; x = _ref2 <= _ref3 ? ++_j : --_j) {
            if (Math.abs(this.c.x - x) + Math.abs(this.c.y - y) === 2) {
              continue;
            }
            try {
              n = this.cells[y][x];
              if ((n != null) && n !== this.c) {
                neig.push(n);
              }
            } catch (err) {

            }
          }
        }
        neig.sort(cell_sort);
        _results.push(this.c = neig[0]);
      }
      return _results;
    };

    return Solver;

  })();

}).call(this);
