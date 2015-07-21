//
//  DataManager.m
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/21/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "DataManager.h"
#import <AVOSCloud.h>

static NSString * const kKeyValueMapClassName = @"KeyValueMap";
static NSString * const KEY = @"key";
static NSString * const VALUE = @"value";

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DataManager new];
    });
    return sharedInstance;
}

- (void)fetchMappingValueForKey:(NSString *)keyString completion:(VTZFetchOneResultBlock)block {
//    NSAssert(keyString.length > 0, @"R u kidding me?");
    AVQuery *query = [AVQuery queryWithClassName:kKeyValueMapClassName];
    [query whereKey:@"key" equalTo:keyString];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        !block ?: block(object, error);
    }];
}

- (void)setMappingValue:(NSString *)valueString forKey:(NSString *)keyString completion:(VTZSaveBlock)block {
//    NSAssert(keyString.length > 0, @"R u kidding me?");
//    NSAssert(valueString.length > 0, @"naive");
    if (!(keyString.length)) {
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The keyString is invalid", nil),
                                   };
        error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:1 userInfo:userInfo];
        !block ?: block(NO, error);
    }
    if (!(valueString.length)) {
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The valueString is invalid", nil),
                                   };
        error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:1 userInfo:userInfo];
        !block ?: block(NO, error);
    }
    AVQuery *query = [AVQuery queryWithClassName:kKeyValueMapClassName];
    [query whereKey:KEY equalTo:keyString];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (object) {
            object[VALUE] = valueString;
        } else {
            object = [AVObject objectWithClassName:kKeyValueMapClassName];
            object[KEY] = keyString;
            object[VALUE] = valueString;
        }
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            !block ?: block(succeeded, error);
        }];
    }];
    
}

- (void)setMappingValue:(NSString *)valueString forObjectId:(NSString *)objectId completion:(VTZSaveBlock)block {
    if (!(objectId.length)) {
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The objectId is invalid", nil),
                                   };
        error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:1 userInfo:userInfo];
        !block ?: block(NO, error);
    }
    if (!(valueString.length)) {
        NSError *error = nil;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The valueString is invalid", nil),
                                   };
        error = [NSError errorWithDomain:NSStringFromSelector(_cmd) code:1 userInfo:userInfo];
        !block ?: block(NO, error);
    }
    AVObject *object = [AVObject objectWithoutDataWithClassName:kKeyValueMapClassName objectId:objectId];
    object[VALUE] = valueString;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        !block ?: block(succeeded, error);
    }];
}


@end
