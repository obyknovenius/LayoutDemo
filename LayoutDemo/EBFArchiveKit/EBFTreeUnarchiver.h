//
//  EBFTreeUnarchiver.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 08/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EBFTreeCoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface EBFTreeUnarchiver : NSObject

//+ (nullable id)unarchiveObjectWithData:(NSData *)data;
//+ (nullable id)unarchiveTopLevelObjectWithData:(NSData *)data error:(NSError **)error;
//+ (nullable id)unarchiveObjectWithFile:(NSString *)path;

- (instancetype)initForReadingWithData:(NSData *)data;

//+ (void)setClass:(nullable Class)cls forClassName:(NSString *)codedName;
- (void)setClass:(nullable Class)cls forClassName:(NSString *)codedName;

//+ (nullable Class)classForClassName:(NSString *)codedName;
- (nullable Class)classForClassName:(NSString *)codedName;

- (nullable id)unarchiveRootObject;
- (nullable id)unarchiveRootObjectWithParentObject:(nullable id)parentObject;

- (nullable id)decodeObjectForKey:(NSString *)key parentObject:(id)parentObject;
- (nullable NSArray *)decodeObjectsForKey:(NSString *)key parentObject:(id)parentObject;

- (NSString *)decodeStringForKey:(NSString *)key;
- (NSNumber *)decodeNumberForKey:(NSString *)key;

- (NSInteger)decodeIntegerForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END