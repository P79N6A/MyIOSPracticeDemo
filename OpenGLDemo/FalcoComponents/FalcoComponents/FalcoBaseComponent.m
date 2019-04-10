//
//  FalcoBaseComponent.m
//  FalcoComponents
//
//  Created by Carly 黄 on 2019/1/8.
//  Copyright © 2019年 Carly 黄. All rights reserved.
//

#import "FalcoBaseComponent.h"
#import "FalcoBlock.h"
#import "FalcoPCM.h"
#import "FalcoObserver.h"
#import "HPGrowingTextView2.h"

@implementation FalcoBaseComponent
    BEGIN_COM_MAP()
        COM_INTERFACE_ENTRY(IFalcoBlock, FalcoBlock)
        COM_INTERFACE_ENTRY(IFalcoResult, FalcoResult)
        COM_INTERFACE_ENTRY(IFalcoPCM, FalcoPCM)
        COM_INTERFACE_ENTRY(IFalcoObserver, FalcoObserver)
        COM_INTERFACE_ENTRY(IFalcoGrowingTextView, HPGrowingTextView2)
    END_COM_MAP()

    // BEGIN_COMCLASS_MAP()
    // 只提供类方法接口实现的（只有 +方法的接口）在此声明， COMCLASS_INTERFACE_ENTRY(interface,className)
    // END_COMCLASS_MAP()
@end
