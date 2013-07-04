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


function _generateNew (desc) {
  // The REAL new function
  return function () {

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
    }
    return {
      new: _generateNew(desc)
    };
  }
};
