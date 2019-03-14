# AsyncSocketDemo


用socket可以实现像QQ那样发送即时消息的功能。客户端和服务端需要建立长连接，在长连接的情况下，发送消息。客户端可以发送心跳包来检测长连接。

在iOS开发中使用socket，一般都是用第三方库AsyncSocket，不得不承认这个库确实很强大。下载地址[CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket.git)。

使用AsyncSocket的时候可以做一层封装，根据需求提供几个接口出来。比如：连接、断开连接、发送消息等等。还有接受消息，接受到的消息可以通过通知、代理、block等传出去。


简单介绍一下对AsyncSocket使用.一般来说，一个用户只需要建立一个socket长连接，所以可以用单例类方便使用。

###定义单列类：LGSocketServe

LGSocketServe.h
	
	//
	//  LGSocketServe.h
	//  AsyncSocketDemo
	//
	//  Created by ligang on 15/4/3.
	//  Copyright (c) 2015年 ligang. All rights reserved.
	//
	
	#import <Foundation/Foundation.h>
	#import "AsyncSocket.h"
	
	@interface LGSocketServe : NSObject<AsyncSocketDelegate>

	+ (LGSocketServe *)sharedSocketServe;
	
	
	@end
	
LGSocketServe.m

	//
	//  LGSocketServe.m
	//  AsyncSocketDemo
	//
	//  Created by ligang on 15/4/3.
	//  Copyright (c) 2015年 ligang. All rights reserved.
	//
	
	#import "LGSocketServe.h"
	
	@implementation LGSocketServe
	
	
	static LGSocketServe *socketServe = nil;
	
	#pragma mark public static methods
	
	
	+ (LGSocketServe *)sharedSocketServe {
	    @synchronized(self) {
	        if(socketServe == nil) {
	            socketServe = [[[self class] alloc] init];
	        }
	    }
	    return socketServe;
	}
	
	
	+(id)allocWithZone:(NSZone *)zone
	{
	    @synchronized(self)
	    {
	        if (socketServe == nil)
	        {
	            socketServe = [super allocWithZone:zone];
	            return socketServe;
	        }
	    }
	    return nil;
	}	
	
	
	@end


###建立socket长连接

LGSocketServe.h

	@property (nonatomic, strong) AsyncSocket         *socket;       // socket
	
	//  socket连接
	- (void)startConnectSocket;

LGSocketServe.m

	//自己设定
	#define HOST @"192.168.0.1"
	#define PORT 8080
	
	//设置连接超时
	#define TIME_OUT 20

	- (void)startConnectSocket
	{
	    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
	    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	    if ( ![self SocketOpen:HOST port:PORT] )
	    {
	        
	    }
	    
	}
	
	- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
	{
	    
	    if (![self.socket isConnected])
	    {
	        NSError *error = nil;
	        [self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
	    }
	    
	    return 0;
	}

宏定义一下HOST、PORT、TIME_OUT，实现startConnectSocket方法。这个时候要设置一下AsyncSocket的代理AsyncSocketDelegate。当长连接成功之后会调用：	
	
	- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
	{
	    //这是异步返回的连接成功，
	    NSLog(@"didConnectToHost");
	}



###心跳

LGSocketServe.h

	@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
	
LGSocketServe.m

	- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
	{
	    //这是异步返回的连接成功，
	    NSLog(@"didConnectToHost");
	    
	    //通过定时器不断发送消息，来检测长连接
	    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
	    [self.heartTimer fire];
	}
	
	// 心跳连接
	-(void)checkLongConnectByServe{
	
	    // 向服务器发送固定可是的消息，来检测长连接
	    NSString *longConnect = @"connect is here";
	    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
	    [self.socket writeData:data withTimeout:1 tag:1];
	}

在连接成功的回调方法里，启动定时器，每隔2秒向服务器发送固定的消息来检测长连接。（这个根据服务器的需要就可以了）

###断开连接

1，用户手动断开连接

LGSocketServe.h

	// 断开socket连接
	-(void)cutOffSocket;
	
LGSocketServe.m
	
	-(void)cutOffSocket
	{
	    self.socket.userData = SocketOfflineByUser;
	    [self.socket disconnect];
	}

cutOffSocket是用户断开连接之后，不在尝试重新连接。

2，wifi断开，socket断开连接

LGSocketServe.m

	- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
	{
	   	
	   	NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.socket.userData = SocketOfflineByWifiCut;
        }
	    
	}

wifi断开之后，会回调onSocket:willDisconnectWithError:方法，err.code == 57，这个时候设置self.socket.userData = SocketOfflineByWifiCut。

###重新连接

socket断开之后会回调：

LGSocketServe.m

	- (void)onSocketDidDisconnect:(AsyncSocket *)sock
	{
	    
	    NSLog(@"7878 sorry the connect is failure %ld",sock.userData);
	    
	    if (sock.userData == SocketOfflineByServer) {
	        // 服务器掉线，重连
	        [self startConnectSocket];
	    }
	    else if (sock.userData == SocketOfflineByUser) {
	        
	        // 如果由用户断开，不进行重连
	        return;
	    }else if (sock.userData == SocketOfflineByWifiCut) {
	        
	        // wifi断开，不进行重连
	        return;
	    }
	    
	}
	
在onSocketDidDisconnect回调方法里面，会根据self.socket.userData来判断是否需要重新连接。

###发送消息

LGSocketServe.h

	// 发送消息
	- (void)sendMessage:(id)message;

LGSocketServe.m

	//设置写入超时 -1 表示不会使用超时
	#define WRITE_TIME_OUT -1

	- (void)sendMessage:(id)message
	{
	    //像服务器发送数据
	    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
	    [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
	}

	//发送消息成功之后回调
	- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
	{
	    
	}

发送消息成功之后会调用onSocket:didWriteDataWithTag:,在这个方法里可以进行读取消息。

###接受消息

LGSocketServe.m

	//设置读取超时 -1 表示不会使用超时
	#define READ_TIME_OUT -1
	
	#define MAX_BUFFER 1024

	//发送消息成功之后回调
	- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
	{
	    //读取消息
	    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
	}
	
	//接受消息成功之后回调
	- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
	{
	    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
	    if( data.length < MAX_BUFFER )
	    {
	        //收到结果解析...
	        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	        NSLog(@"%@",dic);
	        //解析出来的消息，可以通过通知、代理、block等传出去
	    
	    }
	   
	    
	    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
	  

接受消息后去解析，然后可以通过通知、代理、block等传出去。在onSocket:didReadData:withTag:回调方法里面需要不断读取消息，因为数据量比较大的话，服务器会分多次返回。所以我们需要定义一个MAX_BUFFER的宏，表示每次最多读取多少。当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
。

###出错处理

LGSocketServe.m

	- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
	{
	    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
	    if(unreadData.length > 0) {
	        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
	    } else {
	        
	        NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
	        if (err.code == 57) {
	            self.socket.userData = SocketOfflineByWifiCut;
	        }
	    }
	    
	}

socket出错会回调onSocket:willDisconnectWithError:方法，可以通过unreadData来读取未来得及读取的buffer。

###使用

导入#import "LGSocketServe.h"

	 LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    //socket连接前先断开连接以免之前socket连接没有断开导致闪退
    [socketServe cutOffSocket];
    socketServe.socket.userData = SocketOfflineByServer;
    [socketServe startConnectSocket];
    
    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
    [socketServe sendMessage:@"hello world"];
    
以上是AsyncSocket的简单使用，在实际开发过程中依然会碰到很多问题，欢迎加我的微信公众号iOS开发：iOSDevTip，一起讨论AsyncSocket中遇到的问题。

