
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-macro-redefined"
#define __FILE__ "CodeZipper"
#pragma clang diagnostic pop

//
//  CodeZipper.m
//  QQMSFContact
//
//  Created by Vincent on 21/8/15.
//
//

#import "CodeZipper.h"
#import "QQDataCenter.h"
#import "IQQPlatform.h"
#import "QQServiceCenter.h"
#import "IServiceFactory.h"
#import "QQUseActionRecoder.h"
#import "QQVCLeakLogger.h"
#import "QQAddressBookAppDelegate.h"

/*for preload*/
#import "QQWebViewController.h"

#import "UserSummaryModel.h"
#import "UIColorEX.h"
#import <objc/runtime.h>
#import "QQReportEngine.h"

#pragma mark -

UIColor *kCZUIRedColor = nil;
UIColor *kCZUIGrayColor = nil;
UIColor *kCZUIBlackColor = nil;
UIColor *kCZUIWhiteColor = nil;
UIColor *kCZUIClearColor = nil;
NSNotificationCenter *kCZNSNotification = nil;

NSFileManager *kCZDefaultFileManager = nil;
UIApplication *kCZUIApplication = nil;
NSBundle     *kCZNSMainBundle = 0l;
MSFImagePool *kCZMSFImagePool = 0l;
typedef id (*UTF8StringPtr)(id,SEL,const char*);
UTF8StringPtr kCZStringWithUTF8StringPtr = 0l;

void CZInitCocoaConstants(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kCZUIRedColor = [UIColor redColor];
        kCZUIGrayColor = [UIColor grayColor];
        kCZUIWhiteColor = [UIColor whiteColor];
        kCZUIBlackColor = [UIColor blackColor];
        kCZUIClearColor = [UIColor clearColor];
        kCZNSMainBundle = [NSBundle mainBundle];
        kCZMSFImagePool = [MSFImagePool defaultPool];
        kCZDefaultFileManager = [NSFileManager defaultManager];
        kCZNSNotification = [NSNotificationCenter defaultCenter];
        
        SEL aSel = @selector(stringWithUTF8String:);
        kCZStringWithUTF8StringPtr = (UTF8StringPtr)[[NSString class] methodForSelector:aSel];
    });
}

NSString *CZ_NSString_stringWithFormat_c(const char *cformat, ...){
    va_list args;
    va_start(args, cformat);
    NSString *ret = [[[NSString alloc] initWithFormat:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),cformat) arguments:args] autorelease];
    va_end(args);
    return ret;
}

NSString *CZ_NSString_stringWithFormat(NSString *format, ...)
{
    
    va_list args;
    va_start(args, format);
    NSString *ret = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
    va_end(args);
    return ret;
}

BOOL CZ_KindOfClass(__kindof id obj, Class cls) {
    return [obj isKindOfClass:cls];
}

const char *CZ_GetUTF8String(NSString *str) {
    return [str UTF8String];
}

id CZ_Autorelease(id obj) {
    return [obj autorelease];
}

NSUInteger CZ_ContainierCount(__kindof NSObject *containier) {
    return [containier count];
}

char *CZ_getDescription(NSObject *obj) {
    return (char *)[[obj description] UTF8String];
}

NSMutableArray *CZ_GetMutableArray() {
    return [NSMutableArray array];
}

NSMutableDictionary *CZ_GetMutableDictionary() {
    return [NSMutableDictionary dictionary];
}

void CZ_SetNavigationBarHidden(UINavigationController *nav, BOOL hidden, BOOL animated) {
    [nav setNavigationBarHidden:hidden animated:animated];
}

NSMutableArray *CZ_MutableArrayWithCapacity(NSUInteger capacity) {
    return [NSMutableArray arrayWithCapacity:capacity];
}

void CZ_ContainerRemoveAllObjects(__kindof NSObject *containier) {
    [containier removeAllObjects];
}

void CZ_ButtonSetTitleForState(UIButton *btn, NSString *title, UIControlState state) {
    [btn setTitle:title forState:state];
}

NSIndexPath* CZ_IndexPathForRow(NSInteger row, NSInteger section)
{
    return [NSIndexPath indexPathForRow:row inSection:section];
}

//BOOL [NSObject * obj isKindOfClass:Class cls]
//{
//    return [obj isKindOfClass:cls];
//}

UIImage* CZ_LoadDefaultImg(NSString* name, BOOL isDefault)
{
    return isDefault ? [kCZMSFImagePool loadDefaultImageForName:name module:kResourceModuleBase] : [kCZMSFImagePool loadCurrentImageForName:name module:kResourceModuleBase cache:YES];
}

UIColor* CZ_getDefaultColor(int type, BOOL isDefault)
{
    return (isDefault ? static_defaultColorTable[type] : static_colorTable[type]);
}

UILabel *CZ_NewUILabelFunc()
{
    return [UILabel new];
}

UILabel *CZ_NewUILabelFuncARC()
{
    return [[UILabel new] autorelease];
}

UILabel *CZ_NewUILabelWithFrameFunc(CGRect frame)
{
    return [UILabel newWithFrame:frame];
}

UILabel *CZ_NewUILabelWithFrameFuncARC(CGRect frame)
{
    return [[UILabel newWithFrame:frame] autorelease];
}

UIImageView *CZ_NewUIImageViewWithFrameFunc(CGRect frame)
{
    return [UIImageView newWithFrame:frame];
}

UIImageView *CZ_NewUIImageViewWithFrameFuncARC(CGRect frame)
{
    return [[UIImageView newWithFrame:frame] autorelease];
}

UIImageView *CZ_NewUIImageViewWithImageFunc(UIImage*image)
{
    return [[UIImageView alloc] initWithImage:image];
}

UIImageView *CZ_NewUIImageViewWithImageFuncARC(UIImage*image)
{
    return [[[UIImageView alloc] initWithImage:image] autorelease];
}

UIImageView *CZ_NewUIImageViewFunc()
{
    return [UIImageView new];
}

UIImageView *CZ_NewUIImageViewFuncARC()
{
    return [[UIImageView new] autorelease];
}

UIView *CZ_NewUIViewWithFrameFunc(CGRect frame)
{
    return [UIView newWithFrame:frame];
}

UIView *CZ_NewUIViewWithFrameFuncARC(CGRect frame)
{
    return [[UIView newWithFrame:frame] autorelease];
}

UIView *CZ_NewUIViewFunc()
{
    return [UIView new];
}

UIView *CZ_NewUIViewFuncARC()
{
    return [[UIView new] autorelease];
}

NSString *CZ_NewUTF8StringWithData(NSData *data)
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

NSString *CZ_NewUTF8StringWithDataARC(NSData *data)
{
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

NSMutableArray* CZ_NewMutableArrayWithCapacityFunc(NSUInteger capacity)
{
    return [[NSMutableArray alloc] initWithCapacity:capacity];
}

NSMutableArray* CZ_NewMutableArrayWithCapacityFuncARC(NSUInteger capacity)
{
    return [[[NSMutableArray alloc] initWithCapacity:capacity] autorelease];
}

NSMutableArray* CZ_NewMutableArrayFunc()
{
    return [NSMutableArray new];
}

NSMutableArray* CZ_NewMutableArrayFuncARC()
{
    return [[NSMutableArray new] autorelease];
}

NSMutableDictionary* CZ_NewMutableDictionaryWithCapacityFunc(NSUInteger capacity)
{
    return [[NSMutableDictionary alloc] initWithCapacity:capacity];
}

NSMutableDictionary* CZ_NewMutableDictionaryWithCapacityFuncARC(NSUInteger capacity)
{
    return [[[NSMutableDictionary alloc] initWithCapacity:capacity] autorelease];
}

NSMutableDictionary* CZ_NewMutableDictionaryFunc()
{
    return [NSMutableDictionary new];
}

NSMutableDictionary* CZ_NewMutableDictionaryFuncARC()
{
    return [[NSMutableDictionary new] autorelease];
}

UIButton *CZ_NewCustomUIButtonFunc()
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

UIButton *CZ_NewCustomUIButtonFuncARC()
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

UIFont *CZ_NewSystemFontOfSizeFunc(CGFloat size)
{
    return [UIFont systemFontOfSize:size];
}

UIFont *CZ_NewSystemFontOfSizeFuncARC(CGFloat size)
{
    return [UIFont systemFontOfSize:size];
}

void CZ_UIButtonSetTitleLabelFont(UIButton *button, UIFont *font) {
    button.titleLabel.font = font;
}

void CZ_UILabelSetFont(UILabel *label, UIFont *font) {
    label.font = font;
}

UITapGestureRecognizer *CZ_UITapGestureRecognizerMakeARC(id target, SEL action) {
    return [[[UITapGestureRecognizer alloc] initWithTarget:target action:action] autorelease];
}

UITapGestureRecognizer *CZ_UITapGestureRecognizerNew(id target, SEL action) {
    return [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
}

UIFont *CZ_NewBoldSystemFontOfSizeFunc(CGFloat size)
{
    return [UIFont boldSystemFontOfSize:size];
}

UIFont *CZ_NewBoldSystemFontOfSizeFuncARC(CGFloat size)
{
    return [UIFont boldSystemFontOfSize:size];
}


NSNumber *CZ_NSNumber_numberWithCharFunc(char value)
{
    return [NSNumber numberWithChar:value];
}

NSNumber *CZ_NSNumber_numberWithUnsignedCharFunc(unsigned char value)
{
    return [NSNumber numberWithUnsignedChar:value];
}
NSNumber *CZ_NSNumber_numberWithShortFunc(short value)
{
    return [NSNumber numberWithShort:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedShortFunc(unsigned short value)
{
    return [NSNumber numberWithUnsignedShort:value];
}
NSNumber *CZ_NSNumber_numberWithIntFunc(int value)
{
    return [NSNumber numberWithInt:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedIntFunc(unsigned int value)
{
    return [NSNumber numberWithUnsignedInt:value];
}
NSNumber *CZ_NSNumber_numberWithLongFunc(long value)
{
    return [NSNumber numberWithLong:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedLongFunc(unsigned long value)
{
    return [NSNumber numberWithUnsignedLong:value];
}
NSNumber *CZ_NSNumber_numberWithLongLongFunc(long long value)
{
    return [NSNumber numberWithLongLong:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedLongLongFunc(unsigned long long value)
{
    return [NSNumber numberWithUnsignedLongLong:value];
}
NSNumber *CZ_NSNumber_numberWithFloatFunc(float value)
{
    return [NSNumber numberWithFloat:value];
}
NSNumber *CZ_NSNumber_numberWithDoubleFunc(double value)
{
    return [NSNumber numberWithDouble:value];
}
NSNumber *CZ_NSNumber_numberWithBoolFunc(BOOL value)
{
    return [NSNumber numberWithBool:value];
}
NSNumber *CZ_NSNumber_numberWithIntegerFunc(NSInteger value)
{
    return [NSNumber numberWithInteger:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedIntegerFunc(NSUInteger value)
{
    return [NSNumber numberWithUnsignedInteger:value];
}

NSNumber *CZ_NSNumber_numberWithCharFuncARC(char value)
{
    return [NSNumber numberWithChar:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedCharFuncARC(unsigned char value)
{
    return [NSNumber numberWithUnsignedChar:value];
}
NSNumber *CZ_NSNumber_numberWithShortFuncARC(short value)
{
    return [NSNumber numberWithShort:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedShortFuncARC(unsigned short value)
{
    return [NSNumber numberWithUnsignedShort:value];
}
NSNumber *CZ_NSNumber_numberWithIntFuncARC(int value)
{
    return [NSNumber numberWithInt:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedIntFuncARC(unsigned int value)
{
    return [NSNumber numberWithUnsignedInt:value];
}
NSNumber *CZ_NSNumber_numberWithLongFuncARC(long value)
{
    return [NSNumber numberWithLong:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedLongFuncARC(unsigned long value)
{
    return [NSNumber numberWithUnsignedLong:value];
}
NSNumber *CZ_NSNumber_numberWithLongLongFuncARC(long long value)
{
    return [NSNumber numberWithLongLong:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedLongLongFuncARC(unsigned long long value)
{
    return [NSNumber numberWithUnsignedLongLong:value];
}
NSNumber *CZ_NSNumber_numberWithFloatFuncARC(float value)
{
    return [NSNumber numberWithFloat:value];
}
NSNumber *CZ_NSNumber_numberWithDoubleFuncARC(double value)
{
    return [NSNumber numberWithDouble:value];
}
NSNumber *CZ_NSNumber_numberWithBoolFuncARC(BOOL value)
{
    return [NSNumber numberWithBool:value];
}
NSNumber *CZ_NSNumber_numberWithIntegerFuncARC(NSInteger value)
{
    return [NSNumber numberWithInteger:value];
}
NSNumber *CZ_NSNumber_numberWithUnsignedIntegerFuncARC(NSUInteger value)
{
    return [NSNumber numberWithUnsignedInteger:value];
}

NSString* CZ_GetLocalizedStr_c(const char *str) {
    
    return [kCZNSMainBundle localizedStringForKey:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),str) value:@"" table:nil];
}

NSString* CZ_GetLocalizedStr(NSString* str)
{
    return [kCZNSMainBundle localizedStringForKey:str value:@"" table:nil];
}

UIImage* CZ_LoadIconWithCache_c(const char *imageName)
{
    return [kCZMSFImagePool loadImageForName:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),imageName)
                                      module:kResourceModuleBase cache:YES];
}

UIImage* CZ_LoadIconWithCache(NSString* imageName)
{
    return [kCZMSFImagePool loadImageForName:imageName module:kResourceModuleBase cache:YES];
}

UIImage* CZ_LoadIconWithOutCache_c(const char *imageName)
{
    return [kCZMSFImagePool loadImageForName:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),imageName)
                                      module:kResourceModuleBase cache:NO];
}

UIImage* CZ_LoadIconWithOutCache(NSString* imageName)
{
    return [kCZMSFImagePool loadImageForName:imageName module:kResourceModuleBase cache:NO];
}

UIImage* CZ_LoadIconThemeWithCache_c(const char *imageName)
{
    return [kCZMSFImagePool loadCurrentImageForName:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),imageName)
                                             module:kResourceModuleBase cache:YES];
}

UIImage* CZ_LoadIconThemeWithCache(NSString* imageName)
{
    return [kCZMSFImagePool loadCurrentImageForName:imageName module:kResourceModuleBase cache:YES];
}

UIImage* CZ_LoadIconThemeWithOutCache_c(const char *imageName)
{
    return [kCZMSFImagePool loadCurrentImageForName:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),imageName)
                                             module:kResourceModuleBase cache:NO];
}

UIImage* CZ_LoadIconThemeWithOutCache(NSString* imageName)
{
    return [kCZMSFImagePool loadCurrentImageForName:imageName module:kResourceModuleBase cache:NO];
}

UIImage* CZ_LoadDefaultIconWithCache_c(const char *imageName)
{
    return [kCZMSFImagePool loadDefaultImageForName:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),imageName) module:kResourceModuleBase];
}

UIImage* CZ_LoadDefaultIconWithCache(NSString* imageName){
    return [kCZMSFImagePool loadDefaultImageForName:imageName module:kResourceModuleBase];
}

id<IPacketDispatchService> CZ_GetPacketDispatchService()
{
    return [serviceFactoryInstance() getPacketDispatchService];
}

id<IAccountService> CZ_GetAccountService()
{
    return [serviceFactoryInstance() getAccountService];
}

id<IContactsService> CZ_GetContactsService()
{
    return [serviceFactoryInstance() getContactsService];
}

id<IIMService> CZ_GetIMService()
{
    return [serviceFactoryInstance() getIMService];
}

QQReportEngine *CZ_GetReportEngine()
{
    return [QQReportEngine getInstance];
}

void CZ_Report643WithOpType(NSString * opType)
{
    
    [[QQReportEngine getInstance] report643WithOpType:opType];
}

void CZ_Report898WithOpType(NSString * opType)
{
    [[QQReportEngine getInstance] report898WithOpType:opType];
}

void CZ_Report898WithOpTypeAndEntry(NSString * opType, NSString * opName,int entry)
{
    [[QQReportEngine getInstance] report898WithOpType:opType opName:opName opEntry:entry];
}

void CZ_ReportWithModel(id<QQReportProtocol> reportModel)
{
    [[QQReportEngine getInstance] reportWithModel:reportModel];
}

NSTimeInterval CZ_getCurrentLocalTime()
{
    return [[NSDate date] timeIntervalSince1970];
}

BOOL    CZ_GetReadInjoyTabOn(){ // 春节-739 无需修改 jerryyguo
//#if DEBUG
//    return YES;
//#endif

   return  [g_var_QQAppSetting getReadInJoyTabSwitch];
}

BOOL    CZ_GetReadInjoyVideoTabOn(){
//#if DEBUG
//    return YES;
//#endif
    
    return  [g_var_QQAppSetting isReadInJoyVideoTabOn];
}


static BOOL independTab = NO;
void CZ_SetInReadJoyIndependTab(BOOL inTab){
    independTab = inTab;
}

BOOL CZ_InReadJoyIndependTab(){
#if 0
    QQAddressBookAppDelegate *app = (QQAddressBookAppDelegate *)CZ_GetAppDelegate();
    QQTabBarController *tabController = (QQTabBarController*)app.tabCtr;
    
   
    int a = tabController.tabBarIndex;
    int b =  [tabController selectedIndex];
    if(b == QQTabBarIndex_ReadInJoyPage)
        return YES;
    return NO;
#else
    return independTab;
#endif
    
}

BOOL CZ_ReadinjoySocialOpened(){
    
    QQAddressBookAppDelegate* delegate = (QQAddressBookAppDelegate*)CZ_GetAppDelegate();
    UITabBarController* tabBarContrl = (UITabBarController*)delegate.tabCtr;
    
    __block BOOL bSocial = NO;
    [tabBarContrl.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UINavigationController class]]){
    
               UINavigationController *nav = (UINavigationController *)obj;
            
            [nav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                if([obj isKindOfClass:NSClassFromString(@"QQReadInJoySubscribeViewController")]){
                    bSocial = YES;
                }
            }];
        }
        
        //取第一个就走
        *stop = YES;
    }];
    return bSocial;
}

// 从微视服务号进来的
static BOOL isInWeishiChannel = NO;
void CZ_SetInWeishiChannel(BOOL inWeishi) {
    isInWeishiChannel = inWeishi;
}

BOOL CZ_InWeishiChannel() {
    return isInWeishiChannel;
}


NSString* CZ_GetSelfUin()
{
    return g_var_QQDataCenter.uin;
}

void CZ_AddObj2DeftNotiCenter(id obs, SEL sel, NSString* name, id obj)
{
    [kCZNSNotification addObserver:obs selector:sel name:name object:obj];
}
void CZ_AddObj2DeftNotiCenterNoObj(id obs, SEL sel, NSString* name)
{
    [kCZNSNotification addObserver:obs selector:sel name:name object:nil];
}
void CZ_RemoveObjFromDeftNotiCenter(id obs, NSString* name, id obj)
{
    [kCZNSNotification removeObserver:obs name:name object:obj];
}
void CZ_RemoveObjFromDeftNotiCenterNoObj(id obs, NSString* name)
{
    [kCZNSNotification removeObserver:obs name:name object:nil];
}

void CZ_RemoveObjFromDeftNotiCenterOnly(id obs)
{
    [kCZNSNotification removeObserver:obs];
}

void CZ_PostNotifyWithInfo(NSString* name, id obj, NSDictionary* userInfo)
{
    [[QQUseActionRecoder shareInstance] recordImportantText:CZ_NSString_stringWithFormat_c("<name:%@>",name) key:@"CZ_PostNotifyWithInfo"];
    
    [kCZNSNotification postNotificationName:name object:obj userInfo:userInfo];
}
void CZ_PostNotifyWithInfoNoObj(NSString* name, NSDictionary* userInfo)
{
    [[QQUseActionRecoder shareInstance] recordImportantText:[NSString stringWithFormat:@"<name:%@>",name] key:@"CZ_PostNotifyWithInfo"];
    
    [kCZNSNotification postNotificationName:name object:nil userInfo:userInfo];
}

void CZ_PostNotify(NSString* name, id obj)
{
    [[QQUseActionRecoder shareInstance] recordImportantText:CZ_NSString_stringWithFormat_c("<name:%@>",name) key:@"CZ_PostNotifyWithInfo"];
    
    [kCZNSNotification postNotificationName:name object:obj];
}
void CZ_PostNotifyNoObj(NSString* name)
{
    [[QQUseActionRecoder shareInstance] recordImportantText:[NSString stringWithFormat:@"<name:%@>",name] key:@"CZ_PostNotifyWithInfo"];
    
    [kCZNSNotification postNotificationName:name object:nil];
}

UITableViewCell *CZ_NewUITableViewCellFunc(UITableViewCellStyle style, NSString* reuseIdentifier)
{
    return [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
}

UITableViewCell *CZ_NewUITableViewCellFuncARC(UITableViewCellStyle style, NSString* reuseIdentifier)
{
    return [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
}

UITableViewCell *CZ_NewUITableViewCellDefaultFunc(NSString* reuseIdentifier)
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

UITableViewCell *CZ_NewUITableViewCellDefaultFuncARC(NSString* reuseIdentifier)
{
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
}

id CZ_UITableViewDequeueReusableCellDefaultID(UITableView *tableView, Class cls, NSString *reuseIdentifier)
{
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[cls alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    return cell;
}

id CZ_UITableViewDequeueReusableCellDefault(UITableView *tableView, Class cls)
{
    NSString *className = NSStringFromClass(cls);
    return CZ_UITableViewDequeueReusableCellDefaultID(tableView, cls, className);
}

//macaw
UITableView *CZ_NewUITabViewFunc(CGRect rect, UITableViewStyle style)
{
    return [[UITableView alloc] initWithFrame:rect style:style];
}

UITableView *CZ_NewUITabViewFuncARC(CGRect rect, UITableViewStyle style)
{
    return [[[UITableView alloc] initWithFrame:rect style:style] autorelease];
}

id<UIApplicationDelegate> CZ_GetAppDelegate()
{
    return kCZUIApplication.delegate;
}

UINavigationController* CZ_GetSelectedVC()
{
    return ((QQAddressBookAppDelegate *)CZ_GetAppDelegate()).tabCtr.selectedViewController;
}

UIWindow* CZ_GetAppKeyWindow()
{
    return kCZUIApplication.keyWindow;
}

void CZ_PostRegisteNotificationToIMService(NSString *cmd, id object, NSDictionary *userInfo)
{
    [[GETSERVICECENTER IMService] postRegisteNotification:cmd Object:object userInfo:userInfo];
}


void CZ_PostRegisteNotificationToIMServiceWithPriority(NSString *cmd, id object, NSDictionary *userInfo, BOOL priority)
{
    [[GETSERVICECENTER IMService] postRegisteNotification:cmd Object:object userInfo:userInfo priority:priority];
}


id<GroupDBServiceInterface> CZ_GetGroupDBServiceFunc()
{
    return [GETSERVICECENTER GroupDBServie];
}


id<IMessageListService> CZ_GetMessageListServiceFunc()
{
    return [serviceFactoryInstance() getMessageListService];
}


id<IC2CDBService> CZ_GetC2CDBServiceFunc()
{
    return [GETSERVICECENTER C2CDBService];
}

id<IC2CDBService_MultiTable> CZ_GetC2CMultiTableDBFunc()
{
    return [GETSERVICECENTER C2CMultiTableDB];
}

id CZ_GetTableDBFunc(int accType)
{
    return [GETSERVICECENTER getTableDBWithAccType:accType];
}



BOOL CZ_isFileExistInDir(NSString *path, BOOL *isDir)
{
    return [g_var_NSFileManager fileExistsAtPath:path isDirectory:isDir];
}

BOOL CZ_removeFileAtPathWithError(NSString* path,NSError ** error){
    return [g_var_NSFileManager removeItemAtPath:path error:error];
}

BOOL CZ_removeFileAtPath(NSString *path)
{
    return CZ_removeFileAtPathWithError(path, nil);
}


BOOL CZ_IsFileExistFunc(NSString *path)
{
    return [g_var_NSFileManager fileExistsAtPath:path];
}

int CZ_GetServerTimeDiff()
{
    return [g_var_CIMEngine   GetServerTimeDiff];
}

void CZ_QQProgressHUD_Dismiss()
{
    [g_var_QQProgressHUD dismiss];
}

void CZ_QQProgressHUD_DismissAfterDelay(NSTimeInterval time) //没被调用过
{
    [g_var_QQProgressHUD dismissAfterDelay:time];
}

void CZ_QQProgressHUD_ShowFailState(NSString *state)
{
    [g_var_QQProgressHUD showState:state success:NO];
}

void CZ_QQProgressHUD_ShowSuccessState(NSString *state)
{
    [g_var_QQProgressHUD showState:state success:YES];
}

void CZ_QQProgressHUD_ShowNetWorkFailTip()
{
    [g_var_QQProgressHUD showNetWorkFailTip];
}

UIColor * GlobalClearColor = nil;
UIColor * GlobalWhiteColor = nil;

UIColor *CZ_GetClearColor()
{
    return [UIColor clearColor];
}

BOOL CZ_UIApplicationOpenUrl(NSURL *url)
{
    return [kCZUIApplication openURL:url];
}

UIApplication* CZ_GetSharedUIApplication()
{
    return kCZUIApplication;
}

UINavigationController*CZ_GetCurNavController(void)
{
    QQAddressBookAppDelegate* delegate = (QQAddressBookAppDelegate*)CZ_GetAppDelegate();
    UITabBarController* tabBarContrl = (UITabBarController*)delegate.tabCtr;
    return (UINavigationController*)[tabBarContrl selectedViewController];
}

NSString *CZ_GetNSStringFromCStr(const char *cStr)
{
    return [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding];
}

void CZ_SetUIViewHiddenYES(UIView* obj) {
    [obj setHidden:YES];
}

void CZ_SetCALayerHiddenYES(CALayer *obj) {
    [obj setHidden:YES];
}

void CZ_SetQQProgressHiddenYES(QQProgressData *obj) {
    [obj setHidden:YES];
}

void CZ_SetUIViewHiddenNO(UIView *obj) {
    [obj setHidden:NO];
}

void CZ_SetCALayerHiddenNO(CALayer *obj) {
    [obj setHidden:NO];
}

void CZ_SetQQProgressHiddenNO(QQProgressData *obj) {
    [obj setHidden:NO];
}

void CZ_SetHidden(id obj, BOOL hidden) {
    [obj setHidden:hidden];
}

void CZ_AddSubview(UIView *view, UIView *subview) {
    [view addSubview:subview];
}

void CZ_RasterizeView(UIView *view) {
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = CZ_MainScreen().scale;
}
void CZ_SetTitleAndColor(UIButton *button, NSString *title, UIColor *color)
{
    [button setTitle:title forState:UIControlStateNormal];
    if(color)
    {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
}

void CZ_CancelPreviousPerformRequest(id target, SEL selector, id obj) {
    [NSObject cancelPreviousPerformRequestsWithTarget:target selector:selector object:obj];
}



BOOL CZ_RespondsToSelector(id<NSObject> obj, SEL selector) {
    return (obj && [obj respondsToSelector:selector]);
}

void CZ_UIViewSetFrame(UIView *obj, CGRect frame) {
    return [obj setFrame:frame];
}

void CZ_CALayerSetFrame(CALayer *obj, CGRect frame) {
    return [obj setFrame:frame];
}

void CZ_setFrame(id obj, CGRect frame)
{
    [obj setFrame:frame];
}

BOOL CZ_IsEmptyString(NSString *const string) {
    return CZ_StringEqualToString_c(string, "");
}

BOOL CZ_IsEmptyStringOrNil(NSString *const string) {
    if (!string) {
        return YES;
    }
    return CZ_IsEmptyString(string);
}

BOOL CZ_StringEqualToString(NSString *const string1, NSString *const string2) {
    return [string1 isEqualToString:string2];
}

BOOL CZ_StringEqualToString_c(NSString *const string1, const char * string2){
    
    return  CZ_StringEqualToString(string1, kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),string2));
}

BOOL CZ_StringHasPrefix_c(NSString *const string1, const char * string2){
    
    return [string1 hasPrefix:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),string2)];
}
NSString * CZ_stringByAppendingString(NSString *const string1, NSString *const string2)
{
    return [string1 stringByAppendingString:string2];
}
NSString * CZ_stringByAppendingString_c(NSString *const string1, const char * string2){
    
    return[string1 stringByAppendingString:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),string2)];
}

void CZ_appendString_c(NSMutableString *const string1, const char * string2){
    
    return [string1 appendString:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),string2)];
}

void CZ_AddTargetForTouchUpInsideEvents(UIControl *control, id target, SEL action) {
    [control addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

void CZ_SetUIViewBackgroundColor(UIView *view, UIColor *color) {
    [view setBackgroundColor:color];
}

void CZ_SetCALayerBackgroundColor(CALayer *layer, CGColorRef color) {
    [layer setBackgroundColor:color];
}

void CZ_SetUIViewClearBackgroundColor(UIView *view) {
    [view setBackgroundColor:[UIColor clearColor]];
}

void CZ_SetCALayerClearBackgroundColor(CALayer *layer) {
    [layer setBackgroundColor:[UIColor clearColor].CGColor];
}
void CZ_Release(id releaseObject)
{
    [releaseObject release];
};
@implementation NSDictionary (CodeZipper)

- (int)intForKey:(id)key
{
    return [[self objectForKey:key] intValue];
}

@end


@implementation UIView (CodeZipper)
@dynamic CZ_F_OriginX;
@dynamic CZ_F_OriginY;
@dynamic CZ_F_SizeW;
@dynamic CZ_F_SizeH;
@dynamic CZ_B_OriginX;
@dynamic CZ_B_OriginY;
@dynamic CZ_B_SizeW;
@dynamic CZ_B_SizeH;

+ (instancetype)newWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (CGSize)CZ_B_Size
{
    return self.bounds.size;
}

- (CGFloat)CZ_F_OriginX
{
    return self.frame.origin.x;
}

- (CGFloat)CZ_F_OriginY
{
    return self.frame.origin.y;
}

- (CGFloat)CZ_F_SizeW
{
    return self.frame.size.width;
}

- (CGFloat)CZ_F_SizeH
{
    return self.frame.size.height;
}

- (CGFloat)CZ_B_OriginX
{
    return self.bounds.origin.x;
}

- (CGFloat)CZ_B_OriginY
{
    return self.bounds.origin.y;
}

- (CGFloat)CZ_B_SizeW
{
    return self.bounds.size.width;
}

- (CGFloat)CZ_B_SizeH
{
    return self.bounds.size.height;
}

- (BOOL)layerMasksToBounds {
    return self.layer.masksToBounds;
}
- (void)setLayerMasksToBounds:(BOOL)layerMasksToBounds {
    self.layer.masksToBounds = layerMasksToBounds;
}

- (CGFloat)layerCornerRadius {
    return self.layer.cornerRadius;
}
- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    self.layer.cornerRadius = layerCornerRadius;
}

- (id)layerContents {
    return self.layer.contents;
}
- (void)setLayerContents:(id)layerContents {
    self.layer.contents = layerContents;
}

- (CGColorRef)layerBorderColor {
    return self.layer.borderColor;
}
- (void)setLayerBorderColor:(CGColorRef)layerBorderColor {
    self.layer.borderColor = layerBorderColor;
}

- (CGFloat)layerBorderWidth {
    return self.layer.borderWidth;
}
- (void)setLayerBorderWidth:(CGFloat)layerBorderWidth {
    self.layer.borderWidth = layerBorderWidth;
}

@end

@implementation CALayer (CodeZipper)
@dynamic CZ_F_OriginX;
@dynamic CZ_F_OriginY;
@dynamic CZ_F_SizeW;
@dynamic CZ_F_SizeH;
@dynamic CZ_B_OriginX;
@dynamic CZ_B_OriginY;
@dynamic CZ_B_SizeW;
@dynamic CZ_B_SizeH;

- (CGFloat)CZ_F_OriginX
{
    return self.frame.origin.x;
}

- (CGFloat)CZ_F_OriginY
{
    return self.frame.origin.y;
}

- (CGFloat)CZ_F_SizeW
{
    return self.frame.size.width;
}

- (CGFloat)CZ_F_SizeH
{
    return self.frame.size.height;
}

- (CGFloat)CZ_B_OriginX
{
    return self.bounds.origin.x;
}

- (CGFloat)CZ_B_OriginY
{
    return self.bounds.origin.y;
}

- (CGFloat)CZ_B_SizeW
{
    return self.bounds.size.width;
}

- (CGFloat)CZ_B_SizeH
{
    return self.bounds.size.height;
}

@end

@implementation UIScreen (CodeZipper)
@dynamic CZ_B_OriginX;
@dynamic CZ_B_OriginY;
@dynamic CZ_B_SizeW;
@dynamic CZ_B_SizeH;

- (CGFloat)CZ_B_OriginX
{
    return self.bounds.origin.x;
}

- (CGFloat)CZ_B_OriginY
{
    return self.bounds.origin.y;
}

- (CGFloat)CZ_B_SizeW
{
    return self.bounds.size.width;
}

- (CGFloat)CZ_B_SizeH
{
    return self.bounds.size.height;
}

@end

@implementation UINavigationController (CodeZipper)

- (void)pushViewControllerAnimated:(UIViewController *)viewController {
    [self pushViewController:viewController animated:YES];
}

@end

@implementation UIViewController (CodeZipper)

- (void)presentViewControllerAnimated:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (NSArray *)cz_popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (UIViewController *)cz_popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (void)cz_dismissViewControllerAnimated:(BOOL)animated {
    [self.navigationController dismissViewControllerAnimated:animated completion:nil];
}

- (NSArray *)cz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self.navigationController popToViewController:viewController animated:animated];
}

- (void)cz_pushViewControllerAnimated:(UIViewController *)viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)cz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)cz_dismissViewControllerAnimatedBySelf:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

-(void)cz_addSubview:(UIView*)view {
    CZ_AddSubview(self.view, view);
}


@end

#import "objc/runtime.h"

#pragma mark 判断属性与变量是否一致，只适用于debug版本

#if (defined MSFT_FUNCTION) && (defined VCLeakMonitor_Enable)

#ifdef __LP64__
#   define WORD_MASK 7UL
#else
#   define WORD_MASK 3UL
#endif

struct objc_cache {
    unsigned int mask /* total = mask + 1 */                 OBJC2_UNAVAILABLE;
    unsigned int occupied                                    OBJC2_UNAVAILABLE;
    Method buckets[1]                                        OBJC2_UNAVAILABLE;
};

typedef struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif
    const uint8_t * ivarLayout;
    const char * name;
    
} class_ro_t;

typedef struct class_rw_t {
    uint32_t flags;
    uint32_t version;
    
    const class_ro_t *ro;
    
} class_rw_t;

typedef struct objc_cache *Cache                             OBJC2_UNAVAILABLE;

typedef struct class_t {
    struct class_t *isa;
    struct class_t *superclass;
    struct objc_cache* cache;
    IMP *vtable;
    uintptr_t data_NEVER_USE;  // class_rw_t * plus custom rr/alloc flags
} class_t;

BOOL isVarInLayout(ptrdiff_t ivar_offset, const uint8_t *layout) {
    ptrdiff_t index = 0, ivar_index = ivar_offset / sizeof(void*);
    uint8_t byte;
    while ((byte = *layout++)) {
        unsigned skips = (byte >> 4);
        unsigned scans = (byte & 0x0F);
        index += skips;
        while (scans--) {
            if (index == ivar_index) return YES;
            if (index > ivar_index) return NO;
            ++index;
        }
    }
    return NO;
}

#endif

#pragma mark  动态属性相关 add by gavinhuang 2015-09-30

#define CZ_ASSIGN_GETTER_IMP(type) \
imp_implementationWithBlock(^(id receiver) { \
char *ptr = ((char *)(__bridge void *)receiver) + offset; \
type value; \
memcpy(&value, ptr, sizeof(value)); \
return value; \
})

#define CZ_ASSIGN_SETTER_IMP(type) \
imp_implementationWithBlock(^(id receiver, type value) { \
char *ptr = ((char *)(__bridge void *)receiver) + offset; \
memcpy(ptr, (void *)&value, sizeof(value)); \
})

/**
 *  Objective-C property 的内存管理规则
 */
typedef NS_ENUM(NSInteger, CZPropertyMemoryManagementPolicy) {
    CZPropertyMemoryManagementPolicyAssign = 0,
    CZPropertyMemoryManagementPolicyRetain,
    CZPropertyMemoryManagementPolicyCopy
};

/**
 * Objective-C property 的元信息
 */
typedef struct {
    /**
     *  是否声明为 readonly
     */
    BOOL readonly;
    
    /**
     *  是否声明为 nonatomic
     */
    BOOL nonatomic;
    
    /**
     *  是否声明为 weak
     */
    BOOL weak;
    
    /**
     * 是否声明为 @dynamic
     */
    BOOL dynamic;
    
    /**
     *  是否支持垃圾回收
     */
    BOOL canBeCollected;
    
    /**
     *  property 的内存管理规则，当声明为 readonly 时该值为 QZPropertyMemoryManagementPolicyAssign
     */
    CZPropertyMemoryManagementPolicy memoryManagementPolicy;
    
    /**
     *  getter 方法的名称
     */
    SEL getter;
    
    /**
     *  setter 方法的名字
     */
    SEL setter;
    
    /**
     *  property 对应的 ivar 名称，可能为 NULL
     */
    const char *ivar;
    
    /**
     *  property 所声明的类，如果 property 类型声明为 id 或运行时找不到该类则返回 nil
     */
    Class objectClass;
    
    /**
     *  property 对应的运行时 @encode 类型信息
     */
    char type[]; // 必须放在结构体的最后
    
} CZPropertyAttributes;


/**
 *  返回一个保存 Objective-C property 元信息的 CZPropertyAttributes 结构体
 *  @note 返回的结构体在使用完后需要手动调用 free()
 */
CZPropertyAttributes * CZCopyPropertyAttributes(objc_property_t property) {
    
    const char*  const attrName   = property_getName(property);
    const char * const attrString = property_getAttributes(property);
    if (!attrString) {
        QLog_Info("CZAccess","@@@@ ERROR: Could not get attribute string from property %s\n", attrName);
        return NULL;
    }
    
    if (attrString[0] != 'T') {
        QLog_Info("CZAccess","@@@@ ERROR: Expected attribute string \"%s\" for property %s to start with 'T'\n", attrString, attrName);
        return NULL;
    }
    
    const char *typeString = attrString + 1;
    const char *next = NSGetSizeAndAlignment(typeString, NULL, NULL);
    if (!next) {
        QLog_Info("CZAccess","@@@@ ERROR: Could not read past type in attribute string \"%s\" for property %s\n", attrString, attrName);
        return NULL;
    }
    
    size_t typeLength = next - typeString;
    if (!typeLength) {
        QLog_Info("CZAccess","@@@@ ERROR: Invalid type in attribute string \"%s\" for property %s\n", attrString, attrName);
        return NULL;
    }
    
    // allocate enough space for the structure and the type string (plus a NUL)
    CZPropertyAttributes *attributes = calloc(1, sizeof(CZPropertyAttributes) + typeLength + 1);
    if (!attributes) {
        QLog_Info("CZAccess","@@@@ ERROR: Could not allocate QZPropertyAttributes structure for attribute string \"%s\" for property %s\n", attrString, attrName);
        return NULL;
    }
    
    // copy the type string
    strncpy(attributes->type, typeString, typeLength);
    attributes->type[typeLength] = '\0';
    
    // if this is an object type, and immediately followed by a quoted string...
    if (typeString[0] == *(@encode(id)) && typeString[1] == '"') {
        // we should be able to extract a class name
        const char *className = typeString + 2;
        next = strchr(className, '"');
        
        if (!next) {
            QLog_Info("CZAccess","@@@@ ERROR: Could not read class name in attribute string \"%s\" for property %s\n", attrString, attrName);
            return NULL;
        }
        
        if (className != next) {
            size_t classNameLength = next - className;
            char trimmedName[classNameLength + 1];
            
            strncpy(trimmedName, className, classNameLength);
            trimmedName[classNameLength] = '\0';
            
            // attempt to look up the class in the runtime
            attributes->objectClass = objc_getClass(trimmedName);
        }
    }
    
    if (*next != '\0') {
        // skip past any junk before the first flag
        next = strchr(next, ',');
    }
    
    while (next && *next == ',') {
        char flag = next[1];
        next += 2;
        
        switch (flag) {
            case '\0':
                break;
                
            case 'R':
                attributes->readonly = YES;
                break;
                
            case 'C':
                attributes->memoryManagementPolicy = CZPropertyMemoryManagementPolicyCopy;
                break;
                
            case '&':
                attributes->memoryManagementPolicy = CZPropertyMemoryManagementPolicyRetain;
                break;
                
            case 'N':
                attributes->nonatomic = YES;
                break;
                
            case 'G':
            case 'S': {
                const char *nextFlag = strchr(next, ',');
                SEL name = NULL;
                
                if (!nextFlag) {
                    // assume that the rest of the string is the selector
                    const char *selectorString = next;
                    next = "";
                    
                    name = sel_registerName(selectorString);
                } else {
                    size_t selectorLength = nextFlag - next;
                    if (!selectorLength) {
                        QLog_Info("CZAccess","@@@@ ERROR: Found zero length selector name in attribute string \"%s\" for property %s", attrString, attrName);
                        goto errorOut;
                    }
                    
                    char selectorString[selectorLength + 1];
                    
                    strncpy(selectorString, next, selectorLength);
                    selectorString[selectorLength] = '\0';
                    
                    name = sel_registerName(selectorString);
                    next = nextFlag;
                }
                
                if (flag == 'G')
                    attributes->getter = name;
                else
                    attributes->setter = name;
            }
                
                break;
                
            case 'D':
                attributes->dynamic = YES;
                attributes->ivar = NULL;
                break;
                
            case 'V':
                // assume that the rest of the string (if present) is the ivar name
                if (*next == '\0') {
                    // if there's nothing there, let's assume this is dynamic
                    attributes->ivar = NULL;
                } else {
                    attributes->ivar = next;
                    next = "";
                }
                
                break;
                
            case 'W':
                attributes->weak = YES;
                break;
                
            case 'P':
                attributes->canBeCollected = YES;
                break;
                
            case 't':
                QLog_Info("CZAccess","@@@@ ERROR: Old-style type encoding is unsupported in attribute string \"%s\" for property %s", attrString, attrName);
                
                // skip over this type encoding
                while (*next != ',' && *next != '\0')
                    ++next;
                
                break;
                
            default:
                QLog_Info("CZAccess","@@@@ ERROR: Unrecognized attribute string flag '%c' in attribute string \"%s\" for property %s", flag, attrString, attrName);
        }
    }
    
    if (next && *next != '\0') {
        //        QLog_Info("CZAccess"," Warning: Unparsed data \"%s\" in attribute string \"%s\" for property %s", next, attrString, attrName);
    }
    
    if (!attributes->getter) {
        // use the property name as the getter by default
        attributes->getter = sel_registerName(attrName);
    }
    
    if (!attributes->setter) {
        const char *propertyName = attrName;
        size_t propertyNameLength = strlen(propertyName);
        
        // we want to transform the name to setProperty: style
        size_t setterLength = propertyNameLength + 4;
        
        char setterName[setterLength + 1];
        strncpy(setterName, "set", 3);
        strncpy(setterName + 3, propertyName, propertyNameLength);
        
        // capitalize property name for the setter
        setterName[3] = (char)toupper(setterName[3]);
        
        setterName[setterLength - 1] = ':';
        setterName[setterLength] = '\0';
        
        attributes->setter = sel_registerName(setterName);
    }
    
    return attributes;
    
errorOut:
    free(attributes);
    return NULL;
}

BOOL AddOnePropertysSetterAndGetter(Class cls,objc_property_t ocProperty,BOOL isArc,const char* selname,BOOL* paddMethod)
{
    NSString *nameString = [NSString stringWithUTF8String:property_getName(ocProperty)];
    
    if( NULL == nameString || nameString.length == 0 )
    {
        return FALSE;
    }
    
    CZPropertyAttributes* info = CZCopyPropertyAttributes(ocProperty);
    
    if( NULL == info )
    {
        return FALSE;
    }
    
    // 只有声明为 @dynamic 的 property 才需要动态添加 accessors
    if (!info->dynamic) {
        free(info);
        return FALSE;
    }
    
    if( strlen(info->type) == 0 )
    {
        free(info);
        return FALSE;
    }
    
    const char* infotype = info->type;
    NSString* typeString = [NSString stringWithUTF8String:infotype];
    
    
    const char* const clsName = class_getName(cls);
    Class dynamicClass = cls;
    NSUInteger propertySize = 0;
    NSUInteger propertyAlignment = 0;
    
    const char *type = [typeString UTF8String];
    
    NSGetSizeAndAlignment(type, &propertySize, &propertyAlignment);
    
    NSString *ivarName = CZ_NSString_stringWithFormat_c("_%@", nameString);
    
    // Add getter & setter implementation
    Ivar ivar         = class_getInstanceVariable(dynamicClass, [ivarName UTF8String]);
    
    
#if (defined MSFT_FUNCTION) && (defined VCLeakMonitor_Enable)
    /*
    if(isArc && !info->readonly)
    {
        class_rw_t *rwt = (class_rw_t *)((((class_t *)dynamicClass)->data_NEVER_USE) & ~(uintptr_t)3);
        uint32_t instanceStart = (uint32_t)((rwt->ro->instanceStart + WORD_MASK) & ~WORD_MASK);
        if (info->weak)
        {
            const uint8_t* weakLayout     = class_getWeakIvarLayout(dynamicClass);
            BOOL  bisWeakVar              = weakLayout ? isVarInLayout(ivar_getOffset(ivar)-instanceStart,weakLayout) : NO;
            if (!bisWeakVar) {
                QLog_Event("CZAccess","@@@@@@ ERROR: [%s][%s] weak property[1] != ivar[%d]  \r\n",clsName,[ivarName UTF8String],bisWeakVar);
            }
        }
        else
        {
            BOOL bisStrongProperty = YES;
            if( info->memoryManagementPolicy == CZPropertyMemoryManagementPolicyAssign)
            {
                bisStrongProperty = NO;
            }
            const uint8_t* layout     = class_getIvarLayout(dynamicClass);
            BOOL bisStrongVar         = layout ? isVarInLayout(ivar_getOffset(ivar)-instanceStart,layout) : NO;
            if (bisStrongProperty != bisStrongVar) {
                QLog_Event("CZAccess","@@@@@@ ERROR: [%s][%s] property[%d] != ivar[%d]  \r\n",clsName,[ivarName UTF8String],bisStrongProperty,bisStrongVar);
            }
        }
    }*/
#endif
    
    if( !ivar )
    {
        QLog_Event("CZAccess","@@@@ ERROR: [%s][%s] Variable not exsit ??\r\n",clsName,[ivarName UTF8String]);
        //        Method getter = class_getInstanceMethod(dynamicClass,info->getter);
        //        Method setter = class_getInstanceMethod(dynamicClass,info->setter);
        //
        //        //都没有实现
        //        if( !getter && !setter )
        //        {
        //            QLog_Event("CZAccess","@@@@ ERROR: [%s][%s] Variable not exsit ??\r\n",clsName,[ivarName UTF8String]);
        //        }
        //        //已经自己实现了getter&setter
        //        else if( getter && setter )
        //        {
        //
        //        }
        //        //实现了一半
        //        else
        //        {
        //            QLog_Event("CZAccess","@@@@ Warnning: [%s][%s] Variable not exsit getter[%d] setter[%d]\r\n",clsName,[ivarName UTF8String],getter?1:0,setter?1:0);
        //        }
        free(info);
        return FALSE;
    }
    
    if( !info->nonatomic )
    {
        QLog_Event("CZAccess","@@@@ ERROR: [%s][%s] Variable not support atomic type, please fix it first \r\n",clsName,[ivarName UTF8String]);
        free(info);
        return FALSE;
    }
    
    //    if( info->weak && class_getWeakIvarLayout(cls) == nil )
    //    {
    //        QLog_Event("CZAccess","@@_@@ warnning: [%s][%s] Variable not use __weak, please fix it first \r\n",clsName,[ivarName UTF8String]);
    //    }
    
    ptrdiff_t offset  = ivar_getOffset(ivar);
    BOOL bAddGetter   = FALSE;
    BOOL bAddSetter   = FALSE;
    
    if (info->getter) {
        IMP imp = NULL;
        
        switch (type[0]) {
            case _C_ID: {
                imp = imp_implementationWithBlock(^(id receiver) {
                    return object_getIvar(receiver, ivar);
                });
            } break;
                
            case _C_CHR:      { imp = CZ_ASSIGN_GETTER_IMP(char);               } break;
                
            case _C_INT:      { imp = CZ_ASSIGN_GETTER_IMP(int);                } break;
                
            case _C_SHT:      { imp = CZ_ASSIGN_GETTER_IMP(short);              } break;
                
            case _C_LNG:      { imp = CZ_ASSIGN_GETTER_IMP(long);               } break;
                
            case _C_LNG_LNG:  { imp = CZ_ASSIGN_GETTER_IMP(long long);          } break;
                
            case _C_UCHR:     { imp = CZ_ASSIGN_GETTER_IMP(unsigned char);      } break;
                
            case _C_UINT:     { imp = CZ_ASSIGN_GETTER_IMP(unsigned int);       } break;
                
            case _C_USHT:     { imp = CZ_ASSIGN_GETTER_IMP(unsigned short);     } break;
                
            case _C_ULNG:     { imp = CZ_ASSIGN_GETTER_IMP(unsigned long);      } break;
                
            case _C_ULNG_LNG: { imp = CZ_ASSIGN_GETTER_IMP(unsigned long long); } break;
                
            case _C_FLT:      { imp = CZ_ASSIGN_GETTER_IMP(float);              } break;
                
            case _C_DBL:      { imp = CZ_ASSIGN_GETTER_IMP(double);             } break;
                
            case _C_BOOL:     { imp = CZ_ASSIGN_GETTER_IMP(bool);               } break;
                
            case _C_SEL:      { imp = CZ_ASSIGN_GETTER_IMP(SEL);               } break;
                
            case _C_PTR:      { imp = CZ_ASSIGN_GETTER_IMP(void*);              } break;
                
            case _C_CHARPTR:  { imp = CZ_ASSIGN_GETTER_IMP(char*);              } break;
                
            case _C_STRUCT_B: {
                if (strcmp(type, @encode(CGRect)) == 0)  { imp = CZ_ASSIGN_GETTER_IMP(CGRect); break; }
                if (strcmp(type, @encode(CGSize)) == 0)  { imp = CZ_ASSIGN_GETTER_IMP(CGSize); break; }
                if (strcmp(type, @encode(CGPoint)) == 0) { imp = CZ_ASSIGN_GETTER_IMP(CGPoint); break;}
                if (strcmp(type, @encode(NSRange)) == 0) { imp = CZ_ASSIGN_GETTER_IMP(NSRange); break;}
            }; // Don't break here
                
            default: {
                
                QLog_Event("CZAccess","@@@@ ERROR: [%s][%s] Type %s hasn't implemented yet 1\r\n",clsName,[ivarName UTF8String],type);
                
            } break;
        }
        NSString* sig =  nil;
        if (type[0] != _C_STRUCT_B) {
            sig = CZ_NSString_stringWithFormat_c("%c@:",type[0]);
        }
        else {
            sig = CZ_NSString_stringWithFormat_c("%s@:",type);
        }
        bAddGetter= class_addMethod(dynamicClass, info->getter, imp, [sig UTF8String]);
        if( selname && paddMethod && strcmp(selname,sel_getName(info->getter)) == 0 )
        {
            *paddMethod = TRUE;
        }
    }
    
    if (info->setter) {
        IMP imp = NULL;
        switch (type[0]) {
            case _C_ID: {
                
                // assign or weak
                if (info->memoryManagementPolicy == CZPropertyMemoryManagementPolicyAssign) {
                    imp = imp_implementationWithBlock(^(id receiver, id value) {
                        object_setIvar(receiver, ivar, value);
                    });
                    break;
                }
                
                // storng or copy
                BOOL needsCopy = (info->memoryManagementPolicy == CZPropertyMemoryManagementPolicyCopy);
                //leak--
                imp = imp_implementationWithBlock(^(id receiver, id value) {
                    id oldValue = object_getIvar(receiver, ivar);
                    if (oldValue == value) return;
                    id newCopyValue = nil;
                    if (needsCopy) {
                        newCopyValue = [value copy];
                    }
                    object_setIvar(receiver, ivar, needsCopy ? newCopyValue : isArc?value:[value retain]);
                    if(!isArc) CZ_RELEASE(oldValue);
                    if (isArc && needsCopy) {
                        CZ_RELEASE(newCopyValue);
                    }
                });
            } break;
                
            case _C_CHR:      { imp = CZ_ASSIGN_SETTER_IMP(char);               } break;
                
            case _C_INT:      { imp = CZ_ASSIGN_SETTER_IMP(int);                } break;
                
            case _C_SHT:      { imp = CZ_ASSIGN_SETTER_IMP(short);              } break;
                
            case _C_LNG:      { imp = CZ_ASSIGN_SETTER_IMP(long);               } break;
                
            case _C_LNG_LNG:  { imp = CZ_ASSIGN_SETTER_IMP(long long);          } break;
                
            case _C_UCHR:     { imp = CZ_ASSIGN_SETTER_IMP(unsigned char);      } break;
                
            case _C_UINT:     { imp = CZ_ASSIGN_SETTER_IMP(unsigned int);       } break;
                
            case _C_USHT:     { imp = CZ_ASSIGN_SETTER_IMP(unsigned short);     } break;
                
            case _C_ULNG:     { imp = CZ_ASSIGN_SETTER_IMP(unsigned long);      } break;
                
            case _C_ULNG_LNG: { imp = CZ_ASSIGN_SETTER_IMP(unsigned long long); } break;
                
            case _C_FLT:      { imp = CZ_ASSIGN_SETTER_IMP(float);              } break;
                
            case _C_DBL:      { imp = CZ_ASSIGN_SETTER_IMP(double);             } break;
                
            case _C_BOOL:     { imp = CZ_ASSIGN_SETTER_IMP(bool);               } break;
                
            case _C_SEL:      { imp = CZ_ASSIGN_SETTER_IMP(SEL);               } break;
                
            case _C_PTR:      { imp = CZ_ASSIGN_SETTER_IMP(void*);              } break;
                
            case _C_CHARPTR:  { imp = CZ_ASSIGN_SETTER_IMP(char*);              } break;
                
            case _C_STRUCT_B: {
                if (strcmp(type, @encode(CGRect)) == 0)  { imp = CZ_ASSIGN_SETTER_IMP(CGRect); break; }
                
                if (strcmp(type, @encode(CGSize)) == 0)  { imp = CZ_ASSIGN_SETTER_IMP(CGSize); break; }
                
                if (strcmp(type, @encode(CGPoint)) == 0) { imp = CZ_ASSIGN_SETTER_IMP(CGPoint); break; }
                
                if (strcmp(type, @encode(NSRange)) == 0) { imp = CZ_ASSIGN_SETTER_IMP(NSRange); break; }
            }; // Don't break here!
                
            default: {
                
                QLog_Event("CZAccess","@@@@ ERROR: [%s][%s] Type %s hasn't implemented yet \r\n",clsName,[ivarName UTF8String],type);
                
            } break;
        }
        NSString* sig =  nil;
        if (type[0] != _C_STRUCT_B) {
            sig = CZ_NSString_stringWithFormat_c("v@:%c", type[0]);
        }
        else {
            sig = CZ_NSString_stringWithFormat_c("v@:%s", type);
        }
        bAddSetter = class_addMethod(dynamicClass, info->setter, imp, [sig UTF8String]);
        if( selname && paddMethod && strcmp(selname,sel_getName(info->setter) ) == 0 )
        {
            *paddMethod = TRUE;
        }
    }
    //    QLog_Info("CZAccess"," [%s] %s -> S[%d] G[%d]",clsName,[ivarName UTF8String],bAddSetter,bAddGetter);
    free(info);
    return (bAddSetter||bAddGetter);
}

BOOL IsContinueToDo(Class cls,BOOL *pisArc, BOOL *isOnlyone)
{
    *pisArc = FALSE;
    *isOnlyone = FALSE;
    Ivar ivxo = class_getInstanceVariable(cls,"_xo");
    
    if( ivxo == NULL )
    {
        return FALSE;
    }
    
    if( class_getIvarLayout(cls) )
    {
        *pisArc = TRUE;
    }
    
    IMP imp = imp_implementationWithBlock(^(id receiver) {return 100;});
    SEL getter = sel_registerName("xo");
    if( !class_addMethod(cls, getter, imp, "i@:") )
    {
        //        QLog_Info("CZAccess","@@@@ Warnning: class_addMethod false IsContinueToDo ->clss name[%s] \r\n",class_getName(cls));
        *isOnlyone = TRUE;
        return TRUE;
    }
    
    return TRUE;
}


//@dynamic Property Add setter & getter
void AddDynamicPropertysSetterAndGetter(id instance,const char* selname,BOOL* pAddMethodSuc)
{
    Class cls = [instance class];
    
    while ( 1 )
    {
        BOOL bArc = FALSE;
        BOOL isOnlyone = FALSE;
        if( !IsContinueToDo(cls,&bArc,&isOnlyone) )
        {
            return;
        }
        
        if(isOnlyone)
        {
            objc_property_t properties =class_getProperty(cls, selname);
            if(properties == NULL)
            {
                size_t len = strlen(selname)+1;
                if (len >4 ) {  //［setXxx:］set和:
                    char* setProp = (char*)malloc(strlen(selname)+1);
                    memset(setProp, 0, len);
                    memcpy(setProp, selname+3, len-5);
                    setProp[0] = tolower(setProp[0]);
                    properties = class_getProperty(cls, setProp);
                    
                    if (properties == NULL) {
                        setProp[0] = toupper(setProp[0]);
                        properties = class_getProperty(cls, setProp);
                    }
                    //                    QLog_Info("CZAccess","isOnlyone [%s][%s][%s]\n",clsname,selname,setProp);
                    free(setProp);
                }
            }
            if(properties)
            {
                AddOnePropertysSetterAndGetter(cls,properties,bArc,selname,pAddMethodSuc);
                return;
            }
            
            //            QLog_Info("CZAccess","@@@@ Warnning [%s][%s] AddDynamicSetAndGetter var not exist\n",clsname,selname);
            
            return;
        }
        static unsigned long totalCount = 0;
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        //        unsigned long oldcount = totalCount;
        //        QLog_Info("CZAccess","[%s:arc[%d]...]",clsname,bArc);
        
        for (unsigned int i = 0; i < count; i++)
        {
            if( AddOnePropertysSetterAndGetter(cls,properties[i],bArc,selname,pAddMethodSuc) )
            {
                totalCount++;
            }
        }
        
        //        if( totalCount > oldcount )
        //        {
        //            QLog_Info("CZAccess","totalCount[%lu] [%s:arc[%d]] AddSetAndGetter Count[%d]",totalCount,clsname,bArc,count);
        //        }
        
        free(properties);
        
        cls = [cls superclass];
        if( nil == cls ) break;
        continue;
    }
    
}

UIColor *CZ_UIColorRGB(uint32_t colorHexRGB){
    return CZ_UIColorARGB(0xFF000000|colorHexRGB);
}


void CZ_UIViewRemoveSubView(UIView *subView)
{
    [subView removeFromSuperview];
}

void CZ_ContainerAddObject(NSObject *container, __kindof NSObject *obj)
{
    [container addObject:obj];
}

__kindof id CZ_ValueForKey(__kindof NSObject *obj, NSString *key)
{
    return [obj valueForKey:key];
}

__kindof id CZ_ValueForKey_c(__kindof NSObject *obj, const char *key)
{
    return [obj valueForKey:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),key)];
}

__kindof id CZ_DicGetValueForKey(__kindof NSObject *dic, NSObject *key)
{
    return [((NSDictionary *)dic) objectForKey:key];
}

__kindof id CZ_DicGetValueForKey_c(__kindof NSObject *dic, const char *key)
{
    return CZ_DicGetValueForKey(dic, kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),key));
}


//7.25类型保护
__kindof id CZ_ValueForKeyCheckType(__kindof NSObject *obj, NSString *key,Class type)
{
    id value = [obj valueForKey:key];
    if (value && CHECK_TYPE(value,type))
    {
        return value;
    }
    return nil;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

__kindof id CZ_ValueForKey_cCheckType(__kindof NSObject *obj, const char *key,Class type)
{
    id value = [obj valueForKey:kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),key)];
    if (value && CHECK_TYPE(value,type))
    {
        return value;
    }
    return nil;
}

__kindof id CZ_DicGetValueForKeyCheckType(__kindof NSObject *dic, NSObject *key ,Class type)
{
    id value = CZ_DicGetValueForKey( dic , key );
    if (value && CHECK_TYPE(value,type))
    {
        return value;
    }
    return nil;
}

__kindof id CZ_DicGetValueForKey_cCheckType(__kindof NSObject *dic, const char *key, Class type)
{
    id value = CZ_DicGetValueForKey(dic, kCZStringWithUTF8StringPtr(g_var_NSStringClass,@selector(stringWithUTF8String),key));
    if (value && CHECK_TYPE(value,type))
    {
        return value;
    }
    return nil;
}
#pragma clang diagnostic pop

__kindof id CZ_DicGetObjectAtIndex(NSArray *array, NSUInteger index)
{
    return [array objectAtIndex:index];
}

UILabel *CZ_UILabel(CGRect frame, CGFloat fontSize, int textColorHexRGB){
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = CZ_UIColorRGB(textColorHexRGB);
    label.adjustsFontSizeToFitWidth = YES;
    return [label autorelease];
}

UIColor *CZ_UIColorARGB(uint32_t hex){
    return [UIColor colorWithARGBHex:hex];
}


void CZ_dispatch_global(dispatch_block_t block){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void CZ_dispatch_global_priority(dispatch_block_t block, int16_t priority){
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

void CZ_dispatch_main(dispatch_block_t block){
    dispatch_async(dispatch_get_main_queue(), block);
}

NSString *CZ_UTF8String(const char * utf8string){
    return [NSString stringWithUTF8String:utf8string];
}


NSDate *CZ_NSDateNow(){
    return [NSDate date];
}

CGSize CZ_MainScreenSize(){
    return [UIScreen mainScreen].bounds.size;
}

UIScreen *CZ_MainScreen() {
    return [UIScreen mainScreen];
}

BOOL CZ_isKindOfClass(NSObject * obj,Class cls)
{
    return [obj isKindOfClass:cls];
}

BOOL CZ_kindOfClsName(NSObject *obj, NSString *clsName) {
    return [obj isKindOfClass:NSClassFromString(clsName)];
}

void CZ_PerformSelectorAfterDelay(NSObject *target, SEL sel, NSObject *obj, NSTimeInterval delay) {
    [target performSelector:sel withObject:obj afterDelay:delay];
}


UIApplication *CZ_SharedApplication() {
    return [UIApplication sharedApplication];
}

UIDevice *CZ_CurrentDevice() {
    return [UIDevice currentDevice];
}

NSMutableArray *CZ_ArrayWithArray(NSArray *array) {
    return [NSMutableArray arrayWithArray:array];
}

UIColor *CZ_UIColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


id QZFirstObject(NSArray *array) {
    return [array firstObject];
}

id QZNthObject(NSArray *array, NSUInteger index) {
    return ([array count] > index) ? array[index] : nil;
}

id QZObjectForKey(NSDictionary *dictionary, id<NSCopying> key) {
    return dictionary[key];
}

NSInteger QZNSStringIntegerValue(NSString *string) {
    return [string integerValue];
}

NSInteger QZNSNumberIntegerValue(NSNumber *number) {
    return [number integerValue];
}

NSInteger QZIDIntegerValue(id obj) {
    return [obj integerValue];
}

BOOL QZNSStringBoolValue(NSString *string) {
    return [string boolValue];
}

BOOL QZNSNumberBoolValue(NSNumber *number) {
    return [number boolValue];
}

BOOL QZIDBoolValue(id obj) {
    return [obj boolValue];
}

float QZNSStringFloatValue(NSString *string) {
    return [string floatValue];
}

float QZNSNumberFloatValue(NSNumber *number) {
    return [number floatValue];
}

float QZIDFloatValue(id obj) {
    return [obj floatValue];
}

void QZSetObjectForKey(NSMutableDictionary *dictionary, id object, const char *key) {
    [dictionary setObject:object forKey:@(key)];
}

void QZSetObjectForObjKey(NSMutableDictionary *dictionary, id object, id<NSCopying> key) {
    [dictionary setObject:object forKey:key];
}

void QZSetDelegate(NSObject *target, id delegate) {
    SEL selector = NSSelectorFromString(@"setDelegate:");
    [target performSelector:selector withObject:delegate];
}

BOOL QZISIPhoneX(void){
    return UIDeviceXiPhone == [[UIDevice currentDevice] platformType];
}
