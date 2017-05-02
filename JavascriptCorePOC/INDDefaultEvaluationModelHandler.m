//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "EvaluationModel.h"
#import "INDDefaultEvaluationModelHandler.h"
#import "INDExpressionEvaluator.h"
#import "INDKeyPathParser.h"
#import "INDExpressionValueInjection.h"

@interface INDDefaultEvaluationModelHandler ()

@property (strong, nonatomic) id<INDKeyPathParsing> keyPathParser;
@property (strong, nonatomic) id<INDExpressionValueInjection> valueInjector;
@property (strong, nonatomic) id<INDExpressionEvaluating> evaluator;
@property (strong, nonatomic) EvaluationModel *model;

@end

@implementation INDDefaultEvaluationModelHandler

- (instancetype)initWithExpressionEvaluator:(id <INDExpressionEvaluating>)evaluator keyPathParser:(id <INDKeyPathParsing>)keyPathParser valueInjector:(id<INDExpressionValueInjection>)valueInjector
{
    if (self = [super init])
    {
        _evaluator = evaluator;
        _keyPathParser = keyPathParser;
        _valueInjector = valueInjector;
    }
    return self;
}

- (void)buildModelFromFormDescriptor:(NSDictionary<NSString *, id> *)formDescriptor
{
    self.model = [[EvaluationModel alloc] initWithFormDescriptor:formDescriptor];
}

- (BOOL)boolValueForKey:(NSString *)key
{
    NSMutableString *value;
    if (![key hasPrefix:@"model"])
    {
        NSString *correctKeyPath = [NSString stringWithFormat:@"model.%@", key];
        value = [self.model[correctKeyPath] mutableCopy];
    }
    else
    {
        value = [self.model[key] mutableCopy];
    }
    if ([value hasPrefix:@"${"] || [value hasSuffix:@"}"])
    {
        NSArray<NSString *> *keyPaths = [self.keyPathParser parseExpression:value];
        NSArray<id> *values = [self.model valuesForKeyPaths:keyPaths];
        NSDictionary<NSString *, id> *keysAndValues = [[NSDictionary alloc] initWithObjects:values forKeys:keyPaths];
        [self.valueInjector injectValues:keysAndValues intoExpression:value];
    }
    [value replaceOccurrencesOfString:@"${" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, value.length)];
    [value replaceOccurrencesOfString:@"}" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, value.length)];
    return [self.evaluator evaluateBoolForExpression:value];
}

- (void)setBoolValue:(BOOL)boolean forKey:(NSString *)key
{

}

- (NSDictionary<NSString *, id> *)resultData
{
    return nil;
}

@end