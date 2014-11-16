//
//  SettingsUpdatePeriodTableViewCell.m
//  CSSAMon
//
//  Created by zhangjinzhe on 11/15/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SettingsUpdatePeriodTableViewCell.h"

@implementation SettingsUpdatePeriodTableViewCell
@synthesize settingsSlider = _settingsSlider;

- (void)awakeFromNib {
    // Initialization code
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"updatePeriodInSeconds"] == nil)
        [[NSUserDefaults standardUserDefaults] setInteger:60 forKey:@"updatePeriodInSeconds"];
    NSInteger period = [[NSUserDefaults standardUserDefaults] integerForKey:@"updatePeriodInSeconds"];
    NSString *labelText = [@"Update every " stringByAppendingFormat:@"%lds",(long)period];
    [self.textLabel setText:labelText];
    float sliderValue;
    if (period<=15)
        sliderValue = period/5 - 1;
    else if (period == 30)
        sliderValue = 3;
    else
        sliderValue = 4;
    [_settingsSlider setValue:sliderValue animated:NO];
    
}

- (IBAction)sliderChanged:(id)sender
{
    int sliderValue = (int)lroundf(_settingsSlider.value);
    [_settingsSlider setValue:(float)sliderValue animated:YES];
    NSString *periodText;
    NSInteger period;
    switch (sliderValue) {
        case 0:
            periodText = @"5s";
            period = 5;
            break;
        case 1:
            periodText = @"10s";
            period = 10;
            break;
        case 2:
            periodText = @"15s";
            period = 15;
            break;
        case 3:
            periodText = @"30s";
            period = 30;
            break;
        default:
            periodText = @"60s";
            period = 60;
            break;
    }
    NSString *labelText = [@"Update every " stringByAppendingString:periodText];
    [self.textLabel setText:labelText];
    [[NSUserDefaults standardUserDefaults] setInteger:period forKey:@"updatePeriodInSeconds"];
    NSLog(@"updatePeriodInSeconds updated to %ld",(long)period);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setEnable : (BOOL) enable {
    [self.textLabel setTextColor:enable?[UIColor blackColor]:[UIColor grayColor]];
    [_settingsSlider setEnabled:enable];
}

@end
