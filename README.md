# ClassRoom

## What is it ?

A implementation of classes in Javascript for ES5 engines.

## Features

* Constructor
* Private members
* Constant members

## Installation

    npm install classroom

## Examples

    var classRoom = require('classroom');

    var testClass = classRoom.teach({
      initialize: function (arg1, arg2/* , arg3, ... , argn */) {
        // This is the constructor function
        // Properties added here will be private
        this.privateArg = arg1;
      },
      const: { //Describes the constant members of your instances
        const1: "Awesome, I'm immutable!"
      },
      private: { // Describes the properties that are only visible inside the instance
        pv1: "only the instance methods can see me, sweet!",
        secretFn: function () {
          return "I'm invisible to the outside world.";
        }
      },
      // All the other properties are public instance members
      gimmeSecret: function () {
        return "I'm a getter for a private member: " + this.secretFn();
      },
      getConstructorFirstArg: function () {
        return this.privateArg;
      }
    });

    var instance = testClass.new("First arg");

    instance.const1; // => "Awesome, I'm immutable!"
    instance.const1 = 'new value'; // throws TypeError

    instance.privateArg; // => undefined
    instance.pv1; // => undefined
    instance.privateArg; // => undefined
    instance.secretFn; // => undefined

    instance.gimmeSecret(); // => "I'm a getter for a private member: I'm invisible to the outside world."
    instance.getConstructorFirstArg(); // => "First Arg"


## TODO

* Inheritance
* Composition (aka mixins)
* Class members

## Licence

MIT

