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

static NSString * const INDJavascriptPOCJSVariableCellIdentifier = @"Cell";

@interface ListVariablesViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

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
    return [[self.context allVariables] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VariableCell *cell = [tableView dequeueReusableCellWithIdentifier:INDJavascriptPOCJSVariableCellIdentifier];
    if (!cell) {
        cell = [[VariableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:INDJavascriptPOCJSVariableCellIdentifier];
    }
    NSDictionary<NSString *, INDJSTypeDescriptor *> *allVariables = [self.context allVariables];
    NSString *varName = [allVariables allKeys][(NSUInteger) indexPath.row];
    INDJSTypeDescriptor *varValue = [allVariables allValues][(NSUInteger) indexPath.row];
    cell.varNameLabel.text = varName;
    cell.varValueLabel.text = varValue.value;
    cell.varTypeLabel.text = INDJSTypeDescriptorToString(varValue.type);
    return cell;
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
    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"Addition" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
