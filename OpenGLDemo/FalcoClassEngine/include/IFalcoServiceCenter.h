#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@protocol IFalcoServiceCenter <IFalcoObject>
@required
-(BOOL)AddPlatformConfig:(NSDictionary*)objectsNode;
-(void)SetComponentMgr:(id<IFalcoComponentMgr>)comMgr;
-(id<IFalcoObject>)GetService:(NSString *)iid withClsid:(NSString *)clsid;
@end
