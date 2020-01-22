//
//  EBFLinearLayoutView.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 17/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFLinearLayoutView.h"

#import "EBFAbsoluteLayoutParameters.h"

@interface EBFTreeUnarchiver (EBFLinearLayout)

- (EBFLinearLayoutOrientation)decodeOrientationForKey:(NSString *)key;

@end

@interface EBFLinearLayoutView ()

@property (nonatomic, readwrite) EBFLayoutParameters *layoutParameters;
@property (nonatomic, copy) NSArray *widgets;

@end

@implementation EBFLinearLayoutView

- (nullable instancetype)initWithCoder:(EBFTreeUnarchiver *)aDecoder parentObject:(id)parentObject {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _orientation = [aDecoder decodeOrientationForKey:@"orientation"];
        
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
    UIView *previousWidget = nil;
    for (UIView <EBFWidgetView> *widget in self.widgets) {
        [self addSubview:widget nextToSubview:previousWidget withLayoutParameters:widget.layoutParameters];
        previousWidget = widget;
    }
}

- (EBFLayoutParameters *)createLayoutParametersWithCoder:(EBFTreeUnarchiver *)aDecoder {
    return [[EBFLayoutParameters alloc] initWithCoder:aDecoder];
}

- (void)addSubview:(UIView *)view nextToSubview:(UIView *)previousSubview withLayoutParameters:(EBFLayoutParameters *)parameters{
    [super addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!previousSubview) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0f constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f constant:0]];
    } else {
        if (self.orientation == EBFLinearLayoutOrientationVertical) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeLeading
                                                            multiplier:1.0f constant:0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previousSubview attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:0]];
        } else if (self.orientation == EBFLinearLayoutOrientationHorizontal) {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:previousSubview attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0f constant:0]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeTop
                                                            multiplier:1.0f constant:0]];
        }
    }
    
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
        CGSize widgetIntrinsicContentSize = [widget intrinsicContentSize];
        
        if (self.orientation == EBFLinearLayoutOrientationVertical) {
            intrinsicContentSize.height += widgetIntrinsicContentSize.height;
            intrinsicContentSize.width = MAX(intrinsicContentSize.width, widgetIntrinsicContentSize.width);
        } else {
            intrinsicContentSize.width += widgetIntrinsicContentSize.width;
            intrinsicContentSize.height = MAX(intrinsicContentSize.height, widgetIntrinsicContentSize.height);
        }
    }
    
    return intrinsicContentSize;
}

@end

@implementation EBFTreeUnarchiver (EBFLinearLayout)

- (EBFLinearLayoutOrientation)decodeOrientationForKey:(NSString *)key {
    NSString *orientationString = [self decodeStringForKey:key];
    if (orientationString) {
        if ([orientationString isEqualToString:@"vertical"]) {
            return EBFLinearLayoutOrientationVertical;
        }
    }
    
    return EBFLinearLayoutOrientationHorizontal;
}

@end
