"use strict";
// {
//   initialize: function () {
//
//   },
//   p1: true,
//   p2: 'blah',
//   protected: {
//     prot1: function () {
//
//     }
//   },
//   private: {
//     priv1: function () {
//
//     }
//   }
// }
//

/*
  The list of reserved keywords
  Reserved keywords can not be used as the name of any property
  @type {Array}
*/
var _reserved = ['const', 'initialize', 'private'];

function _defProp(obj, key, value, isConst) {
  if (value instanceof Function) {
    value = value.bind(obj);
  }
  Object.defineProperty(obj, key, {
    value: value,
    writable: !isConst
  });
}

function _proxify (obj, props) {
  var proxy = {};
  props.forEach(function (k) {
    Object.defineProperty(proxy, k, {
      get: function () {
        return obj[k];
      },
      set: function (value) {
        obj[k] = value;
      }
    });
  });
  return Object.freeze(proxy);
}

function _checkKeyword (k, _throw) {
  if (typeof _throw === 'undefined') {
    _throw = true;
  }
  if (_reserved.indexOf(k) > -1) {
    if (_throw) {
      throw new ReferenceError('You have used a reserved keyword.');
    }
    return false;
  }
  return true;
}

function _generateNew (desc) {
  // The REAL new function
  return function () {
    var ret = {};
    var constProps = Object.keys(desc.const || {});
    constProps.forEach(function (k) {
      _checkKeyword(k);
      _defProp(ret, k, desc.const[k], true);
    });
    Object.keys(desc.private || {}).forEach(function (k) {
      _checkKeyword(k);
      _defProp(ret, k, desc.private[k], false);
    });
    Object.keys(desc).forEach(function (k) {
      if (_checkKeyword(k, false)) {
        _defProp(ret, k, desc[k], desc[k] instanceof Function);
      }
    });
    desc.initialize.apply(ret, arguments);
    var proxifiedProps = Object.keys(desc).filter(function (k) {
      return _reserved.indexOf(k) === -1;
    });
    return _proxify(ret, proxifiedProps.concat(constProps));
  };
}

function _descriptor (desc) {
  return {
    new: _generateNew(desc),
    extend: function (extension) {
      return module.exports.extend.apply(undefined, [desc].concat([].slice.apply(arguments)));
    }
  };
}

module.exports = {
  teach: function (desc) {
    if (!desc) {
      throw new Error('Get Out');
    }
    if (desc.initialize) {
      if (!(desc.initialize instanceof Function)) {
        throw new TypeError('The initialize MUST be a function');
      }
    } else {
      desc.initialize = function () {};
    }
    return _descriptor(desc);
  },
  new: function () {
    var args = [].slice.apply(arguments);
    var desc = args.shift();
    return module.exports.teach(desc).new.apply(undefined, args);
  },
  extend: function (parentClass, childClass) {
    if (!parentClass || !childClass) {
      throw new Error('Missing parameter to ::extend');
    }
    if (arguments.length > 2) {
      throw new Error('Too many paameters to ::extend');
    }
    return module.exports.teach({});
  }
};
