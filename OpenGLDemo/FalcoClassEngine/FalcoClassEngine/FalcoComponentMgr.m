#import "FalcoComponentMgr.h"
#import "ClassMetaInfo.h"
#import "FalcoUtilCore.h"
#import "FalcoXMLDictionary.h"

@interface FalcoComponentMgr()
{
    NSMutableDictionary<NSString*, FalcoObjectInfo*>*    _interfaceInfoList;    //组件接口信息
    NSMutableDictionary<NSString*, id<IFalcoClassFactory>>* _componentStubList;    //组件对象
}
@end

@implementation FalcoComponentMgr

-(instancetype)init
{
    if (self = [super init]) {
        _interfaceInfoList = [[NSMutableDictionary alloc]init];
        _componentStubList = [[NSMutableDictionary alloc]init];
    }
    return self;
}

#pragma mark IFalcoComponentMgr
-(BOOL)AddComponentConfig:(NSDictionary*)comCfgList
{
    if (comCfgList == nil) {
        return NO;
    }
    
    NSArray* componentsArray = [comCfgList arrayValueForKeyPath:@"components.component"];
    for (NSDictionary* element in componentsArray){
        NSString* componentName = [element objectForKey:@"_name"];
        NSArray* objectsArray= [element arrayValueForKeyPath:@"object"];
        for (id obj in objectsArray){
            NSDictionary* dic = (NSDictionary*)obj;
            NSString* type = [dic objectForKey:@"_type"];
            FalcoObjectInfo* objinfo = nil;
            if ([type isEqualToString:@"service"]) {
                objinfo = [[FalcoServiceinfo alloc]init];
            }else if([type isEqualToString:@"object"]){
                objinfo = [[FalcoObjectInfo alloc]init];
            }
            
            NSString* name = [dic objectForKey:@"_name"];
            NSString* clsname = [dic objectForKey:@"_clsname"];

            objinfo.name = name;
            objinfo.type = type;
            objinfo.clsid = clsname;
            objinfo.comid = componentName;
            if ([_interfaceInfoList objectForKey:name]) {
                FALCO_ASSERT(NO, @"请检查xml里面的接口iid=%@配置是否重复，目前暂时不支持多个组件有同名接口", name);
                continue;
            }
            
            [_interfaceInfoList setObject:objinfo forKey:name];
        }
    }
    return YES;
}

- (BOOL)NotifyExit {
    //todo:
    return YES;
}

- (id<IFalcoClassFactory>)QueryComponent:(NSString *)iid {
    FalcoObjectInfo* interfaceInfo = [_interfaceInfoList objectForKey:iid];
    if (interfaceInfo == nil) {
        FALCO_ASSERT(NO, @"iid=%@,是否已经加入xml配置文件", iid);
        return nil;
    }
    
    NSString* comStubClassName = interfaceInfo.comid;
    if (comStubClassName == nil) {
        FALCO_ASSERT(NO, @"iid=%@,找不到对应的组件对象,请检查配置文件", iid);
        return nil;
    }
    
    id<IFalcoClassFactory> component = [_componentStubList objectForKey:comStubClassName];
    if (component != nil) {
        return [FalcoUtilType<id<IFalcoClassFactory>> Cast:component];
    }
    Class<IFalcoComponent> comStubClass = NSClassFromString(comStubClassName);
    if (comStubClass == nil) {
        FALCO_ASSERT(NO, @"Component Class=%@,是否已定义", comStubClassName);
        return nil;
    }
    
    id<IFalcoClassFactory> factory = [comStubClass sharedInstance];
    if (factory == nil) {
        FALCO_ASSERT(NO, @"Component Class=%@,sharedInstance 获取类厂指针失败", comStubClassName);
        return nil;
    }
    [_componentStubList setObject:factory forKey:comStubClassName];
    return factory;
}
@end
