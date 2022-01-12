  
*  ### WebIM视屏聊天系统采用PHP + Swoole + Redis + Mysql + Comet + WebRtc + Golang等技术架构  
*** 
在线演示地址 ：![在线演示地址](https://github.com/DOUBLE-Baller/WebRTC_IM/blob/master/web/static/img/web.png) app下载 ：![app下载](https://github.com/DOUBLE-Baller/WebRTC_IM/blob/master/web/static/img/app.png) https://wwa.lanzoui.com/i4P0Ot1mnza
***
![演示地址](https://github.com/DOUBLE-Baller/WebRTC_IM/blob/master/IM.gif?raw=true)
微信：BCFind5
***
IM 篇 聊天部分
========
##`Go IM` 一个支持集群的im及实时推送服务。
---------------------------------------
  * [特性](#特性)
  * [安装](#安装)
  * [配置](#配置)
  * [例子](#例子)
  * [文档](#文档)
  * [集群](#集群)
  * [更多](#更多)

---------------------------------------

## 特性
 * 轻量级
 * 高性能
 * 纯Golang实现
 * 支持单个、多个、单房间以及广播消息推送
 * 支持单个Key多个订阅者（可限制订阅者最大人数）
 * 心跳支持（应用心跳和tcp、keepalive）
 * 支持安全验证（未授权用户不能订阅）
 * 多协议支持（websocket，tcp）
 * 可拓扑的架构（job、logic模块可动态无限扩展）
 * 基于Kafka做异步消息推送

## 安装
### 一、安装依赖
```sh
$ yum -y install java-1.7.0-openjdk
```

### 二、安装Kafka消息队列服务

kafka在官网已经描述的非常详细，在这里就不过多说明，安装、启动请查看[这里](http://kafka.apache.org/documentation.html#quickstart).

### 三、搭建golang环境
1.下载源码(根据自己的系统下载对应的[安装包](http://golang.org/dl/))
```sh
$ cd /data/programfiles
$ wget -c --no-check-certificate https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
$ tar -xvf go1.5.2.linux-amd64.tar.gz -C /usr/local
```
2.配置GO环境变量
(这里我加在/etc/profile.d/golang.sh)
```sh
$ vi /etc/profile.d/golang.sh
# 将以下环境变量添加到profile最后面
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=/data/apps/go
$ source /etc/profile
```

### 四、部署goim
1.下载goim及依赖包
```sh
$ yum install hg
$ go get -u github.com/Terry-Mao/goim
$ mv $GOPATH/src/github.com/Terry-Mao/goim $GOPATH/src/goim
$ cd $GOPATH/src/goim
$ go get ./...
```

2.安装router、logic、comet、job模块(配置文件请依据实际机器环境配置)
```sh
$ cd $GOPATH/src/goim/router
$ go install
$ cp router-example.conf $GOPATH/bin/router.conf
$ cp router-log.xml $GOPATH/bin/
$ cd ../logic/
$ go install
$ cp logic-example.conf $GOPATH/bin/logic.conf
$ cp logic-log.xml $GOPATH/bin/
$ cd ../comet/
$ go install
$ cp comet-example.conf $GOPATH/bin/comet.conf
$ cp comet-log.xml $GOPATH/bin/
$ cd ../logic/job/
$ go install
$ cp job-example.conf $GOPATH/bin/job.conf
$ cp job-log.xml $GOPATH/bin/
```
到此所有的环境都搭建完成！

### 五、启动goim
```sh
$ cd /$GOPATH/bin
$ nohup $GOPATH/bin/router -c $GOPATH/bin/router.conf 2>&1 > /data/logs/goim/panic-router.log &
$ nohup $GOPATH/bin/logic -c $GOPATH/bin/logic.conf 2>&1 > /data/logs/goim/panic-logic.log &
$ nohup $GOPATH/bin/comet -c $GOPATH/bin/comet.conf 2>&1 > /data/logs/goim/panic-comet.log &
$ nohup $GOPATH/bin/job -c $GOPATH/bin/job.conf 2>&1 > /data/logs/goim/panic-job.log &
```
如果启动失败，默认配置可通过查看panic-xxx.log日志文件来排查各个模块问题.

### 六、测试
## Arch
![benchmark](https://github.com/DOUBLE-Baller/WebRTC_IM/blob/master/goim-server/docs/arch.png)

### Benchmark Server
| CPU | Memory | OS | Instance |
| :---- | :---- | :---- | :---- |
| Intel(R) Xeon(R) CPU E5-2630 v2 @ 2.60GHz  | DDR3 32GB | Debian GNU/Linux 8 | 1 |

### Benchmark Case
* Online: 1,000,000
* Duration: 15min
* Push Speed: 40/s (broadcast room)
* Push Message: {"test":1}
* Received calc mode: 1s per times, total 30 times

### Benchmark Resource
* CPU: 2000%~2300%
* Memory: 14GB
* GC Pause: 504ms
* Network: Incoming(450MBit/s), Outgoing(4.39GBit/s)

### Benchmark Result
* Received: 35,900,000/s

推送协议可查看[push http协议文档](./docs/push.md)

## 配置

TODO

## 例子

Websocket: [Websocket Client Demo](https://github.com/DOUBLE-Baller/WebRTC_IM/tree/master/im/examples/javascript)

Android: [Android](https://github.com/DOUBLE-Baller/WebRTC_IM/tree/master/goim-java-sdk)

iOS: [iOS](https://github.com/DOUBLE-Baller/WebRTC_IM/tree/master/goim-oc-sdk)

## 文档
[push http协议文档](./docs/push.md)推送接口

## 集群

### comet

comet 属于接入层，非常容易扩展，直接开启多个comet节点，修改配置文件中的base节点下的server.id修改成不同值（注意一定要保证不同的comet进程值唯一），前端接入可以使用LVS 或者 DNS来转发

### logic

logic 属于无状态的逻辑层，可以随意增加节点，使用nginx upstream来扩展http接口，内部rpc部分，可以使用LVS四层转发

### kafka

kafka 可以使用多broker，或者多partition来扩展队列

### router

router 属于有状态节点，logic可以使用一致性hash配置节点，增加多个router节点（目前还不支持动态扩容），提前预估好在线和压力情况

### job

job 根据kafka的partition来扩展多job工作方式，具体可以参考下kafka的partition负载


### 使用PHP+Swoole实现的网页即时聊天工具，

* 全异步非阻塞Server，可以同时支持数百万TCP连接在线
* 基于websocket+flash_websocket支持所有浏览器/客户端/移动端
* 支持单聊/群聊/组聊等功能
* 支持永久保存聊天记录，使用MySQL存储
* 基于Server PUSH的即时内容更新，登录/登出/状态变更/消息等会内容即时更新
* 用户列表和在线信息使用Redis存储
* 支持发送连接/图片/语音/视频/文件
* 支持Web端直接管理所有在线用户和群组
>`后续待开发功能有：视屏留言，远程演示，远程桌面,视屏群聊等`
> 最新的版本已经可以原生支持IE系列浏览器了，基于Http长连接

 ----
|安装| 
 ----
swoole扩展
```shell
pecl install swoole
```

swoole框架
```shell
composer install
```

运行
----
将`webroot`目录配置到Nginx/Apache的虚拟主机目录中，使`webroot/`可访问。

详细部署说明
----

__1. 安装composer(php依赖包工具)__

```shell
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

注意：如果未将php解释器程序设置为环境变量PATH中，需要设置。因为composer文件第一行为#!/usr/bin/env php，并不能修改。
更加详细的对composer说明：http://blog.csdn.net/zzulp/article/details/18981029

__2. composer install__

切换到PHPWebIM项目目录，执行指令composer install，如很慢则

```shell
composer install --prefer-dist
```

__3. Ningx配置__

* 这里未使用swoole_framework提供的Web AppServer  
* Apache请参照Nginx配置，自行修改实现
* 这里使用了`im.swoole.com`作为域名，需要配置host或者改成你的域名

```shell
server {
    listen       80;
    server_name  im.swoole.com;
    index index.html index.php;
    
    location / {
        root   /path/to/webim/webroot;

        proxy_set_header X-Real-IP $remote_addr;
        if (!-e $request_filename) {
            rewrite ^/(.*)$ /index.php;
        }
    }
    
    location ~ .*\.(php|php5)?$ {
	    fastcgi_pass  127.0.0.1:9000;
	    fastcgi_index index.php;
	    include fastcgi.conf;
    }
}
```
`**注意：https下必须采取wss  So-有两种方案 1.采用nginx 反向代理4431端口 swoole 的端口和4431进行通讯。2.swoole 确认是否启用了openssl，是否在编译时加入了--enable-openssl的支持,然后在set 证书路径即可。两种方案选择其一就好，不过第一种方案有个潜在神坑就是你通过反向代理拿不到真实的IP地址了,这点值得注意，Nginx有办法拿到真实的ip，不懂可以私聊我，光wss的坑太多了就不一一说了。**`  
__4. 修改配置__

* 配置`configs/db.php`中数据库信息，将聊天记录存储到MySQL中
* 配置`configs/redis.php`中的Redis服务器信息，将用户列表和信息存到Redis中

表结构
```sql
CREATE TABLE `webim_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `type` varchar(12) COLLATE utf8mb4_bin NOT NULL,
  `msg` text COLLATE utf8mb4_bin NOT NULL,
  `send_ip` varchar(20) COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin
```

* 修改`configs/webim.php`中的选项，设置服务器的URL和端口
```php
$config['server'] = array(
    //监听的HOST
    'host' => '0.0.0.0',
    //监听的端口
    'port' => '9503',
    //WebSocket的URL地址，供浏览器使用的
    'url' => 'ws://im.xxx.com:9503',
    //用于Comet跨域，必须设置为web页面的URL
    //比如你的网站静态页面放在 http://im.xxx.com:8888/main.html
    //这里就是 http://im.xxx.com:8888
    'origin' => 'http://im.xxx.com:8888',
);
```

* server.host server.port 项为WebIM服务器即WebSocket服务器的IP与端口，其他选择项根据具体情况修改
* server.url对应的就是服务器IP或域名以及websocket服务的端口，这个就是提供给浏览器的WebSocket地址
* server.origin为Comet跨域设置，必须修改origin才可以支持IE等不支持WebSocket的浏览器

__5. 启动WebSocket服务器__

```shell
php server.php start 
```

IE浏览器不支持WebSocket，需要使用FlashWebSocket模拟，请修改flash_policy.php中对应的端口，然后启动flash_policy.php。
```shell
php webim/flash_policy.php
```

__6. 绑定host与访问聊天窗口（可选）__

如果URL直接使用IP:PORT，这里不需要设置。

```shell
vi /etc/hosts
```

增加

```shell
127.0.0.1 
```

用浏览器打开：https://XXX.com

快速了解项目架构
----

1.目录结构

```
+ webim
  |- server.php //WebSocket协议服务器
  |+ swoole.ini // WebSocket协议实现配置
  |+ configs //配置文件目录
  |+ webroot
    |+ static
    |- config.js // WebSocket配置
  |+ log // swoole日志及WebIM日志
  |+ src // WebIM 类文件储存目录
    |+ Store
      |- File.php // 默认用内存tmpfs文件系统(linux /dev/shm)存放天着数据，如果不是linux请手动修改$shm_dir
      |- Redis.php // 将聊天数据存放到Redis
    |- Server.php // 继承实现WebSocket的类，完成某些业务功能
  |+ vendor // 依赖包目录
```

2.Socket Server与Socket Client通信数据格式

如：登录

Client发送数据

```js
{"cmd":"login","name":"xdy","avatar":"http://tp3.sinaimg.cn/1586005914/50/5649388281/1"}
```

Server响应登录

```js
{"cmd":"login", "fd": "31", "name":"xdy","avatar":"http://tp3.sinaimg.cn/1586005914/50/5649388281/1"}
```

可以看到cmd属性，client与server发送时数据都有指定，主要是用于client或者server的回调处理函数。

3.需要理清的几种协议或者服务的关系

http协议：超文本传输协议。单工通信，等着客户端请求之后响应。

WebSocket协议：是HTML5一种新的协议，它是实现了浏览器与服务器全双工通信。服务器端口与客户端都可以推拉数据。

Web服务器：此项目中可以用基于Swoole的App Server充当Web服务器，也可以用传统的nginx/apache作为web服务器

Socket服务器：此项目中浏览器的WebSocket客户端连接的服务器，swoole_framework中有实现WebSocket协议PHP版本的服务器。

WebSocket Client：实现html5的浏览器都支持WebSocket对象，如不支持此项目中有提供flash版本的实现。
  
***
WebRtc篇 音视频部分 （重点难点部分）
========
*  ### 一、webrtc介绍（注意以下所有的资源必须翻墙,实在无办法翻墙的可以进群文件or私聊我）  
  [官方网站](http://webrtc.org)（官网还是最权威的）        
  `2013谷歌I/O大会对WebRTC的介绍`：[视频](https://www.youtube.com/watch?v=p2HzZkd2A40)，[ppt](http://io13webrtc.appspot.com/#1)（讲的不错）   
  `2012谷歌I/O大会对WebRTC的介绍`：[视频](http://youtu.be/E8C8ouiXHHk)(视频要翻墙)  
 **WebRTC官方源码样例（不含移动端）**：http://github.com/webrtc/samples （看再多理论不如抠一遍源码）  
 **WebRTC在线演示效果**：[http://webrtc.github.io/samples](http://webrtc.github.io/samples) （可以清楚的看到每个接口是怎样被调用的）   
*  ### 二、初学者入门
**官方推荐的入门文章**：http://html5rocks.com/en/tutorials/webrtc/basics（个人感觉讲的有点绕，英文不好估计很难理解）  
**使用WebRTC搭建前端视频聊天室——入门篇**：[http://chinawebrtc.org/?p=271](http://chinawebrtc.org/?p=271)（推荐这篇中文的入门，讲的很细，它的三篇后续教程也很值得一看）  
**WebRTC体系结构**：[http://chinawebrtc.org/?p=338](http://chinawebrtc.org/?p=338)（对整体的把握是很重要的）
通过WebRTC实现实时视频通信：[http://chinawebrtc.org/?p=462](http://chinawebrtc.org/?p=462) （不错的教程）  
`**官方编译教程**`：（理论后，开始实践）  
**[js]** http://www.webrtc.org/native-code/development  
**[android]** http://www.webrtc.org/native-code/android  
**[iOS]** http://www.webrtc.org/native-code/ios  
**看看大牛的编译实践**：  
http://chinawebrtc.org/?p=339  
http://chinawebrtc.org/?p=340  
http://chinawebrtc.org/?p=260  
http://chinawebrtc.org/?p=292  
http://chinawebrtc.org/?p=391  
`使用Tokbox瞬间实现在线视频`：[https://dashboard.tokbox.com/quickstart#1](https://dashboard.tokbox.com/quickstart#1)（需要注册申请一个sdk的key生成token,之后就很方便了）国外已经有视频教程了：[http://www.pluralsight.com/courses/webrtc-fundamentals](https://dashboard.tokbox.com/quickstart#1)（可试看，后需会员）  
WebRTC在`android端`的教程：https://tech.appear.in/2015/05/25/Introduction-to-WebRTC-on-Android/    
`WebRTC在iOS端的教程`：  https://tech.appear.in/2015/05/25/Getting-started-with-WebRTC-on-iOS/    
`Play With WebRTC`：http://chinawebrtc.org/?p=530  
手把手教程：  
[http://io2014codelabs.appspot.com/static/codelabs/webrtc-file-sharing/#1](http://io2014codelabs.appspot.com/static/codelabs/webrtc-file-sharing/#)  
https://bitbucket.org/webrtc/codelab  
*  ### 三、高级教程
**getUserMedia解释**  http://www.html5rocks.com/en/tutorials/getusermedia/intro/  
信令机制的解释：http://www.html5rocks.com/en/tutorials/webrtc/infrastructure/  
使用WebRTC搭建前端视频聊天室——信令篇：  http://chinawebrtc.org/?p=260  
使用WebRTC搭建前端视频聊天室——点对点通信篇：  http://chinawebrtc.org/?p=273  
使用WebRTC搭建前端视频聊天室——数据通道篇：  http://chinawebrtc.org/?p=274  
WebRTC音视频引擎研究(1)–整体架构分析：  http://chinawebrtc.org/?p=355   
WebRTC音视频引擎研究(2)–VoiceEngine音频编解码器数据结构以及参数设置：  http://chinawebrtc.org/?p=356  
WebRTC Native APIs[翻译]：  http://chinawebrtc.org/?p=357  
WebRTC源码分析1——视频显示:  http://chinawebrtc.org/?p=360  
WebRTC源码分析2——图像缩放与颜色空间转换：  http://chinawebrtc.org/?p=365  
WebRTC源码分析3——jpeg编解码：  http://chinawebrtc.org/?p=366  
WebRTC源码分析4——AVI文件读写：  http://chinawebrtc.org/?p=371  
WebRTC源码分析5——VoiceEngine代码解析：  http://chinawebrtc.org/?p=380  
WebRTC源码分析6——音频模块结构分析：  http://chinawebrtc.org/?p=379  
WebRTC源码分析6——AudioProcessing的使用：  http://chinawebrtc.org/?p=381  
webrtc 的回声抵消(aec、aecm)算法简介：  http://chinawebrtc.org/?p=382  
建立一个WebRtc的Android客户端：  http://chinawebrtc.org/?p=260  
WebRtc常见问题集锦：  http://chinawebrtc.org/?p=327
*  ### 四、源码或示例 
`这里面应该是最全最详细的了`：https://www.webrtc-experiment.com/  
`这里面也有不少`：http://simpl.info/  
getUserMedia:
ASCII码的视频（getUserMedia + Canvas + ASCII conversion）:http://idevelop.ro/ascii-camera/  
各种酷炫效果，还能这么玩居然（getUserMedia + WebGL）：http://webcamtoy.com  
svg滤镜https://rawgit.com/SenorBlanco/moggy/master/filterbooth.html  
WebGl实现人脸面具：http://auduno.github.io/clmtrackr/examples/facedeform.html  
用脸玩太空大战：http://shinydemos.com/facekat  
一个录音显示声纹波动的demo:http://webaudiodemos.appspot.com/AudioRecorder  
音频Demo大集合：http://webaudiodemos.appspot.com/  
gUM + WebGL实现录音室：http://lab.aerotwist.com/webgl/audio-room  
RTCDataChannel
一个简单的例子：http://simpl.info/dc  
文件分享：https://sharefest.me/  
一个js类库：http://ozan.io/p/  
实时通信的TogetherJS 类库：https://togetherjs.com/  
用WebRTC实现BitTorrent:https://github.com/feross/webtorrent  
RTCPeerConnection
一个简单的例子：http://simpl.info/pc  
视频聊天示例：https://apprtc.appspot.com/，源码https://code.google.com/p/webrtc/source/browse/#svn%2Ftrunk%2Fsamples%2Fjs%2Fapprtc  
视频聊天示例：https://appear.in/，开发者api:https://developer.appear.in/  
https://bistri.com/  
视频聊天示例：https://talky.io/,源码：https://github.com/henrikjoreteg/SimpleWebRTC  
视频聊天示例：https://tawk.com/  
通过github视频聊天：https://gittogether.com/  
视频聊天示例：http://codassium.com/  
视屏聊天示例：https://vline.com/  
视频聊天示例：https://www.lytespark.com/  
视频聊天示例：https://vidtok.com/  
视频聊天示例：http://www.easyrtc.com/，源码https://github.com/priologic/easyrtc  
视频聊天示例（印度的）：https://www.miljul.in/  
http://chotis2.dit.upm.es/（可fork on GitHub）  
https://janus.conf.meetecho.com/(可fork on GitHub)  
goToMeeting在线版：https://free.gotomeeting.com/  
婴儿监视器：https://webrtchacks.com/baby-motion-detector/  
电话通讯：http://zingaya.com/  
*  ### 五、一些api及类库 
官方的PeerConnection的api：http://www.webrtc.org/blog/api-description  
官方其它的一些的api：http://www.webrtc.org/native-code/native-apis  
libjingle的文档介绍https://developers.google.com/talk/libjingle/developer_guide?csw=1  
getUserMedia.js：https://github.com/addyosmani/getUserMedia.js  
adapter.js：https://github.com/webrtc/adapter/blob/master/adapter.js  
WebRTC的js类库里有些什么：https://webrtchacks.com/whats-in-a-webrtc-javascript-library/  
Web Audio API：http://webaudio.github.io/web-audio-api/  
The PeerJS library：简化了WebRTC传输数据的过程http://peerjs.com/  
有关浏览器通话的js类库：http://phono.com/  
封装SIP协议的js类库：客户端，https://code.google.com/p/sipml5/；http://jssip.net/  
面部识别的js类库：https://github.com/auduno/clmtrackr  
头部轨迹识别的js类库：https://github.com/auduno/headtrackr/；demo,http://simpl.info/headtrackr/  
http://rtc.io/  
开发WebRTC的工具列表（不能更全）：https://webrtchacks.com/vendor-directory/  
*  ### 六、一些书籍 
WebRTC-APIs and RTCWEB Protocols of the HTML5 Real-Time Web, Third Edition：http://webrtcbook.com/  
Real-Time Communication with WebRTC by Salvatore Loreto & Simon Pietro Romano：https://bloggeek.me/book-webrtc-salvatore-simon/  
Getting Started with WebRTC：https://www.packtpub.com/web-development/getting-started-webrtc    
*  ### 七、标准及协议 
WebRTC工作小组：http://www.w3.org/2011/04/webrtc/  
w3c规定的WebRTC协议1.0http://www.w3.org/TR/webrtc/  
媒体捕捉及媒体流协议：http://www.w3.org/TR/mediacapture-streams/  
IETF协议http://datatracker.ietf.org/wg/rtcweb/documents/  
各大浏览器是否支持：http://iswebrtcreadyyet.com/  
*  ### 八、其它 
国外Google group：https://groups.google.com/forum/?fromgroups#!forum/discuss-webrtc  
国内china WebRTC社区：http://chinawebrtc.org/  
*  ### 九、WebRTC 1.0: Real-time Communication Between Browsers 协议文档中文版汇总
第一篇是描述整个文档的状态和概要：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-1/  
第二篇是整个文档的介绍和术语：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-2/  
第三篇从原文的4. Network Stream API开始，主要描述Network API和MediaStream接口（正式的内容从第三篇开始）:http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-3/  
第四篇从原文的4.3 AudioMediaStreamTrack开始，主要描述AudioMediaStreamTrack类：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-4/  
第五篇从原文的5.Peer-to-peer connections开始，主要描述RTCPeerConnection类。原文的第五节是整个webrtc协议的重点，RTCPeerConnection是webrtc实现的核心功能。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-5/  
第六篇从原文的5.1 RTCPeerConnection开始，重点描述RTCPeerConnection的属性和方法。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-6/  
第七篇从原文的5.1.6 RTCPeerState Enum开始，仍然是原文的第5节的继续。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-7/  
第八篇从原文的5.1.9 RTCIceServer 类型开始，讲解和ICE Server交互相关的内容。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-8/  
第九篇从6. IANA Registrations开始，主要描述IANA Registrations相关的标准约束。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-9/  
第十篇从原文的7. Simple Example开始，展示了一个简单的javascript的例子。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-10/  
第十一篇从原文的9. Call Flow Browser to Browser开始，描述浏览器到浏览器的呼叫建立的流程图。（此处是重点内容）：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-11/  
第十二篇从原文的10. Call Flow Browser to MCU开始，描述浏览器到MCU呼叫建立的流程图。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-12/  
第十三篇从原文11. Peer-to-peer Data API开始，描述创建点到点的数据传输通道的API。（这个很有用，可以用来传输语音和视频之外的数据，比如白板、共享桌面等）：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-13/  
第十四篇从原文11.1.1 Attributes开始，接前一篇，继续描述DataChannel的属性等。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-14/  
第十五篇从原文12. Garbage collection开始，垃圾搜集策略以及事件汇总。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-15/  
第十六篇从原文15. Security Considerations开始，描述安全机制、修改日志、致谢、参考（基本上这一篇没怎么翻译，大部分可以直接无视。修改日志可以扫一眼，参考内容可以浏览一下）。：http://www.iwebrtc.com/blog/webrtc-1-0-real-time-communication-between-browsers-16/  
*  ### 十、IETF：Web Real-Time Communication (WebRTC): Media Transport and Use of RTP （译）  
  
[中文版(一.介绍）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-01/)  

[中文版(二.基本原理）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-02/)  
 
[中文版(三.术语）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-03/)  

[中文版(四.核心协议）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-04/)  

[中文版(五.webrtc所使用RTP扩展）:](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-05/)  

[中文版(六.增强传输可靠性）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-06/)  

[中文版(七.速率控制和媒体适配）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-07/)  

[中文版(八.性能监控）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-08/)  

[中文版(九.未来扩展）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-09/)  

[中文版(十.信号考虑）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-10/)  

[中文版(十一.WebRTC API的考虑）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-11/)  

[中文版(十二.RTP实现）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-12/)  

[中文版(十三，遗留问题）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-13/)  

[中文版(十五，安全考虑）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-15/)  

[中文版(十六，致谢和参考资料）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-15-2/)    

[中文版(附录A：支持的RTP拓扑图）：]（http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtpappendix-a/)    
[中文版(附录A1：点对点）：]（http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-appendix-a1/)  

[中文版(附录A2：单点多播）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-appendix-a2/)  
