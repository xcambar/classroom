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

function _constConfig (v) {
  return {
    value: v
  };
}

function _generateNew (desc) {
  // The REAL new function
  return function () {
    var ret = {};
    Object.keys(desc.const || {}).forEach(function (k) {
      if (_reserved.indexOf(k) > -1) { return; }
      Object.defineProperty(ret, k, _constConfig(desc.const[k]));
    });
    Object.keys(desc).forEach(function (k) {
      if (_reserved.indexOf(k) > -1) { return; }
      ret[k] = desc[k];
    });
    desc.initialize.apply(ret, arguments);
    return ret;
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
