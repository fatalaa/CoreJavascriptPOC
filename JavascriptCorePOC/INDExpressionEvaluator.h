//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDExpressionEvaluating.h"

#import <Foundation/Foundation.h>

@protocol INDJSContext;

@interface INDExpressionEvaluator : NSObject <INDExpressionEvaluating>

- (instancetype)initWithJavascriptContext:(id<INDJSContext>)context;

@end