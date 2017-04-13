//
//  TableViewCell.m
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 11..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import "VariableCell.h"

@implementation VariableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _varNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _varValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _varTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_varNameLabel];
        [self.contentView addSubview:_varValueLabel];
        [self.contentView addSubview:_varTypeLabel];
    }

    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.varNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.varValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.varTypeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
            [self.varNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10.f],
            [self.varNameLabel.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:1.f/3.f constant:10.f],
            [self.varNameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5.f],
            [self.varNameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-5.f],

            [self.varValueLabel.leadingAnchor constraintEqualToAnchor:self.varNameLabel.trailingAnchor constant:10.f],
            [self.varValueLabel.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:1.f/3.f constant:5.f],
            [self.varValueLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [self.varValueLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5.f],

            [self.varTypeLabel.leadingAnchor constraintEqualToAnchor:self.varValueLabel.trailingAnchor constant:10.f],
            [self.varTypeLabel.centerYAnchor constraintEqualToAnchor:self.varValueLabel.centerYAnchor],
            [self.varValueLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:5.f],
    ]];
}


@end
