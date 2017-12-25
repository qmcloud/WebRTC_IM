# WebRTC_IM #

HI WebRTC IM 聊天系统。
  
*  ###一、官方资源  
   **官方网站**：[http://webrtc.org](http://webrtc.org（官网还是最权威的）)    
    `2013谷歌I/O大会对WebRTC的介绍`：[视频](https://www.youtube.com/watch?v=p2HzZkd2A40)，[ppt](http://io13webrtc.appspot.com/#1)（讲的不错）  
    `2012谷歌I/O大会对WebRTC的介绍`：[视频](http://youtu.be/E8C8ouiXHHk)(视频要翻墙)  
    **WebRTC官方源码样例（不含移动端）**：http://github.com/webrtc/samples （看再多理论不如抠一遍源码）  
    **WebRTC在线演示效果**：[（可以清楚的看到每个接口是怎样被调用的）](http://webrtc.github.io/samples)  
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
*  ### 十、IETF：Web Real-Time Communication (WebRTC): Media Transport and Use of RTP 标准（译）  
  
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

[中文版(十六，致谢和参考资料）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-15-2/)  

[中文版(附录A：支持的RTP拓扑图）：]（http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-appendix-a/)  
[中文版(附录A1：点对点）：]（http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-appendix-a1/)  

[中文版(附录A2：单点多播）：](http://www.iwebrtc.com/blog/web-real-time-communication-webrtc-media-transport-and-use-of-rtp-appendix-a2/)  
