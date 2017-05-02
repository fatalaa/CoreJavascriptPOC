//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDExpressionEvaluator.h"
#import "INDJSContext.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface INDExpressionEvaluator ()

@property (strong, nonatomic) id<INDJSContext> javascriptContext;

@end

@implementation INDExpressionEvaluator

- (instancetype)initWithJavascriptContext:(id <INDJSContext>)context
{
    if (self = [super init])
    {
        _javascriptContext = context;
    }
    return self;
}

- (BOOL)evaluateBoolForExpression:(NSString *)expression
{
    JSValue *returnValue = [self.javascriptContext evalueExpression:expression];
    if ([returnValue isUndefined] || [returnValue isNull])
    {
        return NO;
    }
    return [returnValue toBool];
}


@end