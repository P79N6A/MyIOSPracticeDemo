#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoObjectFactory.h"
#import "IFalcoServiceCenter.h"

@protocol IFalcoClassEngine <IFalcoObject>
@required
-(id<IFalcoObjectFactory>)GetObjectFactory;
-(id<IFalcoServiceCenter>)GetServiceFactory;
-(BOOL)setCoreConfigPath:(NSString*)cfgPath;
@end

#ifdef __cplusplus
extern "C" {
#endif
    id<IFalcoClassEngine> TXFalcoClassEngine(void);
#ifdef __cplusplus
}
#endif




