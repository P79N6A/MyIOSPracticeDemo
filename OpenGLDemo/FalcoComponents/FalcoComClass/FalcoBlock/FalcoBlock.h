#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "IFalcoBlock.h"

@interface FalcoResult : NSObject<IFalcoResult>

@property(nonatomic, strong) NSError *error; // 错误信息
@property(nonatomic, strong) id retValue; // 结果
@property (nonatomic, strong) NSMutableDictionary * userInfo;    // 透传数据
@property (nonatomic, strong) id<IFalcoBlock> outBlock; // 回调链路上层block

@end


@interface FalcoBlock : NSObject<IFalcoBlock>
@end
