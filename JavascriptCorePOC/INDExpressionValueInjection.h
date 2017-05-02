//
// Created by Tibor Molnár on 2017. 04. 27..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INDExpressionValueInjection <NSObject>

- (void)injectValues:(NSDictionary<NSString *,id> *)values intoExpression:(NSMutableString *)rawExpression;

@end