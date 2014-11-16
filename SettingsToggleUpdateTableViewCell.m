//
//  SettingsToggleUpdateTableViewCell.m
//  CSSAMon
//
//  Created by zhangjinzhe on 11/8/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SettingsToggleUpdateTableViewCell.h"

@implementation SettingsToggleUpdateTableViewCell
@synthesize settingsSwitch = _settingsSwitch;

- (void)awakeFromNib {
    // Initialization code
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"is_updating"]==nil)   //initialize
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_updating"];
        //TODO check if is officer
    BOOL is_updating = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_updating"];
    [_settingsSwitch setOn:is_updating animated:NO];
}

- (IBAction)switchChanged:(id)sender
{
    BOOL is_updating = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setBool:is_updating forKey:@"is_updating"];
    NSLog(@"is_updating updated to %@",is_updating?@"ON":@"OFF");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEnable : (BOOL) enable {
    [self.textLabel setTextColor:enable?[UIColor blackColor]:[UIColor grayColor]];
    [_settingsSwitch setEnabled:enable];
}


@end
