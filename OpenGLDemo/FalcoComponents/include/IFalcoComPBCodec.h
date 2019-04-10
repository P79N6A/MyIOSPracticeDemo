//
//  IOCPBCodec.h
//  HuiyinSDK
//
//  Created by Carly 黄 on 2018/12/5.
//  Copyright © 2018年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@protocol IFalcoComPBMsgEncoder <NSObject>

-(void)AddBool:(uint32_t)index value:(BOOL)v;
-(void)AddInt32:(uint32_t)index value:(int32_t)v;
-(void)AddUInt32:(uint32_t)index value:(uint32_t)v;
-(void)AddInt64:(uint32_t)index value:(int64_t)v;
-(void)AddUInt64:(uint32_t)index value:(uint64_t)v;
-(void)AddFloat:(uint32_t)index value:(float)v;
-(void)AddDouble:(uint32_t)index value:(double)v;
-(void)AddBuf:(uint32_t)index value:(NSData*)buf;
-(void)AddStr:(uint32_t)index value:(NSString*)str;
-(id<IFalcoComPBMsgEncoder>)AddSubMessage:(uint32_t)index;
-(NSData*)ToNSData;

@end

@protocol IFalcoComPBMsgDecoder <NSObject>

-(bool)Decode:(NSData*)buf;
-(bool)Has:(unsigned int)t;
-(bool)GetBool:(unsigned int)t;
-(int32_t)GetInt32:(unsigned int)t;
-(uint32_t)GetUInt32:(unsigned int)t;
-(int64_t)GetInt64:(unsigned int)t;
-(uint64_t)GetUInt64:(unsigned int)t;
-(float)GetFloat:(unsigned int)t;
-(double)GetDouble:(unsigned int)t;
-(NSString*)GetStr:(unsigned int)t;
-(NSData*)GetData:(unsigned int)t;
-(id<IFalcoComPBMsgDecoder>)GetSubMessage:(unsigned int)t;
-(int)GetRepeatSubMessageCount:(unsigned int)t;
-(id<IFalcoComPBMsgDecoder>)GetRepeatSubMessage:(unsigned int)t index:(unsigned int)index;
-(int)GetRepeatUInt32Count:(unsigned int)t;
-(unsigned int)GetRepeatUInt32:(unsigned int)t index:(unsigned int)index;
-(int)GetRepeatUInt64Count:(unsigned int)t;
-(unsigned long long)GetRepeatUInt64:(unsigned int)t index:(unsigned int)index;
-(int)GetRepeatStrCount:(unsigned int)t;
-(NSString*)GetRepeatStr:(unsigned int)t index:(unsigned int)index;

@end

@protocol IFalcoComPBCodec <IFalcoObject>

@required
+(id<IFalcoComPBMsgEncoder>)createPBEncoder;

@required
+(id<IFalcoComPBMsgDecoder>)createPBDecoder;

@end
