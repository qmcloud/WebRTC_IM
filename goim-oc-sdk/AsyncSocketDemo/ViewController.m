//
//  ViewController.m
//  AsyncSocketDemo
//
//  Created by 刘佳 on 15/4/3.
//  Copyright (c) 2015年 刘佳. All rights reserved.
//

#import "ViewController.h"
#import "LJSocketServe.h"
#import "LeafNotification.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LJSocketServe *socketServe = [LJSocketServe sharedSocketServe];
    [socketServe cutOffSocket];
    socketServe.socket.userData = SocketOfflineByServer;
    [socketServe startConnectSocket];
//
//    //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
//    [socketServe sendMessage:@"hello world"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
