//
//  EBFLayoutView.h
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EBFWidgetView.h"

@protocol EBFLayoutView <EBFWidgetView>

- (EBFLayoutParameters *)createLayoutParametersWithCoder:(EBFTreeUnarchiver *)aDecoder;
@end
