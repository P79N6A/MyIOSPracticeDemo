//
//  FalcoClassEngine.m
//  FalcoClassEngine
//
//  Created by applechang on 2018/11/22.
//  Copyright © 2018年 applechang. All rights reserved.
//

#import "FalcoClassEngine.h"
#import "FalcoObjectFactory.h"
#import "FalcoServiceCenter.h"
#import "FalcoComponentMgr.h"
#import "FalcoXMLDictionary.h"

@interface FalcoClassEngine()
{
    id<IFalcoObjectFactory> _objectFactory;
    id<IFalcoServiceCenter> _serviceFactory;
    id<IFalcoComponentMgr>  _componentMgr;
    BOOL _bInitSucc;
}
@end

@implementation FalcoClassEngine

-(instancetype)init
{
    if (self = [super init]) {
        _objectFactory  =[FalcoObjectFactory new];
        _serviceFactory =[FalcoSeviceCenter new];
        _componentMgr   =[FalcoComponentMgr new];
        _bInitSucc = NO;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static FalcoClassEngine *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[FalcoClassEngine alloc]init];
    });
    
    return sharedInstance;
}

-(id<IFalcoObjectFactory>)GetObjectFactory
{
    return _objectFactory;
}

-(id<IFalcoServiceCenter>)GetServiceFactory
{
    return _serviceFactory;
}

-(BOOL)setCoreConfigPath:(NSString*)cfgPath
{
    if (_bInitSucc == YES) {
        return YES;
    }
    
    NSDictionary<NSString *, id>* cfg = [NSDictionary dictionaryWithXMLFile:cfgPath];
    
    _bInitSucc =  [_serviceFactory AddPlatformConfig:cfg] &&
                  [_objectFactory  AddPlatformConfig:cfg] &&
    [_componentMgr  AddComponentConfig:cfg];

    [_objectFactory SetComponentMgr:_componentMgr];
    [_serviceFactory SetComponentMgr:_componentMgr];
    
    return _bInitSucc;
}
@end

id<IFalcoClassEngine> TXFalcoClassEngine()
{
    return [FalcoClassEngine sharedInstance];
}
