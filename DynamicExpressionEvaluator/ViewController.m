//
//  ViewController.m
//  DynamicExpressionEvaluator
//
//  Created by Tibor Molnár on 2017. 04. 18..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "ViewController.h"

static NSString * const KeyPathMatcherRegExString = @"([a-zA-Z0-9_.]{1,}(.)[a-zA-Z0-9_.]{1,})";

@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dynamicExpression = @"${form1.section1.some.property === 'a' && form1.section2.another.property === 'b'}";
    NSMutableArray<NSString *> *variables = [NSMutableArray array];
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:KeyPathMatcherRegExString options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *results = [expression matchesInString:dynamicExpression options:NSMatchingReportCompletion range:NSMakeRange(0, dynamicExpression.length)];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        [variables addObject:[dynamicExpression substringWithRange:obj.range]];
    }];
    NSLog(@"%@", variables);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
