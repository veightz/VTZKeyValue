//
//  ActionManager.h
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/22/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTZPasteboardUnit.h"

#define SharedActionManager [ActionManager sharedManager]

//@class VTZPasteboardBuilder;

typedef void(^VTZPasteboardUnitBuildBlock)(VTZPasteboardUnit *unit);

@interface ActionManager : NSObject

+ (instancetype)sharedManager;

- (void)write:(VTZPasteboardUnitBuildBlock)block;

@end
