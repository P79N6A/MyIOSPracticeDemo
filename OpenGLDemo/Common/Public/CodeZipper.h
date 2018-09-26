//
//  CodeZipper.h
//  QQMSFContact
//
//  Created by Vincent on 21/8/15.
//
//

//@protocol IAccountService;
//@protocol IPacketDispatchService;
//@protocol IContactsService;
//@protocol IIMService;
//
//@protocol GroupDBServiceInterface;
//@protocol IMessageListService;
//@protocol IC2CDBService;
//@protocol IC2CDBService_MultiTable;
//@protocol QQReportProtocol;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@class QQProgressData;
//@class QQReportEngine;

#ifdef __cplusplus
extern "C" {
#endif
    
#define CZ_DYNAMIC_PROPERTYS_FLAG_VAR int _xo;
    
#if  __has_feature(objc_arc)
    
#define CZ_DYNAMIC_PROPERTY_ASSIGN                                                      __unsafe_unretained
#define CZ_NewUILabel()                                                                 CZ_NewUILabelFuncARC()
#define CZ_NewUILabelWithFrame(frame)                                                   CZ_NewUILabelWithFrameFuncARC(frame)
    
#define CZ_NewUIImageViewWithFrame(frame)                                               CZ_NewUIImageViewWithFrameFuncARC(frame)
#define CZ_NewUIImageViewWithImage(image)                                               CZ_NewUIImageViewWithImageFuncARC(image)
#define CZ_NewUIImageView()                                                             CZ_NewUIImageViewFuncARC()
    
#define CZ_NewUIViewWithFrame(frame)                                                    CZ_NewUIViewWithFrameFuncARC(frame)
#define CZ_NewUIView()                                                                  CZ_NewUIViewFuncARC()
    
#define CZ_NewUITabView(rect, style)                                                    CZ_NewUITabViewFuncARC(rect, style)
#define CZ_NewUITableViewCell(style,reuseIdentifier)                                    CZ_NewUITableViewCellFuncARC(style,reuseIdentifier)
#define CZ_NewUITableViewCellDefault(reuseIdentifier)                                   CZ_NewUITableViewCellDefaultFuncARC(reuseIdentifier)
    
#define CZ_NewMutableArrayWithCapacity(capacity)                                        CZ_NewMutableArrayWithCapacityFuncARC(capacity)
#define CZ_NewMutableArray()                                                            CZ_NewMutableArrayFuncARC()
    
#define CZ_NewMutableDictionaryWithCapacity(capacity)                                    CZ_NewMutableDictionaryWithCapacityFuncARC(capacity)
#define CZ_NewMutableDictionary()                                                        CZ_NewMutableDictionaryFuncARC()
    
#define CZ_NewCustomUIButton()                                                          CZ_NewCustomUIButtonFuncARC()
#define CZ_NewSystemFontOfSize(size)                                                    CZ_NewSystemFontOfSizeFuncARC(size)
#define CZ_NewBoldSystemFontOfSize(size)                                                CZ_NewBoldSystemFontOfSizeFuncARC(size)
    
#define CZ_NSNumber_numberWithChar(value)                                               CZ_NSNumber_numberWithCharFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedChar(value)                                       CZ_NSNumber_numberWithUnsignedCharFuncARC(value)
#define CZ_NSNumber_numberWithShort(value)                                              CZ_NSNumber_numberWithShortFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedShort(value)                                      CZ_NSNumber_numberWithUnsignedShortFuncARC(value)
#define CZ_NSNumber_numberWithInt(value)                                                CZ_NSNumber_numberWithIntFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedInt(value)                                        CZ_NSNumber_numberWithUnsignedIntFuncARC(value)
#define CZ_NSNumber_numberWithLong(value)                                               CZ_NSNumber_numberWithLongFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedLong(value)                                       CZ_NSNumber_numberWithUnsignedLongFuncARC(value)
#define CZ_NSNumber_numberWithLongLong(value)                                           CZ_NSNumber_numberWithLongLongFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedLongLong(value)                                   CZ_NSNumber_numberWithUnsignedLongLongFuncARC(value)
#define CZ_NSNumber_numberWithFloat(value)                                              CZ_NSNumber_numberWithFloatFuncARC(value)
#define CZ_NSNumber_numberWithDouble(value)                                             CZ_NSNumber_numberWithDoubleFuncARC(value)
#define CZ_NSNumber_numberWithBool(value)                                               CZ_NSNumber_numberWithBoolFuncARC(value)
#define CZ_NSNumber_numberWithInteger(value)                                            CZ_NSNumber_numberWithIntegerFuncARC(value)
#define CZ_NSNumber_numberWithUnsignedInteger(value)                                    CZ_NSNumber_numberWithUnsignedIntegerFuncARC(value)
#define CZ_UITapGestureRecognizerNew(target, selector)                                  CZ_UITapGestureRecognizerMakeARC(target, selector)
#else
    
#define CZ_DYNAMIC_PROPERTY_ASSIGN
#define CZ_NewUILabel()                                                                 CZ_NewUILabelFunc()
#define CZ_NewUILabelWithFrame(frame)                                                   CZ_NewUILabelWithFrameFunc(frame)
    
#define CZ_NewUIImageViewWithFrame(frame)                                               CZ_NewUIImageViewWithFrameFunc(frame)
#define CZ_NewUIImageViewWithImage(image)                                               CZ_NewUIImageViewWithImageFunc(image)
#define CZ_NewUIImageView()                                                             CZ_NewUIImageViewFunc()
    
#define CZ_NewUIViewWithFrame(frame)                                                    CZ_NewUIViewWithFrameFunc(frame)
#define CZ_NewUIView()                                                                  CZ_NewUIViewFunc()
    
#define CZ_NewUITabView(rect, style)                                                    CZ_NewUITabViewFunc(rect, style)
#define CZ_NewUITableViewCell(style, reuseIdentifier)                                   CZ_NewUITableViewCellFunc(style,reuseIdentifier)
#define CZ_NewUITableViewCellDefault(reuseIdentifier)                                   CZ_NewUITableViewCellDefaultFunc(reuseIdentifier)
    
#define CZ_NewMutableArrayWithCapacity(capacity)                                        CZ_NewMutableArrayWithCapacityFunc(capacity)
#define CZ_NewMutableArray()                                                            CZ_NewMutableArrayFunc()
    
#define CZ_NewMutableDictionaryWithCapacity(capacity)                                   CZ_NewMutableDictionaryWithCapacityFunc(capacity)
#define CZ_NewMutableDictionary()                                                       CZ_NewMutableDictionaryFunc()
    
#define CZ_NewCustomUIButton()                                                          CZ_NewCustomUIButtonFunc()
#define CZ_NewSystemFontOfSize(size)                                                    CZ_NewSystemFontOfSizeFunc(size)
#define CZ_NewBoldSystemFontOfSize(size)                                                CZ_NewBoldSystemFontOfSizeFunc(size)
    
#define CZ_NewCustomUIButton()                                                          CZ_NewCustomUIButtonFunc()
    
#define CZ_NSNumber_numberWithChar(value)                                               CZ_NSNumber_numberWithCharFunc(value)
#define CZ_NSNumber_numberWithUnsignedChar(value)                                       CZ_NSNumber_numberWithUnsignedCharFunc(value)
#define CZ_NSNumber_numberWithShort(value)                                              CZ_NSNumber_numberWithShortFunc(value)
#define CZ_NSNumber_numberWithUnsignedShort(value)                                      CZ_NSNumber_numberWithUnsignedShortFunc(value)
#define CZ_NSNumber_numberWithInt(value)                                                CZ_NSNumber_numberWithIntFunc(value)
#define CZ_NSNumber_numberWithUnsignedInt(value)                                        CZ_NSNumber_numberWithUnsignedIntFunc(value)
#define CZ_NSNumber_numberWithLong(value)                                               CZ_NSNumber_numberWithLongFunc(value)
#define CZ_NSNumber_numberWithUnsignedLong(value)                                       CZ_NSNumber_numberWithUnsignedLongFunc(value)
#define CZ_NSNumber_numberWithLongLong(value)                                           CZ_NSNumber_numberWithLongLongFunc(value)
#define CZ_NSNumber_numberWithUnsignedLongLong(value)                                   CZ_NSNumber_numberWithUnsignedLongLongFunc(value)
#define CZ_NSNumber_numberWithFloat(value)                                              CZ_NSNumber_numberWithFloatFunc(value)
#define CZ_NSNumber_numberWithDouble(value)                                             CZ_NSNumber_numberWithDoubleFunc(value)
#define CZ_NSNumber_numberWithBool(value)                                               CZ_NSNumber_numberWithBoolFunc(value)
#define CZ_NSNumber_numberWithInteger(value)                                            CZ_NSNumber_numberWithIntegerFunc(value)
#define CZ_NSNumber_numberWithUnsignedInteger(value)                                    CZ_NSNumber_numberWithUnsignedIntegerFunc(value)
#endif
    
    void CZ_PerformSelectorAfterDelay(NSObject *target, SEL sel, NSObject *obj, NSTimeInterval delay);
    UIApplication *CZ_SharedApplication(void);
    UIDevice *CZ_CurrentDevice(void);
    NSMutableArray *CZ_ArrayWithArray(NSArray *array);
    void CZ_SetNavigationBarHidden(UINavigationController *nav, BOOL hidden, BOOL animated);
    
    
    
    UILabel *CZ_NewUILabelFunc(void);
    UILabel *CZ_NewUILabelWithFrameFunc(CGRect frame);
    
    UIImageView *CZ_NewUIImageViewWithFrameFunc(CGRect frame);
    UIImageView *CZ_NewUIImageViewWithImageFunc(UIImage*image);
    UIImageView *CZ_NewUIImageViewFunc(void);
    
    
    UIView *CZ_NewUIViewWithFrameFunc(CGRect frame);
    UIView *CZ_NewUIViewFunc(void);
    
    UITableViewCell *CZ_NewUITableViewCellFunc(UITableViewCellStyle style, NSString* reuseIdentifier);
    UITableViewCell *CZ_NewUITableViewCellDefaultFunc(NSString* reuseIdentifier);
    
    id CZ_UITableViewDequeueReusableCellDefaultFunc(UITableView *tableView, Class cls);
    id CZ_UITableViewDequeueReusableCellDefaultIDFunc(UITableView *tableView, Class cls, NSString *reuseIdentifier);
    
    NSIndexPath* CZ_IndexPathForRow(NSInteger row, NSInteger section);
    
    NSMutableArray* CZ_NewMutableArrayWithCapacityFunc(NSUInteger capacity);
    NSMutableArray* CZ_NewMutableArrayFunc(void);
    
    NSMutableDictionary* CZ_NewMutableDictionaryWithCapacityFunc(NSUInteger capacity);
    NSMutableDictionary* CZ_NewMutableDictionaryFunc(void);
    
    UIButton *CZ_NewCustomUIButtonFunc(void);
    UIFont *CZ_NewSystemFontOfSizeFunc(CGFloat size);
    UIFont *CZ_NewBoldSystemFontOfSizeFunc(CGFloat size);
    
    NSNumber *CZ_NSNumber_numberWithCharFunc(char value);
    NSNumber *CZ_NSNumber_numberWithUnsignedCharFunc(unsigned char value);
    NSNumber *CZ_NSNumber_numberWithShortFunc(short value);
    NSNumber *CZ_NSNumber_numberWithUnsignedShortFunc(unsigned short value);
    NSNumber *CZ_NSNumber_numberWithIntFunc(int value);
    NSNumber *CZ_NSNumber_numberWithUnsignedIntFunc(unsigned int value);
    NSNumber *CZ_NSNumber_numberWithLongFunc(long value);
    NSNumber *CZ_NSNumber_numberWithUnsignedLongFunc(unsigned long value);
    NSNumber *CZ_NSNumber_numberWithLongLongFunc(long long value);
    NSNumber *CZ_NSNumber_numberWithUnsignedLongLongFunc(unsigned long long value);
    NSNumber *CZ_NSNumber_numberWithFloatFunc(float value);
    NSNumber *CZ_NSNumber_numberWithDoubleFunc(double value);
    NSNumber *CZ_NSNumber_numberWithBoolFunc(BOOL value);
    NSNumber *CZ_NSNumber_numberWithIntegerFunc(NSInteger value);
    NSNumber *CZ_NSNumber_numberWithUnsignedIntegerFunc(NSUInteger value);
    
    //arc
    UILabel *CZ_NewUILabelFuncARC(void);
    UILabel *CZ_NewUILabelWithFrameFuncARC(CGRect frame);
    
    UIImageView *CZ_NewUIImageViewWithFrameFuncARC(CGRect frame);
    UIImageView *CZ_NewUIImageViewWithImageFuncARC(UIImage*image);
    UIImageView *CZ_NewUIImageViewFuncARC(void);
    
    
    UIView *CZ_NewUIViewWithFrameFuncARC(CGRect frame);
    UIView *CZ_NewUIViewFuncARC(void);
    
    NSString *CZ_NewUTF8StringWithData(NSData *data);
    NSString *CZ_NewUTF8StringWithDataARC(NSData *data);
    
    UITableViewCell *CZ_NewUITableViewCellFuncARC(UITableViewCellStyle style, NSString* reuseIdentifier);
    UITableViewCell *CZ_NewUITableViewCellDefaultFuncARC(NSString* reuseIdentifier);
    
    id CZ_UITableViewDequeueReusableCellDefault(UITableView *tableView, Class cls);
    id CZ_UITableViewDequeueReusableCellDefaultID(UITableView *tableView, Class cls, NSString *reuseIdentifier);
    
    UITableView *CZ_NewUITabViewFunc(CGRect rect, UITableViewStyle style);
    UITableView *CZ_NewUITabViewFuncARC(CGRect rect, UITableViewStyle style);
    
    NSMutableArray* CZ_NewMutableArrayWithCapacityFuncARC(NSUInteger capacity);
    NSMutableArray* CZ_NewMutableArrayFuncARC(void);
    
    NSMutableDictionary* CZ_NewMutableDictionaryWithCapacityFuncARC(NSUInteger capacity);
    NSMutableDictionary* CZ_NewMutableDictionaryFuncARC(void);
    
    UIButton *CZ_NewCustomUIButtonFuncARC(void);
    UIFont *CZ_NewSystemFontOfSizeFuncARC(CGFloat size);
    UIFont *CZ_NewBoldSystemFontOfSizeFuncARC(CGFloat size);
    
    void CZ_UIButtonSetTitleLabelFont(UIButton *button, UIFont *font);
    void CZ_UILabelSetFont(UILabel *label, UIFont *font);
    
    UITapGestureRecognizer *CZ_UITapGestureRecognizerNew(id target, SEL action);
    UITapGestureRecognizer *CZ_UITapGestureRecognizerMakeARC(id target, SEL action);
    
    NSNumber *CZ_NSNumber_numberWithCharFuncARC(char value);
    NSNumber *CZ_NSNumber_numberWithUnsignedCharFuncARC(unsigned char value);
    NSNumber *CZ_NSNumber_numberWithShortFuncARC(short value);
    NSNumber *CZ_NSNumber_numberWithUnsignedShortFuncARC(unsigned short value);
    NSNumber *CZ_NSNumber_numberWithIntFuncARC(int value);
    NSNumber *CZ_NSNumber_numberWithUnsignedIntFuncARC(unsigned int value);
    NSNumber *CZ_NSNumber_numberWithLongFuncARC(long value);
    NSNumber *CZ_NSNumber_numberWithUnsignedLongFuncARC(unsigned long value);
    NSNumber *CZ_NSNumber_numberWithLongLongFuncARC(long long value);
    NSNumber *CZ_NSNumber_numberWithUnsignedLongLongFuncARC(unsigned long long value);
    NSNumber *CZ_NSNumber_numberWithFloatFuncARC(float value);
    NSNumber *CZ_NSNumber_numberWithDoubleFuncARC(double value);
    NSNumber *CZ_NSNumber_numberWithBoolFuncARC(BOOL value);
    NSNumber *CZ_NSNumber_numberWithIntegerFuncARC(NSInteger value);
    NSNumber *CZ_NSNumber_numberWithUnsignedIntegerFuncARC(NSUInteger value);
    
    NSString* CZ_GetLocalizedStr_c(const char *str);
    NSString* CZ_GetLocalizedStr(NSString* str);
    
    UIImage* CZ_LoadIconWithCache_c(const char *imageName);
    UIImage* CZ_LoadIconWithCache(NSString* imageName);
    UIImage* CZ_LoadIconWithOutCache_c(const char *imageName);
    UIImage* CZ_LoadIconWithOutCache(NSString* imageName);
    UIImage* CZ_LoadIconThemeWithCache_c(const char *imageName);
    UIImage* CZ_LoadIconThemeWithCache(NSString* imageName);
    UIImage* CZ_LoadIconThemeWithOutCache_c(const char *imageName);
    UIImage* CZ_LoadIconThemeWithOutCache(NSString* imageName);
    UIImage* CZ_LoadDefaultIconWithCache_c(const char *imageName);
    UIImage* CZ_LoadDefaultIconWithCache(NSString* imageName);
    
    id<IPacketDispatchService> CZ_GetPacketDispatchService(void);
    id<IAccountService> CZ_GetAccountService(void);
    id<IContactsService> CZ_GetContactsService(void);
    id<IIMService> CZ_GetIMService(void);
    QQReportEngine *CZ_GetReportEngine(void);
    void CZ_Report643WithOpType(NSString * opType);
    void CZ_Report898WithOpType(NSString * opType);
    void CZ_Report898WithOpTypeAndEntry(NSString * opType, NSString * opName,int entry);
    void CZ_ReportWithModel(id<QQReportProtocol> reportModel);
    
    NSTimeInterval CZ_getCurrentLocalTime(void);
    NSString* CZ_GetSelfUin(void);
    BOOL      CZ_GetReadInjoyTabOn(void);//0为NO, 1、2 为YES
    BOOL    CZ_GetReadInjoyVideoTabOn(void); // 0、1为NO, 2 YES
    BOOL CZ_InReadJoyIndependTab(void);//2模式下，当前是否在独立 tab
    
    BOOL CZ_ReadinjoySocialOpened(void);
    
    void CZ_SetInReadJoyIndependTab(BOOL inTab);
    
    void CZ_SetInWeishiChannel(BOOL inWeishi);
    BOOL CZ_InWeishiChannel(void);
    
    void CZ_AddObj2DeftNotiCenter(id obs, SEL sel, NSString* name, id obj);
    void CZ_AddObj2DeftNotiCenterNoObj(id obs, SEL sel, NSString* name);
    void CZ_RemoveObjFromDeftNotiCenter(id obs, NSString* name, id obj);
    void CZ_RemoveObjFromDeftNotiCenterNoObj(id obs, NSString* name);
    void CZ_RemoveObjFromDeftNotiCenterOnly(id obs);
    void CZ_PostNotifyWithInfo(NSString* name, id obj, NSDictionary* userInfo);
    void CZ_PostNotifyWithInfoNoObj(NSString* name, NSDictionary* userInfo);
    void CZ_PostNotify(NSString* name, id obj);
    void CZ_PostNotifyNoObj(NSString* name);
    
    id<UIApplicationDelegate> CZ_GetAppDelegate(void);
    UINavigationController* CZ_GetSelectedVC(void);
    UIWindow* CZ_GetAppKeyWindow(void);
    
    void CZ_PostRegisteNotificationToIMService(NSString *cmd, id object, NSDictionary *userInfo);
    void CZ_PostRegisteNotificationToIMServiceWithPriority(NSString *cmd, id object, NSDictionary *userInfo, BOOL priority);
    
    id<GroupDBServiceInterface> CZ_GetGroupDBServiceFunc(void);
    id<IMessageListService> CZ_GetMessageListServiceFunc(void);
    id<IC2CDBService> CZ_GetC2CDBServiceFunc(void);
    id<IC2CDBService_MultiTable> CZ_GetC2CMultiTableDBFunc(void);
    
    id CZ_GetTableDBFunc(int accType);
    
    BOOL CZ_isFileExistInDir(NSString *path, BOOL *isDir);
    BOOL CZ_IsFileExistFunc(NSString *path);
    BOOL CZ_removeFileAtPathWithError(NSString* path,NSError ** error);
    BOOL CZ_removeFileAtPath(NSString *path);
    
    int CZ_GetServerTimeDiff(void);
    
    extern UIColor * GlobalClearColor;
    extern UIColor * GlobalWhiteColor;
    
    void CZ_QQProgressHUD_Dismiss(void);
    void CZ_QQProgressHUD_DismissAfterDelay(NSTimeInterval time);
    void CZ_QQProgressHUD_ShowFailState(NSString *state);
    void CZ_QQProgressHUD_ShowSuccessState(NSString *state);
    void CZ_QQProgressHUD_ShowNetWorkFailTip(void);
    
    void AddDynamicPropertysSetterAndGetter(id instance,const char* selname,BOOL* pAddMethodSuc);
    
    UIColor *CZ_GetClearColor(void);
    BOOL CZ_UIApplicationOpenUrl(NSURL *url);
    UIApplication* CZ_GetSharedUIApplication(void);
    UINavigationController*CZ_GetCurNavController(void);
    NSString *CZ_GetNSStringFromCStr(const char *cStr);
    
    UIImage* CZ_LoadDefaultImg(NSString* name, BOOL isDefault);
    UIColor* CZ_getDefaultColor(int type, BOOL isDefault);
    
    
    UIColor *CZ_UIColorRGB(uint32_t colorRGB);
    UIColor *CZ_UIColorARGB(uint32_t colorRGB);
    UIColor *CZ_UIColorRGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
    
    UILabel *CZ_UILabel(CGRect frame, CGFloat fontSize, int textColorHexRGB);
    
    void CZ_UIViewRemoveSubView(UIView *subView);
    void CZ_ContainerAddObject(NSObject *container, __kindof NSObject *obj);
    __kindof id CZ_ValueForKey(__kindof NSObject *obj, NSString *key);
    __kindof id CZ_ValueForKey_c(__kindof NSObject *obj, const char *key);
    __kindof id CZ_DicGetValueForKey(__kindof NSObject *dic, NSObject *key);
    __kindof id CZ_DicGetValueForKey_c(__kindof NSObject *dic, const char *key);
    __kindof id CZ_DicGetObjectAtIndex(NSArray *array, NSUInteger index);
    
    //7.25类型保护检查
    __kindof id CZ_ValueForKey_cCheckType(__kindof NSObject *obj, const char *key,Class type);
    __kindof id CZ_ValueForKeyCheckType(__kindof NSObject *obj, NSString *key,Class type);
    __kindof id CZ_DicGetValueForKeyCheckType(__kindof NSObject *dic, NSObject *key ,Class type);
    __kindof id CZ_DicGetValueForKey_cCheckType(__kindof NSObject *dic, const char *key, Class type);
    
    void CZ_SetUIViewHiddenYES(UIView *obj);
    void CZ_SetCALayerHiddenYES(CALayer *obj);
    void CZ_SetQQProgressHiddenYES(QQProgressData *obj);
    
    void CZ_SetUIViewHiddenNO(UIView *obj);
    void CZ_SetCALayerHiddenNO(CALayer *obj);
    void CZ_SetQQProgressHiddenNO(QQProgressData *obj);
    
    void CZ_SetHidden(id obj, BOOL hidden);
    
    void CZ_AddSubview(UIView *view, UIView *subview);
    void CZ_RasterizeView(UIView *view);
    BOOL CZ_RespondsToSelector(id<NSObject> obj, SEL selector);
    BOOL CZ_IsEmptyString(NSString *const string);
    BOOL CZ_StringEqualToString(NSString *const string1, NSString *const string2);
    BOOL CZ_StringEqualToString_c(NSString *const string1, const char * string2);
    void CZ_AddTargetForTouchUpInsideEvents(UIControl *control, id target, SEL action);
    BOOL CZ_StringHasPrefix_c(NSString *const string1, const char * string2);
    NSString * CZ_stringByAppendingString(NSString *const string1, NSString *const string2);
    NSString * CZ_stringByAppendingString_c(NSString *const string1, const char * string2);
    void CZ_appendString_c(NSMutableString *const string1, const char * string2);
    BOOL CZ_IsEmptyStringOrNil(NSString *const string);
    
    void CZ_UIViewSetFrame(UIView *obj, CGRect frame);
    void CZ_CALayerSetFrame(CALayer *obj, CGRect frame);
    void CZ_setFrame(id obj, CGRect frame);
    
    void CZ_SetTitleAndColor(UIButton *button, NSString *title, UIColor *color);
    
    void CZ_CancelPreviousPerformRequest(id target, SEL selector, id obj);
    
    static inline void __attribute__((overloadable)) CZ_SetFrame(UIView *view, CGRect frame) {
        CZ_UIViewSetFrame(view, frame);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetFrame(CALayer *layer, CGRect frame) {
        CZ_CALayerSetFrame(layer, frame);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenYES(UIView *view) {
        CZ_SetUIViewHiddenYES(view);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenNO(UIView *view) {
        CZ_SetUIViewHiddenNO(view);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenYES(CALayer *layer) {
        CZ_SetCALayerHiddenYES(layer);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenNO(CALayer *layer) {
        CZ_SetCALayerHiddenNO(layer);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenYES(QQProgressData *layer) {
        CZ_SetQQProgressHiddenYES(layer);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetHiddenNO(QQProgressData *layer) {
        CZ_SetQQProgressHiddenNO(layer);
    }
    
    void CZ_SetUIViewBackgroundColor(UIView *view, UIColor *color);
    void CZ_SetCALayerBackgroundColor(CALayer *layer, CGColorRef color);
    
    static inline void __attribute__((overloadable)) CZ_SetBackgroundColor(UIView *view, UIColor *color) {
        CZ_SetUIViewBackgroundColor(view, color);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetBackgroundColor(CALayer *layer, CGColorRef color) {
        CZ_SetCALayerBackgroundColor(layer, color);
    }
    
    void CZ_SetUIViewClearBackgroundColor(UIView *view);
    void CZ_SetCALayerClearBackgroundColor(CALayer *layer);
    static inline void __attribute__((overloadable)) CZ_SetClearBackgroundColor(UIView *view) {
        CZ_SetUIViewClearBackgroundColor(view);
    }
    
    static inline void __attribute__((overloadable)) CZ_SetClearBackgroundColor(CALayer *layer) {
        CZ_SetCALayerClearBackgroundColor(layer);
    }
    
#define RGBACOLOR(r, g, b, a) CZ_UIColorARGB(((int)(a*255)<<24)|((int)(r)<<16)|((int)(g)<<8)|((int)(b)))
#define RGBCOLOR(r, g, b) CZ_UIColorRGB(((int)(r)<<16)|((int)(g)<<8)|((int)(b)))
#define RGBColorC CZ_UIColorRGB
    
#define    CZ_RELEASE_AND_CLEAR(object)  [object release]; object = nil
    NSString *CZ_NSString_stringWithFormat_c(const char *cformat, ...);
    NSString *CZ_NSString_stringWithFormat(NSString *format, ...);
    BOOL CZ_KindOfClass(__kindof id obj, Class cls);
    const char *CZ_GetUTF8String(NSString *str);
    char *CZ_getDescription(NSObject *obj);
    id CZ_Autorelease(id obj);
    NSUInteger CZ_ContainierCount(__kindof NSObject *containier);
    NSMutableArray *CZ_GetMutableArray(void);
    NSMutableDictionary *CZ_GetMutableDictionary(void);
    NSMutableArray *CZ_MutableArrayWithCapacity(NSUInteger capacity);
    void CZ_ContainerRemoveAllObjects(__kindof NSObject *containier);
    void CZ_ButtonSetTitleForState(UIButton *btn, NSString *title, UIControlState state);
    
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(char value) {
        return CZ_NSNumber_numberWithChar(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(unsigned char value) {
        return CZ_NSNumber_numberWithUnsignedChar(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(short value) {
        return CZ_NSNumber_numberWithShort(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(unsigned short value) {
        return CZ_NSNumber_numberWithUnsignedShort(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(int value) {
        return CZ_NSNumber_numberWithInt(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(unsigned int value) {
        return CZ_NSNumber_numberWithUnsignedInt(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(long value) {
        return CZ_NSNumber_numberWithLong(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(unsigned long value) {
        return CZ_NSNumber_numberWithUnsignedLong(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(long long value) {
        return CZ_NSNumber_numberWithLongLong(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(unsigned long long value) {
        return CZ_NSNumber_numberWithUnsignedLongLong(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(float value) {
        return CZ_NSNumber_numberWithFloat(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(double value) {
        return CZ_NSNumber_numberWithDouble(value);
    }
    static inline __attribute__((overloadable)) NSNumber *CZ_NSNumber(BOOL value) {
        return CZ_NSNumber_numberWithBool(value);
    }
    
    void CZ_dispatch_global(dispatch_block_t block);
    void CZ_dispatch_global_priority(dispatch_block_t block, int16_t priority);
    void CZ_dispatch_main(dispatch_block_t block);
    
    NSString *CZ_UTF8String(const char * utf8string);
    
    NSDate *CZ_NSDateNow(void);
    CGSize CZ_MainScreenSize(void);
    UIScreen *CZ_MainScreen(void);
    
#define CZ_RELEASE(x) CZ_Release(x)
    void CZ_Release(id __attribute__((ns_consumed)) releaseObject);
    
    BOOL CZ_isKindOfClass(NSObject * obj,Class cls);
    BOOL CZ_kindOfClsName(NSObject *obj, NSString *clsName);
    
#ifdef __cplusplus
}
#endif

#pragma mark - Cocoa Zipper

OBJC_EXPORT UIColor *kCZUIRedColor;
OBJC_EXPORT UIColor *kCZUIGrayColor;
OBJC_EXPORT UIColor *kCZUIBlackColor;
OBJC_EXPORT UIColor *kCZUIWhiteColor;
OBJC_EXPORT UIColor *kCZUIClearColor;
OBJC_EXPORT NSFileManager *kCZDefaultFileManager;
OBJC_EXPORT UIApplication *kCZUIApplication;
//@class QQBlueNotificationMonitor;
//OBJC_EXPORT QQBlueNotificationMonitor *kCZNSNotification;
OBJC_EXPORT NSNotificationCenter *kCZNSNotification;

#pragma mark -

@interface UIView (CodeZipper)
@property(nonatomic, assign, readonly) CGSize CZ_B_Size;
@property (nonatomic, assign) CGFloat CZ_F_OriginX;
@property (nonatomic, assign) CGFloat CZ_F_OriginY;
@property (nonatomic, assign) CGFloat CZ_F_SizeW;
@property (nonatomic, assign) CGFloat CZ_F_SizeH;
@property (nonatomic, assign) CGFloat CZ_B_OriginX;
@property (nonatomic, assign) CGFloat CZ_B_OriginY;
@property (nonatomic, assign) CGFloat CZ_B_SizeW;
@property (nonatomic, assign) CGFloat CZ_B_SizeH;

@property (nonatomic, assign) BOOL layerMasksToBounds;
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, strong) id layerContents;
@property (nonatomic, assign) CGFloat layerBorderWidth;
@property (nonatomic, assign) CGColorRef layerBorderColor;

+ (instancetype)newWithFrame:(CGRect)frame;

@end

@interface CALayer (CodeZipper)
@property (nonatomic, assign) CGFloat CZ_F_OriginX;
@property (nonatomic, assign) CGFloat CZ_F_OriginY;
@property (nonatomic, assign) CGFloat CZ_F_SizeW;
@property (nonatomic, assign) CGFloat CZ_F_SizeH;
@property (nonatomic, assign) CGFloat CZ_B_OriginX;
@property (nonatomic, assign) CGFloat CZ_B_OriginY;
@property (nonatomic, assign) CGFloat CZ_B_SizeW;
@property (nonatomic, assign) CGFloat CZ_B_SizeH;
@end

@interface UIScreen (CodeZipper)
@property (nonatomic, assign) CGFloat CZ_B_OriginX;
@property (nonatomic, assign) CGFloat CZ_B_OriginY;
@property (nonatomic, assign) CGFloat CZ_B_SizeW;
@property (nonatomic, assign) CGFloat CZ_B_SizeH;
@end

@interface UINavigationController (CodeZipper)

-(void)pushViewControllerAnimated:(UIViewController *)viewController;

@end

@interface UIViewController (CodeZipper)

- (void)presentViewControllerAnimated:(UIViewController *)viewController;

- (NSArray *)cz_popToRootViewControllerAnimated:(BOOL)animated;
- (UIViewController *)cz_popViewControllerAnimated:(BOOL)animated;
- (void)cz_dismissViewControllerAnimated:(BOOL)animated;
- (NSArray *)cz_popToViewController:(UIViewController*)viewController animated:(BOOL)animated;
- (void)cz_pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
- (void)cz_pushViewControllerAnimated:(UIViewController*)viewController;
- (void)cz_dismissViewControllerAnimatedBySelf:(BOOL)animated;

- (void)cz_addSubview:(UIView*)view;


@end

@interface NSDictionary (CodeZipper)

- (int)intForKey:(id)key;

@end

OBJC_EXTERN id QZNthObject(NSArray *array, NSUInteger index);
OBJC_EXTERN id QZFirstObject(NSArray *array);
OBJC_EXTERN id QZObjectForKey(NSDictionary *dictionary, id<NSCopying> key);
OBJC_EXTERN NSInteger QZNSStringIntegerValue(NSString *string);
OBJC_EXTERN NSInteger QZNSNumberIntegerValue(NSNumber *number);
OBJC_EXTERN NSInteger QZIDIntegerValue(id obj);

OBJC_EXTERN BOOL QZNSStringBoolValue(NSString *string);
OBJC_EXTERN BOOL QZNSNumberBoolValue(NSNumber *number);
OBJC_EXTERN BOOL QZIDBoolValue(id obj);

OBJC_EXTERN float QZNSStringFloatValue(NSString *string);
OBJC_EXTERN float QZNSNumberFloatValue(NSNumber *number);
OBJC_EXTERN float QZIDFloatValue(id obj);

static inline NSInteger __attribute__((overloadable)) QZIntegerValue(NSString *string) {
    return QZNSStringIntegerValue(string);
}

static inline NSInteger __attribute__((overloadable)) QZIntegerValue(NSNumber *number) {
    return QZNSNumberIntegerValue(number);
}

static inline NSInteger __attribute__((overloadable)) QZIntegerValue(id obj) {
    return QZIDIntegerValue(obj);
}

static inline BOOL __attribute__((overloadable)) QZBoolValue(NSString *string) {
    return QZNSStringBoolValue(string);
}

static inline BOOL __attribute__((overloadable)) QZBoolValue(NSNumber *number) {
    return QZNSNumberBoolValue(number);
}

static inline BOOL __attribute__((overloadable)) QZBoolValue(id obj) {
    return QZIDBoolValue(obj);
}

static inline float __attribute__((overloadable)) QZFloatValue(NSString *string) {
    return QZNSStringFloatValue(string);
}

static inline float __attribute__((overloadable)) QZFloatValue(NSNumber *number) {
    return QZNSNumberFloatValue(number);
}

static inline float __attribute__((overloadable)) QZFloatValue(id obj) {
    return QZIDFloatValue(obj);
}

OBJC_EXTERN void QZSetObjectForKey(NSMutableDictionary *dictionary, id object, const char *key);
OBJC_EXTERN void QZSetObjectForObjKey(NSMutableDictionary *dictionary, id object, id<NSCopying> key);
OBJC_EXTERN void QZSetDelegate(NSObject *target, id delegate);
OBJC_EXTERN BOOL QZISIPhoneX(void);
