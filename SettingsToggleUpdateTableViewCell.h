//
//  SettingsToggleUpdateTableViewCell.h
//  CSSAMon
//
//  Created by zhangjinzhe on 11/8/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsToggleUpdateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *settingsSwitch;
- (IBAction)switchChanged:(id)sender;
- (void) setEnable : (BOOL) enable;

@end
