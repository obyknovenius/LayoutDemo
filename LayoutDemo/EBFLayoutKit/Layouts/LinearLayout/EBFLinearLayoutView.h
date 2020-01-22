//
//  EBFLinearLayoutView.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EBFLayoutView.h"

typedef NS_ENUM(NSUInteger, EBFLinearLayoutOrientation) {
    EBFLinearLayoutOrientationHorizontal,
    EBFLinearLayoutOrientationVertical,
};

@interface EBFLinearLayoutView : UIView <EBFLayoutView>

@property (nonatomic) EBFLinearLayoutOrientation orientation;

@end
