//
//  LGSocketServe.h
//  AsyncSocketDemo
//
//  Created by 刘佳 on 15/4/3.
//  Copyright (c) 2015年 刘佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"


enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

typedef void(^myBlock)(NSString *);
@interface LJSocketServe : NSObject<AsyncSocketDelegate>
@property (nonatomic,assign)NSUInteger uid;
@property (nonatomic, strong) AsyncSocket         *socket;       // socket
@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器
@property (nonatomic,copy)myBlock block;
+ (LJSocketServe *)sharedSocketServe;

//  socket连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;


// gameCode

-(int)getGameCode:(NSString *)game;
-(BOOL)authWrite;

@end
