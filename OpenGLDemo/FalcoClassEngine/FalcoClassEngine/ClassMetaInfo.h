#import <Foundation/Foundation.h>
#import "IFalcoComponent.h"

@interface FalcoObjectInfo : NSObject
@property(retain, nonatomic) NSString* name;  //接口name
@property(retain, nonatomic) NSString* comid; //组件名
@property(retain, nonatomic) NSString* clsid; //类名
@property(retain, nonatomic) NSString* iid;   //接口guid
@property(retain, nonatomic) NSString* type;  //service or object
@property(retain, nonatomic) Class clsClass;
@end

@interface FalcoServiceinfo : FalcoObjectInfo
@property(retain, nonatomic) id<IFalcoObject> service;  //service对象
@end
