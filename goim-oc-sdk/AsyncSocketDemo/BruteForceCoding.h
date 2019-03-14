//
//  BruteForceCoding.h
//  SDK_Ariesgames
//
//  Created by 刘佳 on 15/11/30.
//  Copyright © 2015年 ariesgames. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BruteForceCoding : NSObject

//移位、加密
-(int)encodeIntBigEndian:(Byte *)dst val:(long)val offset:(int)offset size:(int)size;

//byte数组的拼接
-(Byte *)addByte1:(Byte *)byte1 andLength:(NSInteger)length1 andByte2:(Byte *)byte2 andLength:(NSInteger)length2;
//解码
-(NSInteger)decodeIntBigEndian:(Byte *)val offset:(int)offset size:(int)size;

//截取body
-(Byte *)tail:(const Byte *)a anddataLengthLength:(NSInteger)dataLength andHeaderLength:(const int )headerLength;


    

@end
