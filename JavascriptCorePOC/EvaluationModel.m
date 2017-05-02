//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "EvaluationModel.h"
#import "NSMutableDictionary+Merge.h"

@interface EvaluationModel ()

@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *expressionItems;

@end

@implementation EvaluationModel

- (instancetype)initWithFormDescriptor:(NSDictionary<NSString *, id> *)formDescriptor
{
    if (self = [super init])
    {
        _expressionItems = [self createExpressionItemsWithFormDescriptor:formDescriptor];
    }
    return self;
}

- (id)objectForKeyedSubscript:(NSString *)key
{
    return [self.expressionItems valueForKeyPath:key];
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
    [self.expressionItems setValue:object forKeyPath:key];
}

- (NSMutableDictionary<NSString *, id> *)createExpressionItemsWithFormDescriptor:(NSDictionary<NSString *, id> *)formDescriptor
{
    NSArray *sections = [formDescriptor valueForKeyPath:@"data.sections"];
    __block NSMutableDictionary<NSString *, NSMutableDictionary *> *evaluatorModel = [NSMutableDictionary dictionary];

    [sections enumerateObjectsUsingBlock:^(NSDictionary *section, NSUInteger idx, BOOL *stop)
    {
        NSString *sectionKey = section[@"properties"][@"key"];
        NSArray *fieldGroup = section[@"fieldGroup"];
        [fieldGroup enumerateObjectsUsingBlock:^(NSDictionary *field, NSUInteger index, BOOL *stahp)
        {
            NSString *fieldKey = field[@"key"];
            NSMutableDictionary *rootMinusOneLevelDict;
            NSArray<NSString *> *keyPathParts = [fieldKey componentsSeparatedByString:@"."];
            rootMinusOneLevelDict = [self nestedDictionaryFromKeyPaths:keyPathParts level:0];
            [rootMinusOneLevelDict setValue:[self propertyAndConstraintDictionaryFromField:field] forKeyPath:fieldKey];
            evaluatorModel = [NSMutableDictionary dictionaryByExtending:evaluatorModel withDictionary:rootMinusOneLevelDict];
        }];

    }];
    return [[NSMutableDictionary alloc] initWithDictionary:@{@"model": evaluatorModel}];
}

- (NSDictionary<NSString *, id> *)propertyAndConstraintDictionaryFromField:(NSDictionary<NSString *, id> *)field
{
    NSMutableDictionary *propertyAndConstraintDictionary = [NSMutableDictionary dictionary];
    NSDictionary<NSString *, id> *properties = field[@"properties"];
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *propKey, id propValue, BOOL *stopp)
    {
        if (![propKey isEqualToString:@"label"] && ![propKey isEqualToString:@"placeholder"])
        {
            propertyAndConstraintDictionary[propKey] = propValue;
        }
    }];
    NSDictionary<NSString *, NSDictionary *> *constraints = field[@"constraints"];
    [constraints enumerateKeysAndObjectsUsingBlock:^(NSString *constraintKey, NSDictionary *constraintModel, BOOL *stop)
    {
        propertyAndConstraintDictionary[constraintKey] = constraintModel[@"value"];
    }];
    return [propertyAndConstraintDictionary copy];
}

- (NSMutableDictionary<NSString *, id> *)nestedDictionaryFromKeyPaths:(NSArray<NSString *> *)array level:(NSUInteger)level
{
    if (array.count > level + 1)
    {
        return [NSMutableDictionary dictionaryWithDictionary:@{array[level]: [self nestedDictionaryFromKeyPaths:array level:level+1]}];
    }
    else {
        return [NSMutableDictionary dictionaryWithDictionary:@{array[level]: [NSMutableDictionary dictionary]}];
    }
}

- (NSArray<id> *)valuesForKeyPaths:(NSArray<NSString *> *)keyPaths
{
    NSMutableArray<id> *values = [NSMutableArray array];
    [keyPaths enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop)
    {
        if (![obj hasPrefix:@"model"])
        {
            NSString *newKeyPath = [NSString stringWithFormat:@"model.%@.value", obj];
            [values addObject:[self.expressionItems valueForKeyPath:newKeyPath]];
        }
        else
        {
            NSString *newKeyPath = [NSString stringWithFormat:@"%@.value", obj];
            [values addObject:[self.expressionItems valueForKeyPath:newKeyPath]];
        }
    }];
    return [values copy];
}
@end