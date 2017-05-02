//
// Created by Tibor Molnár on 2017. 04. 27..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INDKeyPathParsing <NSObject>

- (NSArray<NSString *> *)parseExpression:(NSString *)expression;

@end

@interface INDKeyPathParser : NSObject <INDKeyPathParsing>

@end