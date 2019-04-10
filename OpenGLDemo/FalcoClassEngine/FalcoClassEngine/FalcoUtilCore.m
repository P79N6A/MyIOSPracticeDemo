#import "FalcoUtilCore.h"
#import "IFalcoComponent.h"
#import "IFalcoClassEngine.h"
#import "IFalcoObjectFactory.h"
@implementation FalcoUtilCore
+(BOOL)LaunchFalcoClassEngine:(NSString*)coreXmlPath
{
    NSLog(@"FalcoUtilCore:coreXmlPath:%@", coreXmlPath);
    id<IFalcoClassEngine> coreCenter =  TXFalcoClassEngine();
    return [coreCenter setCoreConfigPath:coreXmlPath];
}

+(id)CreateObject:(NSString *)iid
{
    id<IFalcoClassEngine> coreCenter =  TXFalcoClassEngine();
    id<IFalcoObjectFactory> objectFactory = [coreCenter GetObjectFactory];
    return [objectFactory CreateObject:iid];
}

+(Class)GetObjectClass:(NSString *)iid
{
    id<IFalcoClassEngine> coreCenter =  TXFalcoClassEngine();
    id<IFalcoObjectFactory> objectFactory = [coreCenter GetObjectFactory];
    return [objectFactory GetObjectClass:iid];
}

+(id)GetService:(NSString *)iid withClsid:(NSString *)clsid
{
    id<IFalcoClassEngine> coreCenter =  TXFalcoClassEngine();
    id<IFalcoServiceCenter> serviceFactory = [coreCenter GetServiceFactory];
    return [serviceFactory GetService:iid withClsid:clsid];
}
@end

@implementation FalcoUtilType
+(id)Cast:(id)rawType
{
    return rawType;
}
@end
