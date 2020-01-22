//
//  EBFLayoutParameters.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 03/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFLayoutParameters.h"

#import "EBFViewUnarchiver.h"

NS_ASSUME_NONNULL_BEGIN

@interface EBFTreeUnarchiver (LayoutParameters)

- (NSInteger)decodeDimensionForKey:(NSString *)key;

@end

@implementation EBFLayoutParameters

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder {
    self = [super init];
    if (self) {
        NSInteger width = [aDecoder decodeDimensionForKey:@"width"];
        if (width != NSNotFound) {
            _width = width;
        }
        
        NSInteger height = [aDecoder decodeDimensionForKey:@"height"];
        if (height != NSNotFound) {
            _height = height;
        }
    }
    return self;
}

@end

@implementation EBFTreeUnarchiver (EBFLayoutParameters)

- (NSInteger)decodeDimensionForKey:(NSString *)key {
    NSString *dimensionString = [self decodeStringForKey:key];
    if (dimensionString) {
        if ([dimensionString isEqualToString:@"fill"]) {
            return EBFLayoutDimensionFill;
        } else if ([dimensionString isEqualToString:@"auto"]) {
            return EBFLayoutDimensionAuto;
        } else {
            return NSNotFound;
        }
    }
    
    return [self decodeIntegerForKey:key];
}

@end

NS_ASSUME_NONNULL_END