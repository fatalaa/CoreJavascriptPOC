//
//  INDJSContext.h
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 10..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

@class INDJSTypeDescriptor;

@protocol INDJSContext <NSObject>

- (void)addStringWithName:(NSString *)variableName value:(NSString *)value;
- (void)addBoolWithName:(NSString *)variableName value:(NSNumber *)value;
- (void)addIntegerWithName:(NSString *)variableName value:(NSNumber *)value;
- (void)addDoubleWithName:(NSString *)variableName value:(NSNumber *)value;
- (void)addFunctionWithName:(NSString *)name functionBody:(NSString *)functionBody;
- (NSDictionary<NSString *,INDJSTypeDescriptor *> *)allVariables;
- (NSArray<NSString *> *)functionNames;

@end
