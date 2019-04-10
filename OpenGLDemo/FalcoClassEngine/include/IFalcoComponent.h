#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>

@protocol IFalcoObject <NSObject>
@end

@protocol IFalcoClassFactory <IFalcoObject>
@required
- (id<IFalcoObject>)GetService:(NSString *)iid withClsid:(NSString *)clsid;
- (id<IFalcoObject>)CreateInstance:(NSString *)iid;
- (Class<IFalcoObject>)GetObjectClass:(NSString *)iid;
@end

@protocol IFalcoComponent <IFalcoObject>
@required
+(id<IFalcoClassFactory>)sharedInstance;
@end

@protocol IFalcoComponentMgr <IFalcoObject>
@required
-(id<IFalcoClassFactory>)QueryComponent:(NSString *)iid;
-(BOOL)AddComponentConfig:(NSDictionary*)comCfgList;
-(BOOL)NotifyExit;
@end




