//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDEvaluationModelHandling.h"

#import <Foundation/Foundation.h>

@protocol INDExpressionEvaluating;
@protocol INDExpressionValueInjection;
@protocol INDKeyPathParsing;

@interface INDDefaultEvaluationModelHandler : NSObject <INDEvaluationModelHandling>

- (instancetype)initWithExpressionEvaluator:(id<INDExpressionEvaluating>)evaluator keyPathParser:(id<INDKeyPathParsing>)keyPathParser valueInjector:(id<INDExpressionValueInjection>)valueInjector;

@end
