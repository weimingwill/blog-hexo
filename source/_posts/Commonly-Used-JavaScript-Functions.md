---
title: Commonly Used JavaScript Functions
date: 2017-05-27 12:43:31
tags: [技术,JavaScript]
---
##### Dynamic call functions

```
// function to call
function toCallFn() { 
  console.log('fn called');
}

const dynamicCallFn = { toCallFn };
dynamicCallFn['toCallFn']();
```
References: 
http://stackoverflow.com/questions/676721/calling-dynamic-function-with-dynamic-parameters-in-javascript
http://stackoverflow.com/questions/34655616/create-an-instance-of-a-class-in-es6-with-a-dynamic-name


##### Check is float string

```
if (!isNaN(value) && value.toString().indexOf('.') != -1) {
    alert('value is float');
}​
```

##### Add event listener with param
```
var param; 
$selector.addEventListener("click", () => fn(param));
```
Remake: After adding event listeners, event functions will be triggered in sequence.

##### Map - Reduce 
```
// To calculate total cost
let nums = [{cost: 20}, {cost: 10}]
let totalCost = nums.map(n => n.cost).reduce((sum, cost) => { 
  return sum + cost
}) // 30

```
[Official documentation of reduce](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce?v=example)

##### How to check whether a DOM element has event listener?
Ans: No JavaScript function to do it. While you can add a boolean variable to to DOM element and use a boolean variable to check if it is true before adding another eventListener to it.

##### Get array min/max
```
var min = Math.min.apply(null, arr);
var max = Math.max.apply(null, arr);
```

##### Add/remove DOM element classname
```
// add class name
var $el = document.getElementById("div");
$el.className += " className";

// remove class name
$el.className = $el.className.replace(/\bclassName\b/,'');
```

##### Reference value variables !!!
```
a = [{'b': 1, 'c': 2}]
b = a.slice()  // [{'b': 1, 'c': 2}]
b = b.map(e => {e.b += 1; return e}) // [{'b': 2, 'c': 2}]
a // [{'b': 1, 'c': 2}]
// a is changed as b is changed!!

// To prevent this
b = b.map(e => {e.b += 1; return Object.assign(null, e)});
```

##### Pass variables in object to function
When passing variables using { a, b, c }, in the receiving function, the variable name should be the same. e.g.
```
// call fn
fn ({a ,b c})

// define fn
function fn ({a, b, c}) { console.log('fn') }

// define fn in this way will give error
function fn ({first, second, third}) {} 
```

##### For loop using forEach
When using forEach, it will loop over all items and will not stop with `break` or   `return`.
 
##### Use logical operator to assign value
When use `AND`/ `&& ` to assign value, if first is true, return value of  the second operand; if first is false, return value of first operand. 
```
// if originalVal is true, value === newVal
// if originalVal is false, value === originalVal
var value = originalVal && newVal;
if (value) {...}

true && "val"; // "val"
NaN && "anything"; // NaN
0 && "anything";   // 0
```

##### Get date range of a week
```
function getDateRangeOfWeek(date) {
  let mon = date.getDate() - date.getDay() + 1;
  let sun = mon + 6;
  return {
    monday: new Date(date.setDate(mon)),
    sunday: new Date(date.setDate(sun)),
    lastMonday: new Date(date.setDate(mon - 7)),
    lastSunday: new Date(date.setDate(sun - 7))
  }
```