//http://km.oa.com/articles/show/143237
//produce-consumer-machine,不支持函数重入!

#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSDictionary.h>
#import "IFalcoComponent.h"

typedef void(^pfnConsumer)(id product);
typedef void(^pfnProduceCallback)(id result);
typedef void(^pfnProducer)(pfnProduceCallback callback);

@protocol IFalcoPCM <IFalcoObject>
@required
-(void)initWith:(pfnProducer)producer;
-(void)doComsume:(pfnConsumer)consumer;
-(void)reset;
@end

