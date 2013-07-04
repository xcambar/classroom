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
      Object.defineProperty(ret, k, _constConfig(desc.const[k]));
    });
    desc.constructor.apply(ret, arguments);
    return ret;
  };
}

module.exports = {
  teach: function (desc) {
    if (!desc) {
      throw new Error('Get Out');
    }
    if (desc.constructor) {
      if (!(desc.constructor instanceof Function)) {
        throw new TypeError('The constructor MUST be a function');
      }
    } else {
      desc.constructor = function () {};
    }
    return {
      new: _generateNew(desc)
    };
  }
};
