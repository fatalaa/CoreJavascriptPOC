//
// Created by Tibor Molnár on 2017. 04. 27..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDExpressionValueInjector.h"

@implementation INDExpressionValueInjector

- (void)injectValues:(NSDictionary<NSString *, id> *)values intoExpression:(NSMutableString *)rawExpression
{
    [values enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            [rawExpression replaceOccurrencesOfString:key withString:[NSString stringWithFormat:@"\"%@\"", obj] options:NSCaseInsensitiveSearch range:NSMakeRange(0, rawExpression.length)];
        }
        else
        {
            [rawExpression replaceOccurrencesOfString:key withString:obj options:NSCaseInsensitiveSearch range:NSMakeRange(0, rawExpression.length)];
        }
    }];
}

@end