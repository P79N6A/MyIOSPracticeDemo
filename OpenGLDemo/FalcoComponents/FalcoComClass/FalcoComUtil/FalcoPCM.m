#import "FalcoPCM.h"

typedef NS_ENUM(NSInteger, FalcoPCMState){
    PCM_STATE_UNINIT  = 1,  //未初始化状态
    PCM_STATE_INIT    ,     //初始化状态
    PCM_STATE_DOING   ,     //异步请求中
    PCM_STATE_END     ,     //异步请求结束
};

typedef id  (^pfnFalcoPCM)(pfnProducer producer);
typedef void(^pfnOneVariableFun)(pfnConsumer consumer);

@interface FalcoPCM()
@property (nonatomic, copy)  pfnFalcoPCM pcm;
@property (nonatomic, copy)  pfnOneVariableFun consumerFun;
@property (nonatomic, assign)  FalcoPCMState state;
@end

@implementation FalcoPCM
-(instancetype)init
{
    if (self = [super init]) {
        self.state = PCM_STATE_UNINIT;
        __weak typeof (self) weak_self = self;
        self.pcm =  (id)^(pfnProducer producer){
            weak_self.state = PCM_STATE_INIT;
            __block id product;
            __block NSMutableArray* cached_consumer = [[NSMutableArray alloc]init];
            return ^(pfnConsumer consumer){
                if (weak_self.state == PCM_STATE_END) {
                    NSLog(@"applechangpcm product=%@, exist", product);
                    consumer(product);
                }else{
                    NSLog(@"applechangpcm product=%@, doesn't exist", product);
                    if (consumer) {
                        [cached_consumer addObject:consumer];
                    }
                    
                    if (PCM_STATE_DOING != weak_self.state) {
                        weak_self.state = PCM_STATE_DOING;
                        producer(^(id result){
                            product = result;
                            weak_self.state = PCM_STATE_END;
                            NSLog(@"applechangpcm state=%ld", (long)weak_self.state);
                            if (cached_consumer){
                                for (pfnConsumer consumer in cached_consumer) {
                                    consumer(product);
                                }
                                [cached_consumer removeAllObjects];
                            }
                        });
                    }
                }
            };
        };
    }
    
    return self;
}

-(void)initWith:(pfnProducer)producer
{
    self.consumerFun = self.pcm(producer);
}

-(void)doComsume:(pfnConsumer)consumer
{
    if (self.consumerFun) {
        self.consumerFun(consumer);
    }
}

-(void)reset
{
    self.state = PCM_STATE_INIT;
}
@end
