//
//  DataManager.h
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/21/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedDataManager [DataManager sharedManager]

typedef void(^VTZFetchOneResultBlock)(id object, NSError *error);
typedef void(^VTZSaveBlock)(BOOL succeeded, NSError *error);

@interface DataManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchMappingValueForKey:(NSString *)keyString completion:(VTZFetchOneResultBlock)block;

- (void)setMappingValue:(NSString *)valueString forKey:(NSString *)keyString completion:(VTZSaveBlock)block;

- (void)setMappingValue:(NSString *)valueString forObjectId:(NSString *)objectId completion:(VTZSaveBlock)block;

@end
