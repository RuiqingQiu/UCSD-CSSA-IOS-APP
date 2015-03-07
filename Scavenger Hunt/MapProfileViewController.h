//
//  MapProfileViewController.h
//  CSSAMon
//
//  Created by TK on 1/24/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "ChatHistoryTableViewController.h"

@interface MapProfileViewController : UIViewController

@property WYPopoverController* popoverController;

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *departmentField;
@property (strong, nonatomic) IBOutlet UITextField *collegeField;
@property (strong, nonatomic) IBOutlet UITextField *majorField;
@property (strong, nonatomic) IBOutlet UITextField *mottoField;

@property (nonatomic) NSInteger number;
-(void)dismissSubview;
@end
