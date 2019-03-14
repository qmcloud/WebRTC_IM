//
//  BruteForceCoding.m
//  SDK_Ariesgames
//
//  Created by 刘佳 on 15/11/30.
//  Copyright © 2015年 ariesgames. All rights reserved.
//

#import "BruteForceCoding.h"
#define BYTEMASK 0xFF
@implementation BruteForceCoding

//移位、加密
-(int)encodeIntBigEndian:(Byte *)dst val:(long)val offset:(int)offset size:(int)size{
    for (int i = 0; i < size; i++) {
        dst[offset++] = (Byte) (val >> (size - i-1 )*8 );
    }
    
    return offset;
    
}

//byte数组的拼接
-(Byte *)addByte1:(Byte *)byte1 andLength:(NSInteger)length1 andByte2:(Byte *)byte2 andLength:(NSInteger)length2{
    
    Byte *newByte = malloc(length1 + length2);
    Byte *pp = newByte;
    const Byte *byte1Pointer = byte1;
    const Byte *byte2Pointer = byte2;
    memcpy(pp, byte1Pointer, length1);
    memcpy(pp +length1, byte2Pointer, length2);
    return newByte;
    
    
}

//解码
-(NSInteger)decodeIntBigEndian:(Byte *)val offset:(int)offset size:(int)size{
    
    NSInteger rtn = 0;
    for (int i = 0; i < size; i ++) {
        rtn = (rtn <<8) | ((long) val[offset + i] & BYTEMASK);
    }
    return rtn;
    
}

//截取body
-(Byte *)tail:(const Byte *)a anddataLengthLength:(NSInteger)dataLength andHeaderLength:(const int )headerLength{
    if (dataLength == headerLength) {
        return NULL;
    }
    Byte *result = malloc(dataLength - headerLength);
    Byte *pp = result;
    memcpy(pp, a + headerLength, (dataLength - headerLength));
    return result;
    
}

@end
