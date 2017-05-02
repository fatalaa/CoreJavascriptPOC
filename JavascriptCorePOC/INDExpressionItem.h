//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface INDExpressionItem : NSObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *value;
@property (strong, nonatomic) NSDictionary<NSString *, NSString *> *properties;

- (BOOL)isExpression;

@end