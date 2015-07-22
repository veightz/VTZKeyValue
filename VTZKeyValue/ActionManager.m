//
//  ActionManager.m
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/22/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

@import UIKit;

#import "ActionManager.h"
//#import "VTZPasteBoardBuilder.h"

@implementation ActionManager

+ (instancetype)sharedManager {
    static ActionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ActionManager new];
    });
    return sharedInstance;
}

- (void)write:(VTZPasteboardUnitBuildBlock)block {
    VTZPasteboardUnit *unit = [VTZPasteboardUnit new];
    NSAssert(block, @"VTZPasteBoardBuilderBlock instance should not be nil.");
    // configure builder
    block(unit);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (unit.string.length) {
        [pasteboard setString:unit.string];
    }
//    if ([builder.pasteboardName isEqualToString:UIPasteboardNameGeneral]) {
//        pasteboard setString:
//    } else if ([builder.pasteboardName isEqualToString:UIPasteboardNameFind]) {
//        
//    } else {
//        
//    }
    
}

@end
