//
//  EBFWidgetView.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EBFArchiveKit.h"

#import "EBFViewUnarchiver.h"

#import "EBFLayoutParameters.h"

@protocol EBFWidgetView <EBFTreeCoding>

@property (nonatomic, readonly) EBFLayoutParameters *layoutParameters;

@end
