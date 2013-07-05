sinon = require 'sinon'
chai = require 'chai'
chai.use require('sinon-chai')
chai.should()
expect = chai.expect

classRoom = require '../index'

describe 'global API', ->
  it 'should be an object', ->
    classRoom.should.be.a 'object'
  it 'should contain a property "teach"', ->
    expect(classRoom.teach).to.not.be.undefined
  describe 'classRoom.teach', ->
    it 'should be a function', ->
      classRoom.teach.should.be.a 'function'

describe 'teaching a class with classRoom.teach', ->
  it 'should throw without an argument', ->
    classRoom.teach.bind().should.throw()
  it 'should return an object', ->
    classRoom.teach({}).should.be.a 'object'
  describe 'the teached class', ->
    it 'should have a function property called "new"', ->
      expect(classRoom.teach({})).to.not.be.undefined
      classRoom.teach({}).new.should.be.a 'function'

describe 'The "new" function property', ->
  it 'should return an object', ->
    classRoom.teach({}).new().should.be.a 'Object'

describe 'The initialize property', ->
  it 'should be a function', ->
    classRoom.teach.bind(undefined, initialize: ->).should.not.throw()
    classRoom.teach.bind(undefined, initialize: {}).should.throw TypeError
  it 'should be called', ->
    spy = sinon.spy()
    classRoom.teach(initialize: spy).new()
    spy.should.have.been.called
  xit 'should be called with the context of the returned object', ->
    spy = sinon.spy()
    ret = classRoom.teach(initialize: spy).new()
    spy.should.have.been.calledOn ret
  it 'should be called with the arguments passed to "new"', ->
    spy = sinon.spy()
    args = [true, 1, ['a', 2], {bar: 'baz'}]
    ret = classRoom.teach(initialize: spy).new.apply undefined, args 
    spy.should.have.been.calledWithExactly args[0], args[1], args[2], args[3]

describe 'The const object property', ->
  it 'should have its values attached to the returned object', ->
    _const = {a:1, b:2, c:3}
    obj = classRoom.teach(const: _const).new()
    obj.a.should.eql 1
    obj.b.should.eql 2
    obj.c.should.eql 3
  it 'should have its values immutable on the returned object', ->
    _const = {a:1, b:2, c:3}
    obj = classRoom.teach(const: _const).new()
    fail = ->
      obj.a = 2
    fail.bind(undefined).should.throw Error
    obj.a.should.be.eql 1

describe 'any non-reserved property', ->
  it 'should be available in the returned object', ->
    obj = classRoom.teach(yay: 'cool').new()
    obj.yay.should.eql 'cool'
    expect(obj.const).to.be.undefined
    expect(obj.initialize).to.be.undefined
  it 'should be mutable if it is not a function', ->
    obj = classRoom.teach(yay: 'woooh').new()
    obj.yay = 'cool'
    obj.yay.should.eql 'cool'
  it 'should be immutable if it is a function', ->
    obj = classRoom.teach(yay: -> 'woooh').new()
    fail = -> 
      obj.yay = -> 'cool'
    fail.bind(undefined).should.throw TypeError
    obj.yay().should.eql 'woooh'

describe 'private properties', ->
  it 'should not return the "private" property', ->
    obj = classRoom.teach(private: {a: 1}).new()
    expect(obj.private).to.be.undefined
  it 'should not be available in the returned object', ->
    obj = classRoom.teach(private: {a: 1}).new()
    expect(obj.a).to.be.undefined
  it 'should be available to instance members', ->
    obj = classRoom.teach(private: {a: "I'm private"}, getA: -> @a).new()
    obj.getA().should.be.eql "I'm private"

describe 'Inheritance', ->
  parentClass = classRoom.teach
    initialize: ->
    private: 
      prop: "privateValue"
      fn: -> "privateFn"
    const:
      constValue: "immutable"
  describe 'API', ->
    it 'should be accessible via an "extend" function property on the module', ->
      classRoom.should.contain.keys ['extend']
      classRoom.extend.should.be.a 'function'
    it 'should take exactly 2 parameters', ->
      classRoom.extend.bind().should.throw Error
      classRoom.extend.bind(undefined, parentClass).should.throw Error
      classRoom.extend.bind(undefined, parentClass, {}).should.not.throw Error
    it 'returns a new class descriptor', ->
      classRoom.extend(parentClass, {}).should.be.a 'object'
      classRoom.extend(parentClass, {}).should.have.keys ['new']

