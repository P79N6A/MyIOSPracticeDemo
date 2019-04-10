#import "FalcoServiceCenter.h"
#import "ClassMetaInfo.h"
#import "FalcoXMLDictionary.h"
#import "FalcoUtilCore.h"

@interface FalcoSeviceCenter()
{
    id<IFalcoComponentMgr> _comMgr;
}
@property (nonatomic, strong)NSMutableDictionary<NSString*, FalcoServiceinfo*>* platformServiceInfo;//平台申明的service信息
@end

@implementation FalcoSeviceCenter

-(instancetype)init
{
    if (self = [super init]) {
        _platformServiceInfo = [[NSMutableDictionary<NSString*, FalcoServiceinfo*> alloc] init];
        _comMgr = nil;
    }
    return self;
}
- (BOOL)AddPlatformConfig:(NSDictionary *)objectsNode {
    NSArray* objectsArray= [objectsNode arrayValueForKeyPath:@"platform.object"];
    for (NSDictionary* dic in objectsArray){
        NSString* type = [dic objectForKey:@"_type"];
        if ([type isEqualToString:@"service"]) {
            NSString* name = [dic objectForKey:@"_name"];
            NSString* iid = [dic objectForKey:@"_iid"];
            NSString* clsname = [dic objectForKey:@"_clsname"];
            FalcoServiceinfo* seviceInfo = [[FalcoServiceinfo alloc]init];
            seviceInfo.name = name;
            seviceInfo.iid = iid;
            seviceInfo.clsid = clsname;
            seviceInfo.comid = @"platform";
            @synchronized(_platformServiceInfo)
            {
                [_platformServiceInfo setObject:seviceInfo forKey:name];
            }

        }
    }
    return YES;
}

- (id<IFalcoObject>)GetService:(NSString *)iid
                     withClsid:(NSString *)clsid
{
    @synchronized(_platformServiceInfo)
    {
        FalcoServiceinfo* platServiceInfo = [_platformServiceInfo objectForKey:iid];
        if (platServiceInfo) {
            // 如果平台信息里面有该对象信息，则返回||创建
            if (platServiceInfo.service) {
                return platServiceInfo.service;
            } else {
                Protocol* protocol = NSProtocolFromString(iid);
                Class temp = NSClassFromString(clsid);
                if (![temp conformsToProtocol:protocol]) {
                    FALCO_ASSERT(NO, @"class =%@ donesn't conforms to protocol = %@", clsid, iid);
                    NSLog(@"class =%@ donesn't conforms to protocol = %@", clsid, iid);
                    return nil;
                }
                
                id<IFalcoObject> inst = [[temp alloc]init];
                platServiceInfo.service = inst;
                return  inst;
            }
        }
    }

    if (_comMgr != nil) {
        id<IFalcoClassFactory> classFactory = [_comMgr QueryComponent:iid];
        if (classFactory != nil) {
            return [classFactory GetService:iid withClsid:clsid];
        }
    }
    
    return nil;
}

- (void)SetComponentMgr:(id<IFalcoComponentMgr>)comMgr {
    _comMgr = comMgr;
}
@end
