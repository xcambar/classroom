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

var _reserved = ['const', 'initialize'];

function _defProp(obj, key, value, isConst) {
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

function _generateNew (desc) {
  // The REAL new function
  return function () {
    var ret = {};
    var constProps = Object.keys(desc.const || {});
    constProps.forEach(function (k) {
      if (_reserved.indexOf(k) > -1) { return; }
      _defProp(ret, k, desc.const[k], true);
    });
    Object.keys(desc).forEach(function (k) {
      if (_reserved.indexOf(k) > -1) { return; }
      _defProp(ret, k, desc[k], desc[k] instanceof Function);
    });
    desc.initialize.apply(ret, arguments);
    var proxifiedProps = Object.keys(desc).filter(function (k) {
      return _reserved.indexOf(k) === -1;
    });
    return _proxify(ret, proxifiedProps.concat(constProps));
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
    return {
      new: _generateNew(desc)
    };
  }
};
