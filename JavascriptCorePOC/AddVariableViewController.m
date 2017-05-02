//
//  AddVariableViewController.m
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 11..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "AddVariableViewController.h"
#import "INDJSContext.h"
#import "NSMutableDictionary+Merge.h"
#import "INDDefaultEvaluationModelHandler.h"
#import "INDExpressionEvaluator.h"
#import "INDKeyPathParser.h"
#import "INDExpressionValueInjector.h"

@interface AddVariableViewController ()

@property (strong, nonatomic) UISegmentedControl *typeChooser;
@property (strong, nonatomic) UITextField *varNameField;
@property (strong, nonatomic) UITextField *varValueField;
@property (strong, nonatomic) UISwitch *boolValueSwitch;
@property (strong, nonatomic) UIButton *addValueButton;

@property (strong, nonatomic) id<INDJSContext> javascriptContext;

@end

@implementation AddVariableViewController

- (instancetype)initWithJavascriptContext:(id<INDJSContext>)javascriptContext;
{
    self = [super init];
    if (self)
    {
        _javascriptContext = javascriptContext;
        self.typeChooser = [[UISegmentedControl alloc] initWithItems:@[@"String", @"Bool", @"Integer", @"Double"]];
        [self.typeChooser addTarget:self action:@selector(refreshLayout) forControlEvents:UIControlEventValueChanged];
        self.varNameField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.varNameField.placeholder = @"Your variable's name";
        self.varNameField.keyboardType = UIKeyboardTypeASCIICapable;
        self.varNameField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.varNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.varValueField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.varValueField.placeholder = @"Your value";
        self.varValueField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.varValueField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.boolValueSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        self.boolValueSwitch.enabled = NO;
        self.boolValueSwitch.hidden = YES;
        self.addValueButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.addValueButton setTitle:@"Add variable" forState:UIControlStateNormal];
        self.addValueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.addValueButton.titleLabel.tintColor = [UIColor blackColor];
        self.addValueButton.layer.cornerRadius = 5.f;
        self.addValueButton.layer.borderColor = [[UIColor blackColor] CGColor];
        self.addValueButton.layer.borderWidth = 1.f;
        [self.addValueButton addTarget:self action:@selector(addVariable) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.typeChooser];
        [self.view addSubview:self.varNameField];
        [self.view addSubview:self.varValueField];
        [self.view addSubview:self.boolValueSwitch];
        [self.view addSubview:self.addValueButton];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Load from json" style:UIBarButtonItemStyleDone target:self action:@selector(loadJSON)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupConstraints];
}

#pragma mark - Private interface

- (void)refreshLayout
{
    NSInteger currentIndex = self.typeChooser.selectedSegmentIndex;
    switch (currentIndex) {
        case 0:
        {
            self.boolValueSwitch.enabled = NO;
            self.boolValueSwitch.hidden = YES;
            self.varValueField.enabled = YES;
            self.varValueField.hidden = NO;
            self.varValueField.keyboardType = UIKeyboardTypeASCIICapable;
            break;
        }
        case 1:
        {
            self.boolValueSwitch.enabled = YES;
            self.boolValueSwitch.hidden = NO;
            self.varValueField.enabled = NO;
            self.varValueField.hidden = YES;
            break;
        }
        case 2:
        {
            self.boolValueSwitch.enabled = NO;
            self.boolValueSwitch.hidden = YES;
            self.varValueField.enabled = YES;
            self.varValueField.hidden = NO;
            self.varValueField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        }
        case 3:
        {
            self.boolValueSwitch.enabled = NO;
            self.boolValueSwitch.hidden = YES;
            self.varValueField.enabled = YES;
            self.varValueField.hidden = NO;
            self.varValueField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        }
        default:
            break;
    }
}

- (void)setupConstraints
{
    self.typeChooser.translatesAutoresizingMaskIntoConstraints = NO;
    self.varNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.varValueField.translatesAutoresizingMaskIntoConstraints = NO;
    self.boolValueSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    self.addValueButton.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
            [self.typeChooser.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.f],
            [self.typeChooser.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10.f],
            [self.typeChooser.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:10.f],
            [self.typeChooser.heightAnchor constraintEqualToConstant:44.f],

            [self.varNameField.leadingAnchor constraintEqualToAnchor:self.typeChooser.leadingAnchor],
            [self.varNameField.widthAnchor constraintEqualToAnchor:self.typeChooser.widthAnchor multiplier:.5f constant:-15.f],
            [self.varNameField.topAnchor constraintEqualToAnchor:self.typeChooser.bottomAnchor constant:15.f],
            [self.varNameField.heightAnchor constraintEqualToConstant:44.f],


            [self.varValueField.trailingAnchor constraintEqualToAnchor:self.typeChooser.trailingAnchor],
            [self.varValueField.widthAnchor constraintEqualToAnchor:self.typeChooser.widthAnchor multiplier:.5f constant:-15.f],
            [self.varValueField.topAnchor constraintEqualToAnchor:self.typeChooser.bottomAnchor constant:15.f],
            [self.varValueField.heightAnchor constraintEqualToConstant:44.f],

            [self.boolValueSwitch.centerXAnchor constraintEqualToAnchor:self.varValueField.centerXAnchor],
            [self.boolValueSwitch.centerYAnchor constraintEqualToAnchor:self.varValueField.centerYAnchor],

            [self.addValueButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [self.addValueButton.topAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-100.f],
            [self.addValueButton.widthAnchor constraintEqualToConstant:150.f],
            [self.addValueButton.heightAnchor constraintEqualToConstant:55.f]
    ]];
}

- (void)addVariable
{
    if(![self validateForm])
    {
        [self showInvalidFormAlert];
    }
    else
    {
        [self addVariableAccordingToFormSettings];
        self.varNameField.text = nil;
        self.varValueField.text = nil;
        [self.view endEditing:YES];
    }

}

- (void)addVariableAccordingToFormSettings
{
    switch (self.typeChooser.selectedSegmentIndex) {
        case 0:
        {
            [self.javascriptContext addStringWithName:self.varNameField.text value:self.varValueField.text];
            break;
        }
        case 1:
        {
            [self.javascriptContext addBoolWithName:self.varNameField.text value:@(self.boolValueSwitch.isOn)];
            break;
        }
        case 2:
        {
            [self.javascriptContext addIntegerWithName:self.varNameField.text value:@(self.varValueField.text.integerValue)];
            break;
        }
        case 3:
        {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.locale = [NSLocale currentLocale];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            [self.javascriptContext addDoubleWithName:self.varNameField.text value:[formatter numberFromString:self.varValueField.text]];
        }
        default:
            break;
    }
}

- (void)showInvalidFormAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid value(s)" message:@"Please fill the form approprietly" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)validateForm
{
    BOOL isValid = self.typeChooser.selectedSegmentIndex != -1;
    isValid &= self.varNameField.text != nil;
    isValid &= self.varValueField.text != nil;
    return isValid;
}

- (void)loadJSON
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mobileform" ofType:@"json"]];
    NSDictionary<NSString *, id> *mobileForm = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    id<INDExpressionEvaluating> evaluator = [[INDExpressionEvaluator alloc] initWithJavascriptContext:self.javascriptContext];
    id<INDKeyPathParsing> parser = [[INDKeyPathParser alloc] init];
    id<INDExpressionValueInjection> injector = [[INDExpressionValueInjector alloc] init];
    id<INDEvaluationModelHandling> handler = [[INDDefaultEvaluationModelHandler alloc] initWithExpressionEvaluator:evaluator keyPathParser:parser valueInjector:injector];
    [handler buildModelFromFormDescriptor:mobileForm];
    BOOL res = [handler boolValueForKey:@"section2.dynamicReadonly.readonly"];
    NSLog(@"%@", @(res));

//    // Get the sections
//    NSArray *sections = [mobileForm valueForKeyPath:@"data.sections"];
//    __block NSMutableDictionary<NSString *, NSMutableDictionary *> *evaluatorModel = [NSMutableDictionary dictionary];
//
//    [sections enumerateObjectsUsingBlock:^(NSDictionary *section, NSUInteger idx, BOOL *stop)
//    {
//        NSString *sectionKey = section[@"properties"][@"key"];
//        NSArray *fieldGroup = section[@"fieldGroup"];
//        [fieldGroup enumerateObjectsUsingBlock:^(NSDictionary *field, NSUInteger index, BOOL *stahp)
//        {
//            NSString *fieldKey = field[@"key"];
//            NSMutableDictionary *rootMinusOneLevelDict;
//            NSArray<NSString *> *keyPathParts = [fieldKey componentsSeparatedByString:@"."];
//            rootMinusOneLevelDict = [self nestedDictionaryFromKeyPaths:keyPathParts level:0];
//            [rootMinusOneLevelDict setValue:[self propertyAndConstraintDictionaryFromField:field] forKeyPath:fieldKey];
//            evaluatorModel = [NSMutableDictionary dictionaryByExtending:evaluatorModel withDictionary:rootMinusOneLevelDict];
//        }];
//
//    }];
//    [self.javascriptContext embedObject:evaluatorModel];
}

- (NSMutableDictionary<NSString *, id> *)nestedDictionaryFromKeyPaths:(NSArray<NSString *> *)array level:(NSUInteger)level
{
    if (array.count > level + 1)
    {
        return [NSMutableDictionary dictionaryWithDictionary:@{array[level]: [self nestedDictionaryFromKeyPaths:array level:level+1]}];
    }
    else {
        return [NSMutableDictionary dictionaryWithDictionary:@{array[level]: [NSMutableDictionary dictionary]}];
    }
}

- (NSDictionary<NSString *, id> *)propertyAndConstraintDictionaryFromField:(NSDictionary<NSString *, id> *)field
{
    NSMutableDictionary *propertyAndConstraintDictionary = [NSMutableDictionary dictionary];
    NSDictionary<NSString *, id> *properties = field[@"properties"];
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString *propKey, id propValue, BOOL *stopp)
    {
        if (![propKey isEqualToString:@"label"] && ![propKey isEqualToString:@"placeholder"])
        {
            propertyAndConstraintDictionary[propKey] = propValue;
        }
    }];
    NSDictionary<NSString *, NSDictionary *> *constraints = field[@"constraints"];
    [constraints enumerateKeysAndObjectsUsingBlock:^(NSString *constraintKey, NSDictionary *constraintModel, BOOL *stop)
    {
        propertyAndConstraintDictionary[constraintKey] = constraintModel[@"value"];
    }];
    return [propertyAndConstraintDictionary copy];
}

@end
