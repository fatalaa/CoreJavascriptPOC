//
//  TableViewCell.h
//  JavascriptCorePOC
//
//  Created by Tibor Molnár on 2017. 04. 11..
//  Copyright © 2017. Tibor Molnar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariableCell : UITableViewCell

@property (strong, nonatomic) UILabel *varNameLabel;
@property (strong, nonatomic) UILabel *varValueLabel;
@property (strong, nonatomic) UILabel *varTypeLabel;

@end
