//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDExpressionItem.h"


@implementation INDExpressionItem

- (BOOL)isExpression
{
    return [self.value hasPrefix:@"${"] && [self.value hasSuffix:@"}"];
}

@end