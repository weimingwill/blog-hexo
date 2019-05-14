---
title: Webpack快速入门实践
date: 2017-04-08 16:12:49
tags: [技术,webpack]
---
![webpack](https://i.imgur.com/qvGm45u.png)

## 源起
能碰上 webpack，是偶然也是必然。本来想在公司下个项目试试 AngularJS，但是又不能使用 server。奇怪要求的限制，滋生了奇怪的请求，所以在 Google 上查了半天没有找到合理的解决方案，只在 Google Group 里面看到有两个人讨论的热火朝天，里面提到了 webpack.config.js 貌似能够成功解决能够这个问题，尝试了下，老是有问题，就开始读 webpack 文档。之后在看第一个 AngularJS 2 教程时，直接看到一句大意是，**如果你还不懂什么是 webpack，那你先别来看这个了，回家再进修进修吧。** 不禁好奇，这东西那么好用？更仔细的研究了下，应用确实挺广的，而且很实用。废话不多说，直接上教程。从 0 开始创建一个 webpack 项目，一边往里面加内容，一边介绍。

<!-- more -->

## 简介
Webpack 是什么呢？官网介绍是 **module bundler**,  `JavaScript` 的模块打包器，参考题图，大概意思就是，能够将一堆关系错综复杂的 `.js`, `.css`,  `.sass` 等文件，打包成几个静态的文件，在 html 里面直接插入实用，就好像在一家淘宝店上买了许多东西， 卖家不是一个一个给你发货而是给你打包送过了，省去了你一个一个收快递的麻烦。举一个简单的栗子，

```javascript
//bar.js
export default function bar() {}

//app.js
import bar from './bar';
bar();
```
在使用 html 里使用时，需要分别加载两个文件 `bar.js` 和 `app.js`，通过 webpack 转换成一个 `bundle.js` 之后，就只需要 `<script src="bundle.js"></script>` 这么一个文件就可以了，对于一个有几十个 js 文件的项目来说，简直是不可多得。怎么做到的？还是很懵逼？Webpack 有四个核心概念，接下来是一步一步的解释。

## 码
首先，确认电脑里面已经安装了 `npm` 和 `node`, 在 terminal 输入 `npm -v` 和 `node -v` 可以查看，没有的话随便搜索都可以找到。然后我们就可以正式开始 webpack 之旅了。
### 安装
新建一个文件夹，并进入文件夹
```
mkdir webpack-tut
cd webpack-tut
```

初始化
```
npm init
/* 命个名，其他的都回车跳过
   name: (webpack-tut) webpack-starter
   version: (1.0.0)
   description: webpack-starter */
```
完成后文件夹里有多出一个`package.json`文件，是整个项目的配置文件。

在该项目目录下 安装 Webpack。如果是第一次安装，也在全局环境下安装。

```
npm i -D webpack
npm i -g webpack // 全局安装
```

运行完后，会出现名为 node_modules 的文件夹，里面一堆的 library，这个文件夹就放着就行，不用去管它。
注意看一下 webpack 的版本，2017年4月8日还是2.3.3，如果版本过低可能会出现一些问题，可以选择安装某个版本
```
npm i -D webpack@<version> //e.g. npm i -D webpack@2.3.3
```

### 创建第一个 webpack 应用
新建两个文件夹 src，dist。打包前的文件放在 src 里，文件会自动打包后放在 dist 里。
```powershell
mkdir src
mkdir dist
```

在根目录里新建文件 webpack.config.js，并在 src 里新建文件 app.js，两个文件的代码如下：

```javascript
// app.js
console.log('Hello world');

// webpack.config.js
module.exports = {
    entry: './src/app.js',
    output: {
        filename: './dist/app.bundle.js'
    }
}
```
在根目录下运行webpack：
```
webpack -d
```

就能看到一个 `app.bundle.js` 的文件自动生成在了 dist 文件夹里。在文件末尾，可以看到
```javascript
/*!********************!*\
  !*** ./src/app.js ***!
  \********************/
/***/ (function(module, exports) {
eval("console.log('Hello');\n//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiMC5qcyIsInNvdXJjZXMiOlsid2VicGFjazovLy8uL3NyYy9hcHAuanM/N2FjOSJdLCJzb3VyY2VzQ29udGVudCI6WyJjb25zb2xlLmxvZygnSGVsbG8nKTtcblxuXG5cbi8vLy8vLy8vLy8vLy8vLy8vL1xuLy8gV0VCUEFDSyBGT09URVJcbi8vIC4vc3JjL2FwcC5qc1xuLy8gbW9kdWxlIGlkID0gMFxuLy8gbW9kdWxlIGNodW5rcyA9IDAiXSwibWFwcGluZ3MiOiJBQUFBOyIsInNvdXJjZVJvb3QiOiIifQ==");
/***/ })
```
恭喜你已经成功的使用了一次 webpack。

先讲上面过程涉及的 Webpack 里两个核心的概念 entry（入口） 和 output（输出） ，**entry 是初始文件的路径，output 是自动生成后的文件路径和文件名。**

### 将文件自动插入 HTML 中
#### 初步使用
首先安装 [html-webpack-plugin](https://github.com/jantimon/html-webpack-plugin)
```
npm install html-webpack-plugin --save-dev
```
修改文件 `webpack.config.js`，在 output 里加入 路径，并加入 plugins
```javascript
// webpack.config.js
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/app.js',
    output: {
        filename: './dist/app.bundle.js'
    },
    plugins: [new HtmlWebpackPlugin()]
}
```

运行 `webpack -d`,  自动生成了 `index.html`，并且自动把打包后的文件 `app.bundle.js` 加到了里面。
```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Webpack App</title>
  </head>
  <body>
  <script type="text/javascript" src="app.bundle.js"></script></body>
</html>
```

#### 自定义
`html-wepack-plugin` 允许我们能够自定义一些内容，比如说使用固定的模版。接下来讲下如何用固定的 html 模版去生成文件。首先修改 webpack.config.js
```javascript
// webpack.config.js
const path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/app.js',
    output: {
    	path: path.resolve(__dirname, 'dist'),
        filename: 'app.bundle.js'
    },
    plugins: [
		new HtmlWebpackPlugin({
			title: 'Title From Config',
			hash: true,
			filename: 'index.html',
			template: './src/index.html'
		})
    ]
}
```

在 src 目录下新建文件 `index.html`
```
<!DOCTYPE html>
<html>
	<head>
    	<meta charset="UTF-8">
    	<title><%= htmlWebpackPlugin.options.title %></title>
  	</head>
  	<body>
	  	<p>You are awesome.</p>
  	</body>
</html>
```

运行 `webpack -d`, 结果生成的 `index.html` 为：
```
<!DOCTYPE html>
<html>
	<head>
    	<meta charset="UTF-8">
    	<title>Title From Config</title>
  	</head>
  	<body>
	  	<p>Some contents here, some others</p>
  	<script type="text/javascript" src="app.bundle.js?0b89768d13f4a86e6d19"></script></body>
</html>
```
使用了 src 文件夹下的 index.html 为模版，传递了`webpack.config.js` 里的 title 的值，并且对生成的 `app.bundle.js` 未见进行了 hash 处理。

更多关于 `html-webpack-plugin` 的配置，可以看看官方文档：https://github.com/jantimon/html-webpack-plugin

这部分涉及到 webpack 另外一个核心概念：plugins。**plugins 是 webpack 的支柱功能，扩展了 webpack 的功能。**

### 载入 CSS
首先，还是要安装一下相应的库。
```powershell
npm install css-loader --save-dev
npm install style-loader --save-dev
```

下一步就是进行 webpack 的配置，在 webpack.config.js 里进行，修改后如下：
```javascript
// webpack.config.js
const path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/app.js',
    output: {
    	path: path.resolve(__dirname, 'dist'),
        filename: 'app.bundle.js'
    },
    module: {
    	rules: [
    		{
    			test: /\.css$/,
    			use: ['style-loader', 'css-loader']
    		}
    	]
    },
    plugins: [
		new HtmlWebpackPlugin({
			title: 'Title From Config',
			hash: true,
			filename: 'index.html',
			template: './src/index.html'
		})
    ]
}
```

在 src 目录下，新建 app.css
```
// app.css
body {
	background-color: lightblue;
}
```

 运行 `webpack -d`，双击打开 dist/index.html，背景是浅蓝色的，但是 dist 文件夹里没有多处一个 app.css 的文件，那是因为 css 文件在加载的过程中，被转换打包到了 app.bundle.js 里面了，在这之中起作用的就是 webpack 的最后一个核心概念，loaders（加载器）。**loaders 的作用就是对资源文件进行转换。**

## 总结
通过基础入门，和加载 HTML, CSS，将 Webpack 的四大核心概念讲完啦：
- entry 是初始文件的路径
- output 是自动生成后的文件路径和文件名。
- loaders 的作用是对资源文件进行转换。
- plugins 是 webpack 的支柱功能，扩展了 webpack 的功能。

全部文件代码：
```javascript
// package.json
{
  "name": "webpack-starter",
  "version": "1.0.0",
  "description": "webpack-starter",
  "main": "index.js",
  "scripts": {
    "dev": "wepack -d"
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "css-loader": "^0.28.0",
    "html-webpack-plugin": "^2.28.0",
    "node-sass": "^4.5.2",
    "style-loader": "^0.16.1",
    "webpack": "^2.3.3"
  }
}


// webpack.config.js
const path = require('path');
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: './src/app.js',
    output: {
    	path: path.resolve(__dirname, 'dist'),
        filename: 'app.bundle.js'
    },
    module: {
    	rules: [
    		{
    			test: /\.css$/,
    			use: ['style-loader', 'css-loader']
    		}
    	]
    },
    plugins: [
		new HtmlWebpackPlugin({
			title: 'Title From Config',
			hash: true,
			filename: 'index.html',
			template: './src/index.html'
		})
    ]
}

// src/app.js
const css = require('./app.css');
console.log('Hello');

// src/app.css
body {
	background: lightblue;
}

// src/index.html
<!DOCTYPE html>
<html>
	<head>
    	<meta charset="UTF-8">
    	<title><%= htmlWebpackPlugin.options.title %></title>
  	</head>
  	<body>
	  	<p>Some contents here, some others</p>
  	</body>
</html>
```

全文借鉴了视频 [Webpack 2 Tutorial](https://www.youtube.com/watch?v=JdGnYNtuEtE) by Ihatetomatoes
看完前几个视频并跟着做，大改要40分钟到1小时。
看这篇的话可以快很多。

写这种技术类的，各种粘代码的真实耗时费力。感谢那些好好写文档的程序员们！
