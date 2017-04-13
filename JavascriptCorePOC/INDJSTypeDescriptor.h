//
// Created by Tibor Molnár on 2017. 04. 13..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, INDJSType) {
    INDJSTypeString,
    INDJSTypeBool,
    INDJSTypeInteger,
    INDJSTypeDouble
};

#define INDJSTypeDescriptorToString(INDJSType) @[@"string", @"bool", @"integer", @"double"][INDJSType]

@interface INDJSTypeDescriptor : NSObject

@property(nonatomic, copy) NSString *variableName;
@property(nonatomic, assign) INDJSType type;
@property(nonatomic, strong) id value;

- (instancetype)initWithName:(NSString *)name type:(INDJSType)type value:(id)value;
+ (instancetype)descriptorWithName:(NSString *)name type:(INDJSType)type value:(id)value;

@end