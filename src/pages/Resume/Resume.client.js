(() => {
  // node_modules/.pnpm/rescript@9.1.4/node_modules/rescript/lib/es6/caml_array.js
  function sub(x, offset, len) {
    var result = new Array(len);
    var j = 0;
    var i = offset;
    while (j < len) {
      result[j] = x[i];
      j = j + 1 | 0;
      i = i + 1 | 0;
    }
    ;
    return result;
  }

  // node_modules/.pnpm/rescript@9.1.4/node_modules/rescript/lib/es6/curry.js
  function app(_f, _args) {
    while (true) {
      var args = _args;
      var f = _f;
      var init_arity = f.length;
      var arity = init_arity === 0 ? 1 : init_arity;
      var len = args.length;
      var d = arity - len | 0;
      if (d === 0) {
        return f.apply(null, args);
      }
      if (d >= 0) {
        return function(f2, args2) {
          return function(x) {
            return app(f2, args2.concat([x]));
          };
        }(f, args);
      }
      _args = sub(args, arity, -d | 0);
      _f = f.apply(null, sub(args, 0, arity));
      continue;
    }
    ;
  }
  function _1(o, a0) {
    var arity = o.length;
    if (arity === 1) {
      return o(a0);
    } else {
      switch (arity) {
        case 1:
          return o(a0);
        case 2:
          return function(param) {
            return o(a0, param);
          };
        case 3:
          return function(param, param$1) {
            return o(a0, param, param$1);
          };
        case 4:
          return function(param, param$1, param$2) {
            return o(a0, param, param$1, param$2);
          };
        case 5:
          return function(param, param$1, param$2, param$3) {
            return o(a0, param, param$1, param$2, param$3);
          };
        case 6:
          return function(param, param$1, param$2, param$3, param$4) {
            return o(a0, param, param$1, param$2, param$3, param$4);
          };
        case 7:
          return function(param, param$1, param$2, param$3, param$4, param$5) {
            return o(a0, param, param$1, param$2, param$3, param$4, param$5);
          };
        default:
          return app(o, [a0]);
      }
    }
  }
  function __1(o) {
    var arity = o.length;
    if (arity === 1) {
      return o;
    } else {
      return function(a0) {
        return _1(o, a0);
      };
    }
  }

  // node_modules/.pnpm/rescript@9.1.4/node_modules/rescript/lib/es6/belt_Array.js
  function forEachU(a, f) {
    for (var i = 0, i_finish = a.length; i < i_finish; ++i) {
      f(a[i]);
    }
  }
  function forEach(a, f) {
    return forEachU(a, __1(f));
  }

  // src/pages/Resume/Resume.client.bs.js
  document.addEventListener("DOMContentLoaded", function(param) {
    var han = window.Han;
    han.renderHanging();
    han.renderJiya();
    han.renderHWS();
    var printer = document.querySelector(".Printer");
    if (!(printer == null)) {
      printer.addEventListener("click", function(_e) {
        return _1(window.print, void 0);
      });
    }
    var darkBySystemPref = window.matchMedia("(prefers-color-scheme: dark)").matches;
    forEach(Array.from(document.querySelectorAll('input[type="checkbox"]')), function(input) {
      var id = input.id;
      var indeterminable = input.classList.contains("indeterminable");
      var prevPref = localStorage.getItem(id);
      var tmp;
      var exit = 0;
      if (id === "light--dark") {
        if (prevPref !== null) {
          exit = 1;
        } else {
          tmp = darkBySystemPref;
        }
      } else if (indeterminable && prevPref === null) {
        tmp = true;
      } else {
        exit = 1;
      }
      if (exit === 1) {
        tmp = prevPref !== null ? prevPref === "true" : false;
      }
      input.checked = tmp;
      input.indeterminate = indeterminable ? prevPref !== null ? prevPref === "indeterminate" : true : false;
      input.addEventListener("click", function(_e) {
        localStorage.setItem(id, input.checked ? "true" : "false");
      });
      var label = document.querySelector("label.indeterminable[for=" + id + "]");
      if (!(label == null)) {
        label.addEventListener("click", function(e) {
          var match = input.checked;
          var match$1 = input.indeterminate;
          if (match && !match$1) {
            e.preventDefault();
            input.indeterminate = true;
            localStorage.setItem(id, "indeterminate");
            return;
          }
        });
        return;
      }
    });
    var body = document.body;
    body.classList.add("ready");
  });
})();
