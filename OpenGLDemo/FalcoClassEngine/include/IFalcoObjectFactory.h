#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@protocol IFalcoObjectFactory <IFalcoObject>
@required
-(BOOL)AddPlatformConfig:(NSDictionary*)objectsNode;
-(void)SetComponentMgr:(id<IFalcoComponentMgr>)comMgr;
-(id<IFalcoObject>)CreateObject:(NSString *)iid;
-(Class<IFalcoObject>)GetObjectClass:(NSString *)iid;
@end
