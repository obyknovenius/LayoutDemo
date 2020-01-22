//
//  EBFTreeCoding.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 08/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/NSObject.h>

@class EBFTreeUnarchiver;

NS_ASSUME_NONNULL_BEGIN

@protocol EBFTreeCoding <NSObject>

//- (void)encodeWithCoder:(NSCoder *)aCoder; // Not implemented
- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject; // NS_DESIGNATED_INITIALIZER

@optional

- (void)awakeAfterUsingCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject;

@end

NS_ASSUME_NONNULL_END