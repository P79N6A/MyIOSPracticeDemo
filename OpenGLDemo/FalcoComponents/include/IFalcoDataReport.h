#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IFalcoBlock.h"
#import "IFalcoDataReportItem.h"
#import "IAppCoreData.h"
#import "IWebSSOChannel.h"

@protocol IFalcoDataReport <IFalcoObject>
@required
- (void)setUid:(uint64_t)uid;
- (void)setUin:(uint64_t)uin;
- (void)setOpenId:(NSString*)openId;
- (void)loginSccucess:(uint64_t)uid
           withOpenId:(NSString*)openId;
- (void)appExit;
- (void)setWebSSOChannel:(id<IWebSSOChannel>)webSSOChannel;
- (void)reportWithItem:(id<IFalcoDataReportItem>)item;
- (void)reportSimpleWithRealtime:(BOOL)bRealtime
                      withModule:(NSString*)module
                      withAction:(NSString*)action
                    withOpername:(NSString*)opername;
@end
