---
title: JavaScript bind() 的用法
date: 2017-04-12 12:43:31
tags: [技术,JavaScript]
---
> 本以为学会了独孤九剑，结果握剑姿势都不对。

bind() 怎么用？码的过程中用了无数次，`$('button').bind('click', function() {...} );`，结果要给室友解释时，竟无从开口，果然，行不行，溜一溜就知道了。赶紧把自己关进小黑屋，再磨磨剑。

<!-- more -->

MDN 官方文档对 bind() 的定义
>The **bind()** method creates a new function that, when called, has its this keyword set to the provided value, with a given sequence of arguments preceding any provided when the new function is called.

室友读完后第一反应，能不能说人话 ？？简单说，bind() 是用来控制调用函数的范围（全局、某个类等等），在是 `bind(arg1)` 这个函数被调用时，`arg1` 是调用 bind() 函数里面的 this，不管这个函数被调用多少次，这个函数里的 this 一直是这个 arg1。貌似，有点像人话，但你TM在说什么？

只好用 [MDN Function.prototype.bind()](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_objects/Function/bind) 官方文档两个栗子来解释 bind() 的用法。

```
this.x = 9;
var module = {
  x: 81,
  getX: function() { return this.x; }
};

module.getX(); // 81

var retrieveX = module.getX;
retrieveX();  // 9

var boundGetX = retrieveX.bind(module);
boundGetX(); // 81
```
1. `module.getX(); ` 的结果是 81，因为 getX 里的 this 是 module, 所以 this.x 是 module 里的 `x = 81`。
2. `retrieveX();` 的结果是 9， 因为这时相当于 `var retrieveX = function() { return this.x; };`， `retrieveX();` 相当于在全局跑了遍函数里的内容，this.x 是 全局的 `this.x = 9`。

关键来了：`var boundGetX = retrieveX.bind(module);`，**bind(module) 的作用是每当调用 retrieveX() 这个函数时，这个函数里的 this 都是 module，替换掉了全局的 this**，在 boundGetX() 调用时，返回的是 `module.x`，所以是 81。

再看第二个栗子：
```
function LateBloomer() {
  this.petalCount =  1;
}

LateBloomer.prototype.bloom = function() {
  window.setTimeout(this.declare.bind(this), 1000);
};

LateBloomer.prototype.declare = function() {
  console.log('I am a beautiful flower with ' + this.petalCount + ' petals!');
};

var flower = new LateBloomer();
flower.bloom();
// 执行结果：1s 后，打印出 'I am a beautiful flower with 1 petals!'
```
这个栗子的核心是 `window.setTimeout(this.declare.bind(this), 1000);`  首先这里的两个 `this` 都指的是LateBloomer。这个栗子一开始看来显得有点智障，为了要打印出那句话，直接用 `window.setTimeout(this.declare(), 1000);` 不就好了，干嘛还要 bind()？通常，像我这种质疑这种成千上万的人看过没有问题的文档的才是智障那个。

这个栗子主要是为了讲 bind() 的返回值。`window.setTimeout(function, milliseconds)` 这是这个函数的用法，function 是延迟的函数，milliseconds 是延迟的时间。如果`console.log(this.declare());` 一下就会发现, 结果是 undefined， `console.log(this.declare.bind(this));` 的结果则是 declare 这个函数，**在使用 bind() 了之后，会创建一个新的函数。**

这也就是为什么要用 `window.setTimeout(this.declare.bind(this), 1000);`，只有这样，才能看到1秒延迟，不信你删掉bind()试试看。

综上，重新看下那句非人话。**在 bind(arg1, arg2) 被调用时，会创建一个新函数，这个新函数的 this，都是 arg1，也就是第一个参数。**
