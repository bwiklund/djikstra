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
