//
//  EBFViewUnarchiver.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EBFArchiveKit.h"

@interface EBFViewUnarchiver : EBFJSONUnarchiver

@end

@interface EBFTreeUnarchiver (UIView)

- (UIColor *)decodeColorForKey:(NSString *)key;

@end