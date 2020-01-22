//
//  AbsoluteLayoutView.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 03/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFAbsoluteLayoutView.h"

#import "EBFAbsoluteLayoutParameters.h"

@interface EBFAbsoluteLayoutView ()

@property (nonatomic, readwrite) EBFLayoutParameters *layoutParameters;
@property (nonatomic, copy) NSArray *widgets;

@end

@implementation EBFAbsoluteLayoutView

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        UIColor *backgroundColor = [aDecoder decodeColorForKey:@"backgroundColor"];
        if (backgroundColor) {
            self.backgroundColor = backgroundColor;
        }
        
        _widgets = [aDecoder decodeObjectsForKey:@"subviews" parentObject:self];
        
        if ([parentObject conformsToProtocol:@protocol(EBFLayoutView)]) {
            id <EBFLayoutView> layoutView = parentObject;
            _layoutParameters = [layoutView createLayoutParametersWithCoder:aDecoder];
        }
    }
    return self;
}

- (void)awakeAfterUsingCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject {
    for (UIView <EBFWidgetView> *widget in self.widgets) {
        [self addSubview:widget withLayoutParameters:(EBFAbsoluteLayoutParameters *)widget.layoutParameters];
    }
}

- (EBFLayoutParameters *)createLayoutParametersWithCoder:(EBFTreeUnarchiver *)aDecoder {
    return [[EBFAbsoluteLayoutParameters alloc] initWithCoder:aDecoder];
}

- (void)addSubview:(UIView *)view withLayoutParameters:(EBFAbsoluteLayoutParameters *)parameters {
    [super addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0f constant:parameters.x]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f constant:parameters.y]];
    
    switch (parameters.width) {
        case EBFLayoutDimensionFill: {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f constant:0.0f]];
        } break;
            
        case EBFLayoutDimensionAuto: {
            [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        } break;
            
        default: {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:parameters.width]];
        } break;
    }
    
    switch (parameters.height) {
        case EBFLayoutDimensionFill: {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f constant:0.0f]];
        } break;
            
        case EBFLayoutDimensionAuto: {
            [view setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [view setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        } break;
            
        default: {
            [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                multiplier:1.0f constant:parameters.height]];
        } break;
    }
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicContentSize = CGSizeZero;
    
    for (UIView <EBFWidgetView> *widget in self.widgets) {
        EBFAbsoluteLayoutParameters *layoutParameters = (EBFAbsoluteLayoutParameters *)widget.layoutParameters;
        CGSize widgetIntrinsicContentSize = [widget intrinsicContentSize];
        
        CGFloat x = layoutParameters.x;
        CGFloat y = layoutParameters.y;
        CGFloat width = layoutParameters.width == EBFLayoutDimensionAuto ? widgetIntrinsicContentSize.width : layoutParameters.width;
        CGFloat height = layoutParameters.height == EBFLayoutDimensionAuto ? widgetIntrinsicContentSize.height : layoutParameters.height;
        
        CGRect widgetFrame = CGRectMake(x, y, width, height);
        
        intrinsicContentSize.height = MAX(intrinsicContentSize.height, CGRectGetMaxY(widgetFrame));
        intrinsicContentSize.width = MAX(intrinsicContentSize.width, CGRectGetMaxX(widgetFrame));
    }
    
    return intrinsicContentSize;
}

@end
