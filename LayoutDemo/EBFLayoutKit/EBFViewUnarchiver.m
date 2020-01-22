//
//  EBFViewUnarchiver.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFViewUnarchiver.h"

#import "EBFAbsoluteLayoutView.h"
#import "EBFLinearLayoutView.h"

#import "EBFLabel.h"

#import "UIColor+NSString.h"

@implementation EBFViewUnarchiver

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super initForReadingWithData:data];
    if (self) {
        [self setClass:[EBFAbsoluteLayoutView class] forClassName:@"absoluteLayout"];
        [self setClass:[EBFLinearLayoutView class] forClassName:@"linearLayout"];
        
        [self setClass:[EBFLabel class] forClassName:@"label"];
    }
    return self;
}

@end

@implementation EBFTreeUnarchiver (UIView)

- (UIColor *)decodeColorForKey:(NSString *)key {
    NSString *colorString = [self decodeStringForKey:key];
    if (colorString) {
        return [UIColor colorWithString:colorString];
    }
    return nil;
}

@end

