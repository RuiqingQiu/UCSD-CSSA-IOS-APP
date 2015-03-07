//
//  ChatSelectController.h
//  CSSAMon
//
//  Created by Ruiqing Qiu on 2/7/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Annotation.h"
#import "TalkToServer.h"

@interface ChatSelectController : UIViewController
- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property NSInteger person_to;
@property WYPopoverController* popoverController;
@end
