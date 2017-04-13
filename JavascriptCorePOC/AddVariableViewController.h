//
//  AddVariableViewController.h
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 11..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INDJSContext;

@interface AddVariableViewController : UIViewController

- (instancetype)initWithJavascriptContext:(id<INDJSContext>)javascriptContext;

@end
