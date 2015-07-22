//
//  VTZPasteboardBuilder.h
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/22/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@interface VTZPasteboardUnit : NSObject

@property (strong, nonatomic, nonnull) NSString *pasteboardName;
@property (copy, nonatomic, nullable) NSString *string;

@end
