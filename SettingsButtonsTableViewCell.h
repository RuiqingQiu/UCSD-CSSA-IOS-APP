//
//  SettingsButtonsTableViewCell.h
//  CSSAMon
//
//  Created by zhangjinzhe on 11/16/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsButtonsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *SettingsButtonUpdateManually;
@property (weak, nonatomic) IBOutlet UIButton *SettingsButtonRemoveMyLocation;
- (IBAction)updateManually:(id)sender;
- (IBAction)removeMyLocation:(id)sender;
- (void) setEnable: (BOOL) enable;


@end
