//
//  ViewController.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 02/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "ViewController.h"

#import "EBFLayoutKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *layoutURL = [[NSBundle mainBundle] URLForResource:@"Layout" withExtension:@"json"];
    NSData *layoutData = [NSData dataWithContentsOfURL:layoutURL];
    EBFViewUnarchiver *viewUnarchiver = [[EBFViewUnarchiver alloc] initForReadingWithData:layoutData];
    
    UIView *view = [viewUnarchiver unarchiveRootObject];
    
    [self.view addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view": view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
}

@end
