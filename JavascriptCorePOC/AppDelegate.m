//
//  AppDelegate.m
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 10..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "AppDelegate.h"
#import "INDDefaultJSContext.h"
#import "ListVariablesViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id<INDJSContext> javascriptContext = [INDDefaultJSContext new];
    
    ListVariablesViewController *viewController = [[ListVariablesViewController alloc] initWithJavascriptContext:javascriptContext];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self setupUI];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupUI
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:40/255 green:53/255 blue:147/255 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [[UITextField appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [[UITextField appearance] setBorderStyle:UITextBorderStyleRoundedRect];
}

@end
