//
//  UIColor+NSString.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 02/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "UIColor+NSString.h"

@implementation UIColor (NSString)

+ (UIColor *)colorWithString:(NSString *)string {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
