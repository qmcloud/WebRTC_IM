//
//  LGSocketServe.m
//  AsyncSocketDemo
//
//  Created by 刘佳 on 15/4/3.
//  Copyright (c) 2015年 刘佳. All rights reserved.
//

#import "LJSocketServe.h"
#import "BruteForceCoding.h"
#import "LeafNotification.h"
//自己设定
#define HOST @"127.0.0.1"
#define PORT 8080

//设置连接超时
#define TIME_OUT 20

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//每次最多读取多少
#define MAX_BUFFER 1024

@interface LJSocketServe ()

@property (nonatomic,strong)NSData *data;

@end

@implementation LJSocketServe


static LJSocketServe *socketServe = nil;

#pragma mark public static methods


+ (LJSocketServe *)sharedSocketServe {
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


-(void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
}


- (void)sendMessage:(id)message
{
    //像服务器发送数据
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
}

//发送认证消息
-(BOOL)authWrite{

    int gameCode = [self getGameCode:@"liangshan"];
    NSString *stringGameCode = [NSString stringWithFormat:@"%d",gameCode];
    self.uid = 1;
    NSString *uidString = [NSString stringWithFormat:@"%ld",self.uid];
    NSString *msg = [NSString stringWithFormat:@"%@,%@",uidString,stringGameCode];
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    Byte *msgByte = (Byte *)[msgData bytes];
    unsigned long packLength = msg.length + 16;
    
    Byte baotou[16] ;
    BruteForceCoding *brute = [[BruteForceCoding alloc]init];
    //移位
    //package length
    int offset = [brute encodeIntBigEndian:baotou val:packLength offset:0 size:4];
    
    //header length
    offset = [brute encodeIntBigEndian:baotou val:16 offset:offset size:2];
    
    //ver
    offset = [brute encodeIntBigEndian:baotou val:2 offset:offset size:2];
    
    //operation
    offset = [brute encodeIntBigEndian:baotou val:7 offset:offset size:4];

    //jsonp callback
    offset = [brute encodeIntBigEndian:baotou val:2 offset:offset size:4];
    //移位后结果转化成NSData发送到服务器进行认证
    NSInteger baotouLength = sizeof(baotou);
    NSInteger msgLength = [msgData length];
    Byte *resultByte = [brute addByte1:baotou andLength:baotouLength andByte2:msgByte andLength:msgLength];
    NSData *data = [NSData dataWithBytes:resultByte length:baotouLength + msgLength];
    [self.socket writeData:data withTimeout:TIME_OUT tag:101];
    NSLog(@"-----------------------认证消息数据发送成功");

    return YES;
    
}

//发送心跳
-(BOOL)heartBeatWrite{

    int gameCode = [self getGameCode:@"liangshan"];
    NSString *stringGameCode = [NSString stringWithFormat:@"%d",gameCode];
    self.uid = 1;
    NSString *uidString = [NSString stringWithFormat:@"%ld",self.uid];
    NSString *msg = [NSString stringWithFormat:@"%@,%@",uidString,stringGameCode];
    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    Byte *msgByte = (Byte *)[msgData bytes];
    unsigned long packLength = msg.length + 16;
    
    Byte baotou[16] ;
    BruteForceCoding *brute = [[BruteForceCoding alloc]init];
    //移位
    //package length
    int offset = [brute encodeIntBigEndian:baotou val:packLength offset:0 size:4];
    
    //header length
    offset = [brute encodeIntBigEndian:baotou val:16 offset:offset size:2];
    
    //ver
    offset = [brute encodeIntBigEndian:baotou val:1 offset:offset size:2];
    
    //operation
    offset = [brute encodeIntBigEndian:baotou val:2 offset:offset size:4];
    
    //jsonp callback
    offset = [brute encodeIntBigEndian:baotou val:1 offset:offset size:4];
    //移位后结果转化成NSData发送到服务器进行认证
    NSInteger baotouLength = sizeof(baotou);
    NSInteger msgLength = [msgData length];
    Byte *resultByte = [brute addByte1:baotou andLength:baotouLength andByte2:msgByte andLength:msgLength];
    NSData *data = [NSData dataWithBytes:resultByte length:baotouLength + msgLength];
    [self.socket writeData:data withTimeout:TIME_OUT tag:101];
    NSLog(@"-----------------------心跳消息发送数据成功");
    return YES;

}

//获取游戏字符串对应ASCII码值之和
-(int)getGameCode:(NSString *)game{

    NSData  *data = [game dataUsingEncoding:NSUTF8StringEncoding];
    Byte *byteArray = (Byte *)[data bytes];
    int sum = 0;
    for (int i = 0; i < data.length ; i ++) {
        sum += byteArray[i];
    }
    return sum;
    
}


#pragma mark - Delegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    [NSThread sleepForTimeInterval:2];

    NSLog(@"----------------连接失败 %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self startConnectSocket];
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
        
        // wifi断开，两秒发送一次请求
        [self startConnectSocket];
        

    }
    
}



- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"-------------willDisconnectWithError");

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



- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"-------------------didAcceptNewSocket");
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //这是异步返回的连接成功，
    NSLog(@"-------------连接成功回调");
    [self authWrite];
    
}


//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"-------------接收消息成功之后回调");

    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    if( data.length < MAX_BUFFER )
    {
        
        //从服务器发送的数据中减去前16字节的格式协议
        NSInteger dataLength = data.length;
        Byte *inBuffer = malloc(MAX_BUFFER);
        inBuffer = (Byte *)[data bytes];
        BruteForceCoding *brute = [[BruteForceCoding alloc]init];
        Byte *resultByte = [brute tail:inBuffer anddataLengthLength:dataLength andHeaderLength:16];
        
        //解析指令，不同指令执行不同的操作
        NSInteger operation = [brute decodeIntBigEndian:inBuffer offset:8 size:4];
        if (3 == operation) {
//            heartBeatReceived();
        } else if (8 == operation) {
            NSLog(@"------------------------------认证成功");
            //通过定时器不断发送消息，来检测长连接
            self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(heartBeatWrite) userInfo:nil repeats:YES];
            
            [self.heartTimer fire];
            

        } else if (5 == operation) {
            //解析出body内容
            NSData *data = [NSData dataWithBytes:resultByte length:dataLength - 16];
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
//            self.block(string);
            
            [LeafNotification showInController:[[UIApplication sharedApplication]keyWindow].rootViewController withText:string];
            NSLog(@"%@",string);
        }
        
//        //收到结果解析...
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
//        //解析出来的消息，可以通过通知、代理、block等传出去
    
    }
   
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    
}


//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"-------------发送消息成功之后回调");
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}





@end
