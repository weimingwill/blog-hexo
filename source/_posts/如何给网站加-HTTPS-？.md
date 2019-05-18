---
title: 如何给网站加 HTTPS ？
tags:
  - 技术
  - 网络
  - HTTPS
abbrlink: 877d8f5d
date: 2019-05-18 15:33:15
---
HTTPS 是在 HTTP 上加上 SSL/TLS，能更好的确保网站数据的安全性。最近想给个人网站加上 HTTPS，因为个人网站和博客都是在同一个服务器上，用 nginx 给两个网址做代理，不像只有一个网站那么直接，踩了一些坑，用一篇文章总结梳理一下。

<!-- more -->

环境：
服务器提供商：DigitalOcean
操作系统：Ubuntu
Web 服务器：nginx
网址： zhuangweiming.me，blog.zhuangweiming.me

SSL/TLS 证书我用的是 Let’s Encrypt 颁发的免费证书，在他们官网上有关于如何用 `certbot` 配置 `HTTPS` 的全教程，但是因为情况比较特殊，按照规规矩矩的教程走下来，没有办法配置成功。

> 建议在开始安装之前，先将 `/etc/nginx` 文件夹，nginx 的配置备份一下，以防在安装的时候没有成功，nginx 的配置被 certbot 搞乱了。如果不幸出现了问题，可以尝试 `certbot --nginx rollback`

## 安装 Certbot
```
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx python3-certbot-dns-digitalocean
```

## 安装 DigitalOcean DNS Plugin
```
sudo apt-get install python3-certbot-dns-digitalocean
```

因为要能支持 `*.zhuangweiming.me ` 这种 wildcard 模式来配置 blog.zhuangweiming.me，还需要额外安装 `dns-plugin`，服务器在 DigitalOcean 上，所以需要再安装 `python3-certbot-dns-digitalocean`

然后要添加 DigitalOcean API Token。可以到 DigitalOcean 自己的服务器上去获得。
https://cloud.digitalocean.com/settings/api/tokens

复制 Token 放到服务器里 `~/.secrets/certbot/digitalocean.ini`  这个路径文件里。

```
mkdir ~/.secrets/
mkdir ~/.secrets/certbot
vim ~/.secrets/certbot/digitalocean.ini
```

```
# digitalocean.ini 文件
# DigitalOcean API credentials used by Certbot*
dns_digitalocean_token = 0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff
```

## 安装证书
```
sudo certbot --dns-digitalocean --dns-digitalocean-credentials ~/.secrets/certbot/digitalocean.ini -i nginx -d "*.zhuangweiming.me" -d zhuangweiming.me --server https://acme-v02.api.letsencrypt.org/directory
```
在安装 cerbot 之后，如果直接运行命令安装证书，可能会有 `DNS problem: NXDOMAIN looking up TXT for` 的错误。原因是因为在域名的网站里没有证书对应的 TXT record。

```
sudo certbot certonly --manual --preferred-challenges=dns -d "*.zhuangweiming.me" -d zhuangweiming.me --server https://acme-v02.api.letsencrypt.org/directory
```
解决方案可以运行这个命令。`certonly` 的作用是只生成证书，不安装。每一步都可以尝试生成证书，再真正安装。运行后，会有如下结果。
```
Please deploy a DNS TXT record under the name
_acme-challenge.zhuangweiming.me with the following value:
D90SJOkhPoSJfn-0LOqcknOPtAQED_P_SawxPOqdQkz
```

复制的 TXT record 的值，在域名 DNS 里添加一个 TXT record。我的域名是在 namecheap 上的，添加后如下图。

[image:3987F52A-78E7-464A-A81F-A13D96015FFE-256-0000EADDFA342573/6951F7F4-72A6-48F8-AAE5-C647884AA846.png]

```
sudo certbot --dns-digitalocean --dns-digitalocean-credentials ~/.secrets/certbot/digitalocean.ini -i nginx -d "*.zhuangweiming.me" -d zhuangweiming.me --server https://acme-v02.api.letsencrypt.org/directory
```
然后运行代码安装证书。

```
- Congratuations! Your certificate and chain have been saved at...
```
看到这个信息表示安装成功了。

## 设置防火墙
虽然证书安装成功了，但是 https://zhuangweiming.me 还是上不去，有可能是防火墙还不允许 HTTPS.

```
# 查看防火墙状态
sudo ufw status
```

结果可能如下。说明只允许 HTTP 请求。
```
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Nginx HTTP                 ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Nginx HTTP (v6)            ALLOW       Anywhere (v6)
```

```
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
```

运行上面代码允许 HTTPS 请求通过。再次查看防火墙状态。

```
sudo ufw status
```

结果如下图，再次访问 https://zhuangweiming.me 就没什么问题啦。
```
Output
Status: active

To                         Action      From
--                         ------      ----
OpenSSH                    ALLOW       Anywhere
Nginx Full                 ALLOW       Anywhere
OpenSSH (v6)               ALLOW       Anywhere (v6)
Nginx Full (v6)            ALLOW       Anywhere (v6)
```

## 一些有用的工具和命令行
https://check-your-website.server-daten.de/
这个网站可以查看网页的 DNS，证书，TXT record 。

```
# 查看证书
sudo certbot certificates
```

```
# 查看所有的证书，以及现在用的是哪个证书
sudo ls -alR /etc/letsencrypt/{archive,live,renewal}
```

## References
[Generate Wildcard SSL certificate using Let’s Encrypt/Certbot](https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7)
[How To Secure Nginx with Let’s Encrypt on Ubuntu 16.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04)


https://medium.com/@saurabh6790/generate-wildcard-ssl-certificate-using-lets-encrypt-certbot-273e432794d7

https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04
