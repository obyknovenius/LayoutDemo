//
//  EBFAbsoluteLayoutParameters.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFAbsoluteLayoutParameters.h"

#import "EBFViewUnarchiver.h"

@interface EBFAbsoluteLayoutParameters ()

@property (nonatomic, readwrite) NSInteger x;
@property (nonatomic, readwrite) NSInteger y;

@end

@implementation EBFAbsoluteLayoutParameters

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSInteger x = [aDecoder decodeIntegerForKey:@"x"];
        if (x != NSNotFound) {
            _x = x;
        }
        
        NSInteger y = [aDecoder decodeIntegerForKey:@"y"];
        if (y != NSNotFound) {
            _y = y;
        }
    }
    return self;
}

@end
