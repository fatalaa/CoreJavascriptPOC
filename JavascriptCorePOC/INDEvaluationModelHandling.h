//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol INDEvaluationModelHandling <NSObject>

- (void)buildModelFromFormDescriptor:(NSDictionary<NSString *, id> *)formDescriptor;
- (BOOL)boolValueForKey:(NSString *)key;
- (void)setBoolValue:(BOOL)boolean forKey:(NSString *)key;
- (NSDictionary<NSString *, id> *)resultData;

@end