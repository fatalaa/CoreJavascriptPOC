//
//  INDDefaultJSContext.m
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 10..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "INDDefaultJSContext.h"
#import "INDJSTypeDescriptor.h"

@import JavaScriptCore;

@interface INDDefaultJSContext ()

@property (nonatomic, strong) NSMutableArray<INDJSTypeDescriptor *> *variables;
@property (nonatomic, strong) NSMutableArray<NSString *> *functions;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *expressions;
@property (nonatomic, strong) JSContext *javascriptContext;

@end

@implementation INDDefaultJSContext

- (instancetype)init
{
    if (self = [super init])
    {
        _variables = [NSMutableArray array];
        _functions = [NSMutableArray array];
        _expressions = [NSMutableDictionary dictionary];
        _javascriptContext = [JSContext new];
        NSString *evalScript = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"evaluator" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
        _javascriptContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"%@", exception);
        };
        [_javascriptContext evaluateScript:evalScript];
    }
    return self;
}

- (void)addStringWithName:(NSString *)variableName value:(NSString *)value
{
    INDJSTypeDescriptor *descriptor = [INDJSTypeDescriptor descriptorWithName:variableName type:INDJSTypeString value:value];
    if (![self.variables containsObject:descriptor])
    {
        [self.variables addObject:descriptor];
        [self.javascriptContext evaluateScript:[NSString stringWithFormat:@"%@ %@ = \"%@\";", @"var ", variableName, value]];
    }
}

- (void)addBoolWithName:(NSString *)variableName value:(NSNumber *)value
{
    INDJSTypeDescriptor *descriptor = [INDJSTypeDescriptor descriptorWithName:variableName type:INDJSTypeBool value:value];
    if (![self.variables containsObject:descriptor])
    {
        [self.variables addObject:descriptor];
        [self.javascriptContext evaluateScript:[NSString stringWithFormat:@"%@ %@ = %@;", @"var ", variableName, value]];
    }
}

- (void)addIntegerWithName:(NSString *)variableName value:(NSNumber *)value
{
    INDJSTypeDescriptor *descriptor = [INDJSTypeDescriptor descriptorWithName:variableName type:INDJSTypeInteger value:value];
    if (![self.variables containsObject:descriptor])
    {
        [self.variables addObject:descriptor];
        [self.javascriptContext evaluateScript:[NSString stringWithFormat:@"%@ %@ = %@;", @"var ", variableName, value]];
    }
}

- (void)addDoubleWithName:(NSString *)variableName value:(NSNumber *)value
{
    INDJSTypeDescriptor *descriptor = [INDJSTypeDescriptor descriptorWithName:variableName type:INDJSTypeDouble value:value];
    if (![self.variables containsObject:descriptor])
    {
        [self.variables addObject:descriptor];
        [self.javascriptContext evaluateScript:[NSString stringWithFormat:@"%@ %@ = %@;", @"var ", variableName, value]];
    }
}

- (void)addFunctionWithName:(NSString *)name functionBody:(NSString *)functionBody
{
    [self.functions addObject:name];
    [self.javascriptContext evaluateScript:functionBody];
}

- (void)addExpressionWithName:(NSString *)name expressionBody:(NSString *)expressionBody
{
    if (!self.expressions[name])
    {
        self.expressions[name] = expressionBody;
    }
}

- (NSDictionary<NSString *, INDJSTypeDescriptor *> *)allVariables
{
    NSMutableDictionary<NSString *, INDJSTypeDescriptor *> *variables = [NSMutableDictionary dictionary];
    [self.variables enumerateObjectsUsingBlock:^(INDJSTypeDescriptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JSValue *currentValue = self.javascriptContext[obj.variableName];
        if (![currentValue isNull] && ![currentValue isUndefined])
        {
            variables[obj.variableName] = [INDJSTypeDescriptor descriptorWithName:obj.variableName type:obj.type value:[currentValue toString]];
        }
    }];
    return [variables copy];
}

- (NSArray<NSString *> *)functionNames
{
    return [self.functions copy];
}

- (void)embedObject:(id)obj
{
    JSValue *value = [JSValue valueWithObject:obj inContext:self.javascriptContext];
    NSLog(@"%@", [value toObject]);
}

- (JSValue *)evalueExpression:(NSString *)expression
{
    return [self.javascriptContext evaluateScript:expression];
}


@end
