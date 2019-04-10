#import "FalcoComponentRoot.h"
#import "IFalcoComponent.h"
#import "FalcoUtilCore.h"
#import "FalcoSingletonMgr.h"

@interface FalcoComponentRoot()
@property(atomic, strong)NSMutableDictionary<NSString*, id<IFalcoObject>>* comServiceList;
@end

@implementation FalcoComponentRoot

-(instancetype)init
{
    if (self = [super init]) {
        _comServiceList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id<IFalcoObject>)ComObjectContructor:(NSString *)iid
{
    FALCO_ASSERT(NO, @"iid=%@,请检查你的组件类是否提供了对应的接口映射!", iid);
    return nil;
}

-(Class<IFalcoObject>)ComObjectClass:(NSString *)iid
{
    FALCO_ASSERT(NO, @"iid=%@,请检查你的组件类是否提供了对应的类接口映射!", iid);
    return nil;
}

+ (id<IFalcoClassFactory>)sharedInstance
{
    NSString* clsName = NSStringFromClass([self class]);
    id singleton = nil;
    @synchronized(self)
    {
        singleton = [[FalcoSingletonMgr shareInstance] singletonForName:clsName];
        if (!singleton) {
            singleton = [[[self class] alloc] init];
            [[FalcoSingletonMgr shareInstance] setSingleton:singleton forName:clsName];
        }
    }
    
    return (id<IFalcoClassFactory>)singleton;
}

- (id<IFalcoObject>)GetService:(NSString *)iid withClsid:(NSString *)clsid {
    
    Protocol* protocol = NSProtocolFromString(iid);
    Class temp = NSClassFromString(clsid);
    if (![temp conformsToProtocol:protocol]) {
        NSLog(@"class =%@ donesn't conforms to protocol = %@", clsid, iid);
        return nil;
    }
    
    @synchronized(_comServiceList)
    {
        id<IFalcoObject> svr = [_comServiceList objectForKey:clsid];
        if (svr != nil) {
            return (id<IFalcoObject>)svr;
        }
        
        svr = [self ComObjectContructor:iid];
        [_comServiceList setObject:svr forKey:clsid];
        return svr;
    }
}

- (id<IFalcoObject>)CreateInstance:(NSString *)iid{
    id<IFalcoObject> inst = [self ComObjectContructor:iid];
    return inst;
}

- (Class<IFalcoObject>)GetObjectClass:(NSString *)iid
{
    Class<IFalcoObject> falcoObjClass = [self ComObjectClass:iid];
    if (!falcoObjClass) {
        id<IFalcoObject> inst = [self CreateInstance:iid];
        if (inst) {
            return inst.class;
        }
    }
    return falcoObjClass;
}

@end
