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
  it 'should be called with the context of the returned object', ->
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
    obj.a = 2
    obj.a.should.be.eql 1

describe 'any non-reserved property', ->
  it 'should be available in the returned object', ->
    obj = classRoom.teach(const: {a: 1}, initialize: ->, yay: 'cool').new()
    obj.yay.should.eql 'cool'
    expect(obj.const).to.be.undefined
    expect(obj.initialize).to.be.undefined
