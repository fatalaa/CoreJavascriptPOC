//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INDExpressionItem;

@interface EvaluationModel : NSObject

- (instancetype)initWithFormDescriptor:(NSDictionary<NSString *, id> *)formDescriptor;
- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

- (NSArray<id> *)valuesForKeyPaths:(NSArray<NSString *> *)keyPaths;
@end