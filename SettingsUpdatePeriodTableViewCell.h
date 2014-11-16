//
//  SettingsUpdatePeriodTableViewCell.h
//  CSSAMon
//
//  Created by zhangjinzhe on 11/15/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsUpdatePeriodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *settingsSlider;
- (IBAction)sliderChanged:(id)sender;
- (void) setEnable : (BOOL) enable;

@end
