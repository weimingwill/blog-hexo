---
title: HTML Form 传值
date: 2017-04-04 00:57:20
tags:
---
今天碰到一个 HTML 的问题，一个表单在提交后，到达 action 指向的页面后，在连接中所传递的值，都直接被删除了的问题。比如 `<form action="http://dest.com?id=1" method="GET"></form>`，这个表单在提交后，网页的链接为 `http://dest.com?` 而后面本来想要传递的值 `id = 1` 没了。

以前在处理 form 的传值上，多数为 `POST` method, 直接用 `JS` 提取表格内输入的值，这种方式因为项目给的时候，用了这种方法，不想大改，就继续沿用。出现这个问题的原因是，在提交表单后，浏览器会自动用表单里面的内容生成新的 `key=value` 来替换掉原来问号后面的内容。

正确的做法也挺简单，如下
```
<form action="http://dest.com?id=1" method="GET">
    <input type="hidden" name="id" value="1">
</form>
```
这样就搞定了。

更多例子和解释参照：http://stackoverflow.com/questions/1116019/submitting-a-get-form-with-query-string-params-and-hidden-params-disappear