//
//  EBFLayoutParameters.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 03/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    EBFLayoutDimensionFill = -1,
    EBFLayoutDimensionAuto = -2,
};

@class EBFTreeUnarchiver;

NS_ASSUME_NONNULL_BEGIN

@interface EBFLayoutParameters : NSObject

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder;

@end

NS_ASSUME_NONNULL_END