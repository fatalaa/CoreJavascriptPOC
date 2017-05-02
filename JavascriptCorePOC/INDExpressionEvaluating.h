//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INDExpressionEvaluating <NSObject>

- (BOOL)evaluateBoolForExpression:(NSString *)expression;

@end