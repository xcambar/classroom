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

describe 'The constructor property', ->
  it 'should be a function', ->
    classRoom.teach.bind(undefined, constructor: ->).should.not.throw()
    classRoom.teach.bind(undefined, constructor: {}).should.throw TypeError
  it 'should be called', ->
    spy = sinon.spy()
    classRoom.teach(constructor: spy).new()
    spy.should.have.been.called
  it 'should be called with the context of the returned object', ->
    spy = sinon.spy()
    ret = classRoom.teach(constructor: spy).new()
    spy.should.have.been.calledOn ret
  it 'should be called with the arguments passed to "new"', ->
    spy = sinon.spy()
    args = [true, 1, ['a', 2], {bar: 'baz'}]
    ret = classRoom.teach(constructor: spy).new.apply undefined, args 
    spy.should.have.been.calledWithExactly args[0], args[1], args[2], args[3]
