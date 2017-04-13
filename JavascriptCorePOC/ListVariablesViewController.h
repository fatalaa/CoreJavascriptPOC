//
//  ViewController.h
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 10..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListVariablesViewController : UIViewController

- (instancetype)initWithJavascriptContext:(id<INDJSContext>)javascriptContext;

@end

