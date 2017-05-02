//
// Created by Tibor Molnár on 2017. 04. 27..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDKeyPathParser.h"

static NSString * const KeyPathMatcherRegExString = @"([a-zA-Z0-9_.]{1,}(.)[a-zA-Z0-9_.]{1,})";

@implementation INDKeyPathParser

- (NSArray<NSString *> *)parseExpression:(NSString *)expression
{
    NSMutableArray<NSString *> *keyPaths = [NSMutableArray array];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:KeyPathMatcherRegExString options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:expression options:NSMatchingReportCompletion range:NSMakeRange(0, expression.length)];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        NSString *keyPath = [expression substringWithRange:obj.range];
        [keyPaths addObject:keyPath];
    }];
    return keyPaths;
}

@end