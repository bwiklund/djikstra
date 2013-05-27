(function() {

  this.djik = {};

}).call(this);
// Ported from Stefan Gustavson's java implementation
// http://staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf
// Read Stefan's excellent paper for details on how this code works.
//
// Sean McCullough banksean@gmail.com

/**
 * You can pass in a random number generator object if you like.
 * It is assumed to have a random() method.
 */

var ClassicalNoise = function(r) { // Classic Perlin noise in 3D, for comparison 
  if (r == undefined) r = Math;
  this.grad3 = [[1,1,0],[-1,1,0],[1,-1,0],[-1,-1,0], 
                                 [1,0,1],[-1,0,1],[1,0,-1],[-1,0,-1], 
                                 [0,1,1],[0,-1,1],[0,1,-1],[0,-1,-1]]; 
  this.p = [];
  for (var i=0; i<256; i++) {
    this.p[i] = Math.floor(r.random()*256);
  }
  // To remove the need for index wrapping, double the permutation table length 
  this.perm = []; 
  for(var i=0; i<512; i++) {
    this.perm[i]=this.p[i & 255];
  }
};

ClassicalNoise.prototype.dot = function(g, x, y, z) { 
    return g[0]*x + g[1]*y + g[2]*z; 
};

ClassicalNoise.prototype.mix = function(a, b, t) { 
    return (1.0-t)*a + t*b; 
};

ClassicalNoise.prototype.fade = function(t) { 
    return t*t*t*(t*(t*6.0-15.0)+10.0); 
};

  // Classic Perlin noise, 3D version 
ClassicalNoise.prototype.noise = function(x, y, z) { 
  // Find unit grid cell containing point 
  var X = Math.floor(x); 
  var Y = Math.floor(y); 
  var Z = Math.floor(z); 
  
  // Get relative xyz coordinates of point within that cell 
  x = x - X; 
  y = y - Y; 
  z = z - Z; 
  
  // Wrap the integer cells at 255 (smaller integer period can be introduced here) 
  X = X & 255; 
  Y = Y & 255; 
  Z = Z & 255;
  
  // Calculate a set of eight hashed gradient indices 
  var gi000 = this.perm[X+this.perm[Y+this.perm[Z]]] % 12; 
  var gi001 = this.perm[X+this.perm[Y+this.perm[Z+1]]] % 12; 
  var gi010 = this.perm[X+this.perm[Y+1+this.perm[Z]]] % 12; 
  var gi011 = this.perm[X+this.perm[Y+1+this.perm[Z+1]]] % 12; 
  var gi100 = this.perm[X+1+this.perm[Y+this.perm[Z]]] % 12; 
  var gi101 = this.perm[X+1+this.perm[Y+this.perm[Z+1]]] % 12; 
  var gi110 = this.perm[X+1+this.perm[Y+1+this.perm[Z]]] % 12; 
  var gi111 = this.perm[X+1+this.perm[Y+1+this.perm[Z+1]]] % 12; 
  
  // The gradients of each corner are now: 
  // g000 = grad3[gi000]; 
  // g001 = grad3[gi001]; 
  // g010 = grad3[gi010]; 
  // g011 = grad3[gi011]; 
  // g100 = grad3[gi100]; 
  // g101 = grad3[gi101]; 
  // g110 = grad3[gi110]; 
  // g111 = grad3[gi111]; 
  // Calculate noise contributions from each of the eight corners 
  var n000= this.dot(this.grad3[gi000], x, y, z); 
  var n100= this.dot(this.grad3[gi100], x-1, y, z); 
  var n010= this.dot(this.grad3[gi010], x, y-1, z); 
  var n110= this.dot(this.grad3[gi110], x-1, y-1, z); 
  var n001= this.dot(this.grad3[gi001], x, y, z-1); 
  var n101= this.dot(this.grad3[gi101], x-1, y, z-1); 
  var n011= this.dot(this.grad3[gi011], x, y-1, z-1); 
  var n111= this.dot(this.grad3[gi111], x-1, y-1, z-1); 
  // Compute the fade curve value for each of x, y, z 
  var u = this.fade(x); 
  var v = this.fade(y); 
  var w = this.fade(z); 
   // Interpolate along x the contributions from each of the corners 
  var nx00 = this.mix(n000, n100, u); 
  var nx01 = this.mix(n001, n101, u); 
  var nx10 = this.mix(n010, n110, u); 
  var nx11 = this.mix(n011, n111, u); 
  // Interpolate the four results along y 
  var nxy0 = this.mix(nx00, nx10, v); 
  var nxy1 = this.mix(nx01, nx11, v); 
  // Interpolate the two last results along z 
  var nxyz = this.mix(nxy0, nxy1, w); 

  return nxyz; 
};
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
(function() {
  var CityCell, CitySimulator, perlin, recPerlin,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  perlin = new ClassicalNoise();

  recPerlin = function(x, y, z, n) {
    var i, noise, s, _i;
    noise = 0;
    for (i = _i = 0; 0 <= n ? _i <= n : _i >= n; i = 0 <= n ? ++_i : --_i) {
      s = Math.pow(2, i);
      noise += (perlin.noise(x * s, y * s, z * s) * 0.5 + 0.5) / s / 2;
    }
    return noise;
  };

  CityCell = (function(_super) {

    __extends(CityCell, _super);

    function CityCell() {
      return CityCell.__super__.constructor.apply(this, arguments);
    }

    CityCell.prototype.init = function() {
      var ms;
      ms = 0.03;
      this.height = recPerlin(this.x * ms, this.y * ms, 0, 5);
      return this.road = 0;
    };

    CityCell.prototype.color = function() {
      return this.height - this.road;
    };

    CityCell.prototype.cost = function() {
      return Math.max(0.00001, this.height - this.road);
    };

    return CityCell;

  })(this.djik.Cell);

  CitySimulator = (function() {

    function CitySimulator(width) {
      var _i, _ref, _results,
        _this = this;
      this.width = width;
      this.cells = (function() {
        _results = [];
        for (var _i = 0, _ref = this.width; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).map(function(y) {
        var _i, _ref, _results;
        return (function() {
          _results = [];
          for (var _i = 0, _ref = _this.width; 0 <= _ref ? _i < _ref : _i > _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
          return _results;
        }).apply(this).map(function(x) {
          return new CityCell(x, y);
        });
      });
    }

    CitySimulator.prototype.step = function() {
      var dest, node, randIndex, row, start, x, y, _i, _j, _len, _len1, _ref,
        _this = this;
      _ref = this.cells;
      for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
        row = _ref[y];
        for (x = _j = 0, _len1 = row.length; _j < _len1; x = ++_j) {
          node = row[x];
          node.road *= 0.997;
          if (node.path) {
            node.road += 0.013;
          }
          node.resetPathing();
        }
      }
      randIndex = function() {
        return Math.floor(Math.random() * _this.width);
      };
      start = this.cells[randIndex()][randIndex()];
      dest = this.cells[randIndex()][randIndex()];
      return new djik.Solver(this.cells, start, dest);
    };

    return CitySimulator;

  })();

  $(function() {
    var city, drawScale;
    city = new CitySimulator(80);
    drawScale = 5;
    return cq(city.width * drawScale, city.width * drawScale).framework({
      onStep: function() {
        return city.step();
      },
      onRender: function() {
        var c, color, node, row, x, y, _i, _j, _len, _len1, _ref;
        this.clear('#333').save().scale(drawScale, drawScale);
        _ref = city.cells;
        for (y = _i = 0, _len = _ref.length; _i < _len; y = ++_i) {
          row = _ref[y];
          for (x = _j = 0, _len1 = row.length; _j < _len1; x = ++_j) {
            node = row[x];
            c = ~~(255 * node.color());
            c = Math.min(255, Math.max(0, c));
            color = node.path ? cq.color([0, 0, 0, 1]) : cq.color([c, c, c, 1.0]);
            this.fillStyle(color.toHex()).fillRect(x, y, 0.98, 0.98);
          }
        }
        return this.restore();
      }
    }).appendTo("body");
  });

}).call(this);
(function() {



}).call(this);
