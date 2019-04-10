#import "FalcoObjectFactory.h"
#import "IFalcoComponent.h"
#import "ClassMetaInfo.h"
#import "FalcoXMLDictionary.h"
#import "FalcoUtilCore.h"

@interface FalcoObjectFactory()
{
    NSMutableDictionary<NSString*, FalcoObjectInfo*>* _platformObjectInfo;//平台接口信息
    id<IFalcoComponentMgr> _comMgr;
}
@end

@implementation FalcoObjectFactory
-(instancetype)init
{
    if (self = [super init]) {
        _platformObjectInfo = [[NSMutableDictionary<NSString*, FalcoObjectInfo*> alloc] init];
        _comMgr = nil;
    }
    return self;
}

#pragma mark IFalcoObjectFactory
- (BOOL)AddPlatformConfig:(NSDictionary *)objectsNode {
    if (objectsNode == nil) {
        return NO;
    }
    
    NSArray* objectsArray= [objectsNode arrayValueForKeyPath:@"platform.object"];
    for (NSDictionary* dic in objectsArray){
        NSString* type = [dic objectForKey:@"_type"];
        if ([type isEqualToString:@"object"]) {
            NSString* name = [dic objectForKey:@"_name"];
            NSString* iid = [dic objectForKey:@"_iid"];
            NSString* clsname = [dic objectForKey:@"_clsname"];
            FalcoObjectInfo* objInfo = [[FalcoObjectInfo alloc]init];
            objInfo.name = name;
            objInfo.iid = iid;
            objInfo.clsid = clsname;
            objInfo.comid = @"platform";
            [_platformObjectInfo setObject:objInfo forKey:name];
        }
    }
    
    return YES;
}

- (BOOL)AddPluginConfig:(NSDictionary *)dataCfg {
    //注册插件包含的对象工厂信息
    //注册插件包含的对象，接口信息
    return YES;
}

-(void)SetComponentMgr:(id<IFalcoComponentMgr>)comMgr
{
    _comMgr = comMgr;
}

-(id<IFalcoObject>)CreateObject:(NSString *)iid{
    FalcoObjectInfo* platObjectInfo = [_platformObjectInfo objectForKey:iid];
    if (platObjectInfo) {
        if (!platObjectInfo.clsClass) {
            //如果平台信息里面有该对象信息，则创建
            NSString* clsid = platObjectInfo.clsid;
            Protocol* protocol = NSProtocolFromString(iid);
            Class temp = NSClassFromString(clsid);
            if (![temp conformsToProtocol:protocol]) {
                NSLog(@"class =%@ donesn't conforms to protocol = %@", clsid, iid);
                FALCO_ASSERT(NO, @"class =%@ donesn't conforms to protocol = %@,请检查com类实现或者xml配置", clsid, iid);
                return nil;
            }
            platObjectInfo.clsClass = temp;
        }
        
        id<IFalcoObject> inst = [[platObjectInfo.clsClass alloc] init];
        return inst;
    }
    
    id<IFalcoClassFactory> classFactory = [_comMgr QueryComponent:iid];
    if (classFactory == nil) {
        FALCO_ASSERT(NO, @"从组件管理器里获取iid=%@，对应的类厂指针失败", iid);
        return nil;
    }
    return [classFactory CreateInstance:iid];
}

-(Class<IFalcoObject>)GetObjectClass:(NSString *)iid
{
    FalcoObjectInfo* platObjectInfo = [_platformObjectInfo objectForKey:iid];
    if (platObjectInfo) {
        if (!platObjectInfo.clsClass) {
            //如果平台信息里面有该对象信息，则创建
            NSString* clsid = platObjectInfo.clsid;
            Protocol* protocol = NSProtocolFromString(iid);
            Class temp = NSClassFromString(clsid);
            if (![temp conformsToProtocol:protocol]) {
                NSLog(@"class =%@ donesn't conforms to protocol = %@", clsid, iid);
                FALCO_ASSERT(NO, @"class =%@ donesn't conforms to protocol = %@,请检查com类实现或者xml配置", clsid, iid);
                return nil;
            }
            platObjectInfo.clsClass = temp;
        }
        return platObjectInfo.clsClass;
    }
    
    id<IFalcoClassFactory> classFactory = [_comMgr QueryComponent:iid];
    if (classFactory == nil) {
        FALCO_ASSERT(NO, @"从组件管理器里获取iid=%@，对应的类厂指针失败", iid);
        return nil;
    }
    return [classFactory GetObjectClass:iid];
}

@end
