---
title: 如何用 Vue + Vuetify 快速建站？
date: 2017-09-28 22:06:40
tags: [技术,Vue]
---
> 懂点基础，学点套路，轻松用 Vue 写个网站

<!-- more -->

几个月前用 Vue + Vuetify 这一套框架写了个 仓库管理系统 和 个人网站，近来不写前端了，所以整理了如何用 Vue，Vuetify，Vuex，Vue-router 写一个单页应用 (SPA)，为以后回忆方便，也供初学者参考，少踩坑。

（这篇不是 Vue 的基础介绍，所以建议先读了 Vue 的官方文档，再来看怎么应用。）

这篇以开发的个人网站为例，从一个空文件夹开始讲到完整个网站，其中包括这几个模块：
1. 配置开发环境
2. 配置 Webpack
2. 将 Vuex + Vue-router + Vue-router-sync + Vuetify 整合到整个

（代码参考 https://github.com/weimingwill/personal-website 。整个代码的文件结构和重要文件放在下面，可以边读边参考。结构如下：）
```
.
├── package.json
├── webpack.config.js
├── node_modules
├── build
│   ├── utils.js
│   └── vue-loader.conf.js
├── config
│   ├── dev.env.js
│   ├── index.js
│   ├── prod.env.js
│   └── test.env.js
├── src
│   ├── assets
│   │   ├── images
│   ├── css
│   │   ├── google-material-icons.css
│   │   └── main.css
│   ├── router
│   │   └── index.js
│   ├── store
│   │   ├── actions.js
│   │   ├── getters.js
│   │   ├── index.js
│   │   ├── modules
│   │   │   ├── app.js
│   │   │   ├── contacts.js
│   │   │   ├── menu
│   │   │   │   ├── index.js
│   │   │   │   └── lazyLoading.js
│   │   │   ├── projects.js
│   │   │   └── skills.js
│   │   └── mutation-types.js
│   ├── index.html
│   ├── main.js
│   ├── App.vue
│   └── views
│       ├── About.vue
│       ├── Blog.vue
│       ├── Contact.vue
│       ├── Resume.vue
│       ├── Skills.vue
│       ├── layout
│       │   ├── AppMain.vue
│       │   ├── Sidebar.vue
│       │   └── Toolbar.vue
│       └── projects
│           ├── Projects.vue
│           └── components
│               └── ProjectCard.vue
```

## 配置开发环境
首先，确保系统安装了 Node.js，安装 Node.js 的同时也安装了 npm。

创建一个新的文件夹，在这个文件夹里进行初始化：
```
npm init
```
根据提示，填入对应信息，完成后会自动生成 `package.json` 文件，填入的信息都可以在这个文件下做更改。下一步是安装开发需要的库：
```
npm install vue
npm install webpack
...
...
```
执行后，会自动下载库到根目录下的 `node_modules` 里。因为 Vue 有一些要用的库，webpack 还有许多要用的库，一一安装比较麻烦，可以直接去我的 Github 上面复制 `package.json` 里买的内容，替换本地的文件内的内容，然后执行
```
npm install
```
所有需要的东西应有尽有。到这里就完成了最基本的环境配置。

## Webpack 配置
什么是 Webpack ？Webpack 是一个打包器，能够将各种不同格式的 js, css, jpg 等等，打包成一个或几个js文件，然后可以直接在 html 里使用打包后的文件，减少了各个文件之间相互依赖的麻烦。Webpack 入门可以参考早些写的文章 [Wepack快速入门实践](http://www.jianshu.com/p/7f121a84a474)。

Webpack 主配置文件是 `webpack.config.js`，另外有一些配置文件分别在 `build` 和 `config` 文件夹里，可以直接将这三个复制项目根目录，重点讲下 Webpack 里比较重要的地方。

1. 起始点和输出
```
  entry: {
    app: './src/main.js'
  },
  output: {
    path: path.resolve(__dirname, ''),
    filename: 'app.js'
  },
module: {
...
}
```
这里使用 `src` 文件下的 `main.js` 作为 Webpack 执行的起始点，将 module 下面定义了的各种不同文件格式，通过不同的 loader，在执行后，自动打包成根目录下的 `app.js`。( main.js 是最主要的一个 js 文件，具体内容稍后分解。）

2. `HtmlWebpackPlugin` 使用 `src` 文件下的 `index.html` 作为模版，在执行后，自动在根目录下生成 `index.html` 不同的地方是，根目录下的这个文件，包含了前面提到的自动生成的 `app.js`
```
<script type="text/javascript" src="app.js"></script>
```
3. 怎么执行 webpack?
```
npm run dev
```
在根目录下运行上面代码就可以运行 webpack 进行打包，原因是在  `package.json` 文件里，在 `scripts` 里定义了这个命令。
```
{
  "scripts": {
    "dev": "webpack -d --watch",
    "test": "echo \"Error: no test specified\" && exit 1"
  }, ...
}
```
到这里就完成了最重要的两部分基础配置，接下来是如何用 Vue, Vuetify, Vuex, Vue-router, Vue-router-sync。

## Vuetify + Vuex + Vue-router + Vue-router-sync
这里侧重讲怎么将这些都结合在一起使用，每个库的细节还是要大家自己去看官方文档，每个官方文档链接附录在最后。这些库主要通过一个文件结合使用 `src/main.js`

```
// src/main.js
import Vue from 'vue'
import Vuetify from 'vuetify'
import App from './App'
import store from './store'
import router from './router'
import { sync } from 'vuex-router-sync'

Vue.use(Vuetify);
sync(store, router);

new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
});
```
### Vuetify
Vuetify 是基于 Vue 的前端组件框架，设计样式用的是 Google Material Design。
```
import Vue from 'vue'
import Vuetify from 'vuetify'
Vue.use(Vuetify);
```
这三行代码，实现了加载并使用 Vuetify。
```
import App from './App'
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
});
```
先忽略 router 和 store。这里先是加载了 `src/App.vue`，这个文件是使用 Vuetify 的起始文件。
```
// src/App.vue
<div id="app">
  <v-app>......</v-app>
</div>
```
`el: #app` 指向的就是这里的 `id="app"`。所有其他组件都是写在 `<v-app></v-app>` 之间的，通常是在这页定义出整个应用的模版，比如 sidebar，navigation bar 和主要区域。然后再根据不同的页面，创建不同的 `.vue` 文件，通常每个页面都是一个单独的文件，有公用的模块可以写在一个地方。

### Vuex
Vuex 是一个状态管理器，对应的是 `src/store` 下面的代码，Vuex 主要概念有 state, getters, mutations, actions 和 modules。全局的 `getters` 和 `actions` 写在 `src/store/getters.js` 和 `src/store/actions.js` 里，在 Vuetify 中提到每有一个单独的 `.vue` 文件，每个 vue 的文件都可以抽象当成一个 module，每个
 module 有单独的 `.js` 与之对应，里面包含了这个页面的 state, getters, mutations, actions。举个例子，我们有一个 `Contact.vue` 文件，对应的 `src/store/modules` 里有一个 `contacts.js` 文件，如下：
```
// src/store/modules/contacts.js
import * as types from '../mutation-types'

const state = {
  contacts: []
}

const getters = {
  contacts: state => state.contacts,
}

const mutations = {
  [types.READ_CONTACTS] (state) {
    let contactMethods = require('../../assets/contact-methods.json')
    state.contacts = contactMethods.methods
  }
}

const actions = {
  readContacts ({commit}) {
    commit(types.READ_CONTACTS);
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
```
 这样的文件结构的好处是让每个页面都是相对独立的，逻辑，代码都比较清晰。

Vuex 里另外一个要提的是 modules 里有另外一个文件夹 `menu`，顾名思义，是整个应用的目录。代码如下
```
const state = {
  items: [
    {
      title: 'Projects',
      path: '/projects',
      isMenu: true,
      router: true,
      icon: 'computer',
      component: lazyLoading('projects/Projects'),
    },...
  ]
}
```
具体定义了每一个组件(component) 的名字，图标，位置，路由的地址等，具体怎么实现路由的稍后在 Vue-router 里细说，这里重点看 `Lazyloading()` 这个函数。
```
// src/store/modules/menu/lazyloading.js
export default (name, index = false) => () => require.ensure([], (require) => require(`../../../views/${name}${index ? '/index' : ''}.vue`))
```
文件里面只有这一行代码，用处是告诉 webpack 在加载 `.vue` 文件时，知道去哪里找这个文件，比如
`lazyLoading('projects/Projects')` 指的是 `../../../views/projects/Projects.vue`，也就是 `src/views/projects/Proejcts.vue` 这个文件。当 `lazyloading('xxxx', index=true)` 时，会去找 `xxxx` 文件夹下面的 `index.vue`。

### Vue-router
Vue-router 对应了 `src/router/index.js` 里的代码。
```
import Vue from 'vue'
import Router from 'vue-router'
import menuModule from 'vuex-store/modules/menu'

Vue.use(Router);

export default new Router({
  routes: [
    ...generateRoutesFromMenu(menuModule.state.items),
    {
      path: '*',
      redirect: '/projects'
    }
  ]
})

function generateRoutesFromMenu (menu = [], routes = []) {
  for (let i = 0, l = menu.length; i < l; i++) {
    let item = menu[i];
    if (item.path) {
      routes.push(item)
    }
    if (!item.component) {
      generateRoutesFromMenu(item.subItems, routes)
    }
  }
  return routes
}
```
将应用的所有路径都定义在
```
new Router({
  routes: [
   ......
  ]
})
```
`generateRoutesFromMenu` 这个函数的作用是将定义在 `src/store/modules/menu` 里的每个目录里包含了 component 的加载进应用的路由里，path 对应的是路径，component 是指向哪个 `.vue` 文件，比如 Vuex 那个例子，访问 `host:port/projects` 这个页面，应用会加载 `src/views/projects/Project.vue`。
```
{
  path: '*',
  redirect: '/projects'
}
```
 这个的作用是用户访问任何没有定义的路径时，自动重新载入到 `host:port/projects` 这个页面，正常可以写一个错误页面。

到这边就简单的介绍了如何使用 Vuetify, Vuex, Vue-router，最后在 `src/main.js` 里，加载 store 和 router，放到 `new Vue()` 里就可以了
```
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
});
```

一篇文章能介绍的内容实在有限，只是比较大概的介绍了整体各个模块怎么结合，还有许多细节需要参考文档，已经在写代码的过程中去排雷，权当一个抛砖引玉了。

大家有碰到什么这方面的问题可以留言，一定尽力解答。一些文档附录在下面，供大家参考。

Vue: https://vuejs.org/
Vuetify: https://vuetifyjs.com/
Vuex: https://vuex.vuejs.org/
Vue-router: https://router.vuejs.org/
Vue-router-sync: https://github.com/vuejs/vuex-router-sync
