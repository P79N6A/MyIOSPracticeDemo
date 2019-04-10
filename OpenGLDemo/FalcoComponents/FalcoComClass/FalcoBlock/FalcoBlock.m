#import "FalcoBlock.h"
#import "FalcoUtilCore.h"

@implementation FalcoResult

- (void)setData_Error:(NSError *)error
             retValue:(id)retValue
             userInfo:(NSMutableDictionary *)userInfo
             outBlock:(id<IFalcoBlock>)outBlock
{
    _error = error;
    _retValue = retValue;
    _userInfo = userInfo;
    _outBlock = outBlock;
}

@end


@interface FalcoBlock()
@property (nonatomic, copy)   pfnFalcoBlock memberFunc;
@property (nonatomic, weak)   id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSDictionary* userInfo;
@property (nonatomic, strong) id<IFalcoBlock> outBlock;
@end

@implementation FalcoBlock

- (void)dealloc
{
    _memberFunc = nil;
    _target = nil;
    _userInfo = nil;
    _outBlock = nil;
}

-(void)initWith:(pfnFalcoBlock)block
{
    _memberFunc = block;
}

-(void)initWith:(SEL)selector target:(id)target userInfo:(NSDictionary*)userInfo
{
    _selector = selector;
    _target = target;
    _userInfo = userInfo;
}

- (void)callWithErr:(NSError *)err retValue:(id)retValue
{
    id<IFalcoResult> result = [FalcoUtilCore CreateObject:@"IFalcoResult"];
    [result setData_Error:err
                 retValue:retValue
                 userInfo:_userInfo
                 outBlock:_outBlock];
    
    if (_memberFunc) {
        _memberFunc(result);
    } else if (_target && _selector) {
        ((void (*)(id, SEL, id))[_target methodForSelector:_selector])(_target, _selector, result);
    }
}

- (void)callWith:(id)retValue
{
    [self callWithErr:nil retValue:retValue];
}

- (NSDictionary*)getUserInfo {
    return _userInfo;
}

-(void)setUserInfo:(NSDictionary*)userInfo
{
    _userInfo = userInfo;
}

-(id<IFalcoBlock>)getOutBlock
{
    return _outBlock;
}
-(void)setOutBlock:(id<IFalcoBlock>)outBlock
{
    _outBlock = outBlock;
}
@end
