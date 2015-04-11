//
//  NearbyViewController.h
//  CSSAMon
//
//  Created by Zhaoyang Zeng on 11/15/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Annotation.h"

@interface NearbyViewController : UIViewController
- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property NSMutableArray* anno_list;
@property NSArray * sorted_anno_list;
@property double latitude, longitude;
@end
