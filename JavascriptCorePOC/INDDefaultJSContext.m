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
@property (nonatomic, strong) JSContext *javascriptContext;

@end

@implementation INDDefaultJSContext

- (instancetype)init
{
    if (self = [super init])
    {
        _variables = [NSMutableArray array];
        _javascriptContext = [JSContext new];
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
    // TODO register stored functions as well
    JSValue *value = [self.javascriptContext evaluateScript:functionBody];
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

@end
