//
//  ViewController.m
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 10..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "AddVariableViewController.h"
#import "INDDefaultJSContext.h"
#import "VariableCell.h"
#import "ListVariablesViewController.h"
#import "INDJSTypeDescriptor.h"

#import <libextobjc/extobjc.h>

static NSString * const INDJavascriptPOCJSVariableCellIdentifier = @"Cell";

@interface ListVariablesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) id<INDJSContext> context;

@end

@implementation ListVariablesViewController

- (instancetype)initWithJavascriptContext:(id<INDJSContext>)javascriptContext
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        _context = javascriptContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.tableView registerClass:[VariableCell class] forCellReuseIdentifier:INDJavascriptPOCJSVariableCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddScreen)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Functions" style:UIBarButtonItemStyleDone target:self action:@selector(showFunctions)];
    [self.view addSubview:self.tableView];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableView related

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? [[self.context functionNames] count] : [[self.context allVariables] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = 0;
    sectionCount += [[self.context allVariables] count] > 0 ? 1 : 0;
    sectionCount += [[self.context functionNames] count] > 0 ? 1 : 0;
    return sectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VariableCell *cell = [tableView dequeueReusableCellWithIdentifier:INDJavascriptPOCJSVariableCellIdentifier];
    if (!cell) {
        cell = [[VariableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:INDJavascriptPOCJSVariableCellIdentifier];
    }
    
    if (indexPath.section == 1)
    {
        cell.varNameLabel.text = [self.context functionNames][indexPath.row];
        cell.varTypeLabel.text = @"function";
    }
    else
    {
        if ([[self.context allVariables] count] > 0)
        {
            NSDictionary<NSString *, INDJSTypeDescriptor *> *allVariables = [self.context allVariables];
            NSString *varName = [allVariables allKeys][(NSUInteger) indexPath.row];
            INDJSTypeDescriptor *varValue = [allVariables allValues][(NSUInteger) indexPath.row];
            cell.varNameLabel.text = varName;
            cell.varValueLabel.text = varValue.value;
            cell.varTypeLabel.text = INDJSTypeDescriptorToString(varValue.type);
        }
        else
        {
            cell.varNameLabel.text = [self.context functionNames][indexPath.row];
            cell.varTypeLabel.text = @"function";
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([[self.context allVariables] count] == 0)
        {
                return @"Stored functions";
        }
        else
        {
            return @"Stored variables";
        }
    }
    else
    {
        if ([[self.context functionNames] count] > 0)
        {
            return @"Stored functions";
        }
        else
        {
            return @"Stored variables";
        }
    }
}

# pragma mark - Private interface

- (void)showAddScreen
{
    AddVariableViewController *addVariableViewController = [[AddVariableViewController alloc] initWithJavascriptContext:self.context];
    [self.navigationController pushViewController:addVariableViewController animated:YES];
}

- (void)setupConstraints
{
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor]
                                              ]];
}

- (void)showFunctions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Functions" message:@"Choose a function" preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"Addition" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        [self loadFunctionWithName:@"add"];
        [self.tableView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadFunctionWithName:(NSString *)name
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"js"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
    {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    }
    [self.context addFunctionWithName:name functionBody:fileContents];
}

@end
