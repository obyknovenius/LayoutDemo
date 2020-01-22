//
//  EBFLabel.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 07/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFLabel.h"

#import "EBFLayoutView.h"

@interface EBFLabel ()

@property (nonatomic) NSInteger leftPadding;
@property (nonatomic) NSInteger rightPadding;
@property (nonatomic) NSInteger topPadding;
@property (nonatomic) NSInteger bottomPadding;

@property (nonatomic, readwrite) EBFLayoutParameters *layoutParameters;

@end

@implementation EBFLabel

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.numberOfLines = 0;
        
        self.text = [aDecoder decodeStringForKey:@"text"];
        
        UIColor *backgroundColor = [aDecoder decodeColorForKey:@"backgroundColor"];
        if (backgroundColor) {
            self.backgroundColor = backgroundColor;
        }
        
        UIColor *textColor = [aDecoder decodeColorForKey:@"textColor"];
        if (textColor) {
            self.textColor = textColor;
        }
        
        NSInteger padding = [aDecoder decodeIntegerForKey:@"padding"];
        if (padding != NSNotFound) {
            self.leftPadding = padding;
            self.rightPadding = padding;
            self.topPadding = padding;
            self.bottomPadding = padding;
        }
        
        if ([parentObject conformsToProtocol:@protocol(EBFLayoutView)]) {
            id <EBFLayoutView> layoutView = parentObject;
            _layoutParameters = [layoutView createLayoutParametersWithCoder:aDecoder];
        }
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topPadding, self.leftPadding, self.bottomPadding, self.rightPadding);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)intrinsicContentSize {
    CGSize originalIntrinsicContentSize = [super intrinsicContentSize];
    return CGSizeMake(originalIntrinsicContentSize.width + self.leftPadding + self.rightPadding,
                      originalIntrinsicContentSize.height + self.topPadding + self.bottomPadding);
}

@end
