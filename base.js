// Generated by CoffeeScript 1.6.2
(function() {
  var allKey, compare, errorJS, etalonJS, poster, testJS;

  etalonJS = null;

  testJS = null;

  errorJS = null;

  poster = function(url, type, returned, data, func) {
    if (type === 'GET') {
      url = url + "?" + Math.random();
    }
    if (!returned) {
      returned = 'html';
    }
    return $.ajax(url, {
      type: type,
      data: data,
      dataType: returned,
      success: function(res, status, xhr) {
        if (func != null) {
          return func(res);
        }
      },
      error: function(xhr, status, err) {}
    });
  };

  allKey = function(object) {
    var k, result, subObject, v;

    result = null;
    if (_.isObject(object)) {
      result = {};
      for (k in object) {
        v = object[k];
        if (_.isObject(v || _.isArray(v))) {
          subObject = allKey(v);
          result[k] = subObject;
        } else {
          if (v != null) {
            result[k] = typeof v;
          } else {
            result[k] = "null";
          }
        }
      }
    }
    if (_.isArray(object)) {
      result = [];
      for (k in object) {
        v = object[k];
        result.push(typeof v);
      }
      result = _.uniq(result);
    }
    return result;
  };

  compare = function(object, etalon) {
    var i, k, s, tempo_result, v;

    for (k in object) {
      v = object[k];
      if (_.isArray(etalon[k])) {
        for (s in v) {
          i = v[s];
          if (etalon[k].indexOf(i) < 0) {
            object[k][s] = '<strong>*' + i + '</strong>';
          }
        }
      } else {
        if (_.isObject(etalon[k])) {
          tempo_result = compare(v, etalon[k]);
          if (tempo_result.length > 0) {
            result.push(tempo_result);
          }
        } else {
          if (v !== etalon[k]) {
            object[k] = '<strong>*' + v + '</strong>';
          }
        }
      }
    }
    return object;
  };

  jQuery(function() {
    poster('/source.json', 'GET', 'json', {}, function(data) {
      etalonJS = allKey(data);
      return $("#etalon").html(JSON.stringify(etalonJS));
    });
    $("#checkgood").on({
      click: function() {
        return poster('/goodcheck.json', 'GET', 'json', {}, function(data) {
          testJS = allKey(data);
          $("#forcheck").html(JSON.stringify(testJS));
          return $("#result").html(JSON.stringify(compare(testJS, etalonJS)));
        });
      }
    });
    return $("#checkbad").on({
      click: function() {
        return poster('/badcheck.json', 'GET', 'json', {}, function(data) {
          testJS = allKey(data);
          $("#forcheck").html(JSON.stringify(testJS));
          return $("#result").html(JSON.stringify(compare(testJS, etalonJS)));
        });
      }
    });
  });

}).call(this);
