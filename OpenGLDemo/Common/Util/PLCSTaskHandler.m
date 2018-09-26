//
//  PLCSTaskHandler.m
//  HuaYang
//
//  Created by Orange on 2017/11/7.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "PLCSTaskHandler.h"
#import "PLWnsChannelMgr.h"

#define LogFilter @"PLCSTaskHandler"

@interface PLCSTaskHandler()<CSChannelDelegate>
@property(nonatomic, copy)RequestFinishedBlock finishedBlock;
@end

@implementation PLCSTaskHandler

+ (void)requestWithParams:(NSDictionary *)params andFinishedBlock:(RequestFinishedBlock)finishedBlock {
    PLCSTaskHandler *handler = [PLCSTaskHandler new];
    [handler objectRequestWithParams:params andFinishedBlock:finishedBlock];
    LogFinal(LogFilter, @"收到jsapi的请求，params:%@", params);
}


- (void)objectRequestWithParams:(NSDictionary *)params andFinishedBlock:(RequestFinishedBlock)finishedBlock {
    
    self.finishedBlock = finishedBlock;
    
    NSInteger cmd = [self parseToInt:params[@"cmd"]];
    NSInteger subCmd = [self parseToInt:params[@"subCmd"]];
    LogFinal(@"GAME_WEB_PERFORM", @"fetchcome=%f,cmd=%d,subCmd=%d", [[NSDate date] timeIntervalSince1970],cmd,subCmd);
    NSString *paramsStr = @"";
    if ([params[@"params"] isKindOfClass:[NSString class]]) {
        paramsStr = params[@"params"];
        paramsStr = [self decodedString:paramsStr];
    }
    
    NSData *data = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
    int seq = -1;
    
    LCSendDataConfigModel *configModel = [[LCSendDataConfigModel alloc] init];
    configModel.codec = 1; //ex中的编码. 0-pb, 1-json
    BOOL bResult = [[PLWnsChannelMgr shareInstance] sendData:data
                                                     Command:cmd
                                                  withSubCmd:subCmd
                                                         seq:&seq
                                                    delegate:self
                                                       param:@{@"handler":self} //这里引用self，防止被释放
                                                      config:configModel];
    
    if (!bResult) {
        [self notifyErrorWithCode:PLCSTaskCode_Other];
        LogFinal(LogFilter, @"请求发送失败，command:%d subCmd:%d params:%@", cmd, subCmd, params);
    }
    
}

- (NSString *)decodedString:(NSString *)encodedStr {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)encodedStr, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (NSInteger)parseToInt:(id)number {
    NSInteger result = 0;
    if (!number) {
        return result;
    }
    result = [number integerValue];
    return result;
}

#pragma mark CSChannelDelegate
- (void)onReceviceData:(LCMessage *)msg
{
    if (!msg) {
        return;
    }
    
    NSString *dataStr = @"";
    if (msg.payload.length > 0) {
        dataStr = [[NSString alloc] initWithData:msg.payload encoding:NSUTF8StringEncoding];
        
    }
    if (dataStr.length == 0) {
        dataStr = @"";
    }
    
    LogFinal(LogFilter, @"收到网络回包，cmd:%d subCmd:%d dataStr: %@", msg.command, msg.subcmd, dataStr);
    
    if (self.finishedBlock) {
        self.finishedBlock(dataStr, PLCSTaskCode_Success);
        self.finishedBlock = nil;
        LogFinal(@"GAME_WEB_PERFORM", @"fetchtoweb=%f,cmd=%d,subCmd=%d", [[NSDate date] timeIntervalSince1970],msg.command,msg.subcmd);
    }
}

- (void)onError:(NSDictionary *)errInfo
{
    LogFinal(LogFilter, @"请求onerror:%@", errInfo);
    PLCSTaskCode errCode = PLCSTaskCode_Other;
    int sdkCode = [errInfo[@"sdkcode"] intValue];
    if (sdkCode == LCChannelErrorSDKCode_Timeout) {
        errCode = PLCSTaskCode_Timeout;
    }
    [self notifyErrorWithCode:errCode];
}

- (void)notifyErrorWithCode:(PLCSTaskCode)errorCode {
    if (self.finishedBlock) {
        self.finishedBlock(@"", errorCode);
        self.finishedBlock = nil;
    }
}

@end
