//
// Created by Tibor Molnár on 2017. 04. 26..
// Copyright (c) 2017 Tibor Molnar. All rights reserved.
//

#import "NSMutableDictionary+Merge.h"


@implementation NSMutableDictionary (Merge)

+ (NSMutableDictionary *)dictionaryByExtending:(NSMutableDictionary *)baseDictionary withDictionary:(NSMutableDictionary *)extensionDictionary
{

    NSMutableDictionary * resultDictionary = [NSMutableDictionary dictionaryWithDictionary:baseDictionary];

    [extensionDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        BOOL isDict = [obj isKindOfClass:[NSDictionary class]];
        BOOL hasValue = baseDictionary[key] != nil;

        id setObj = obj;

        if( hasValue && isDict ) {

            BOOL hasDict = [baseDictionary[key] isKindOfClass:[NSDictionary class]];

            if( hasDict ) {

                NSDictionary * extendedChildDictionary = [NSMutableDictionary dictionaryByExtending:baseDictionary[key] withDictionary:obj];
                setObj = extendedChildDictionary;

            }

        }

        resultDictionary[key] = setObj;

    }];

    return resultDictionary;

}

-(NSMutableDictionary *)dictionaryByExtendingWithDictionary:(NSMutableDictionary *)extensionDictionary
{
    return [NSMutableDictionary dictionaryByExtending:self withDictionary:extensionDictionary];
}

@end