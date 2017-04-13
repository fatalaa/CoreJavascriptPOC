//
// Created by Tibor Molnár on 2017. 04. 13..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "INDJSTypeDescriptor.h"


@implementation INDJSTypeDescriptor

- (instancetype)initWithName:(NSString *)name type:(INDJSType)type value:(id)value
{
    if (self = [super init])
    {
        _variableName = name;
        _type = type;
        _value = value;
    }
    return self;
}

+ (instancetype)descriptorWithName:(NSString *)name type:(INDJSType)type value:(id)value
{
    INDJSTypeDescriptor *descriptor = [[INDJSTypeDescriptor alloc] initWithName:name type:type value:value];
    return descriptor;
}

@end