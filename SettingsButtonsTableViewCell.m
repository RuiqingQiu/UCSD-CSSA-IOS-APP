//
//  SettingsButtonsTableViewCell.m
//  CSSAMon
//
//  Created by zhangjinzhe on 11/16/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SettingsButtonsTableViewCell.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "TalkToServer.h"

@implementation SettingsButtonsTableViewCell

@synthesize SettingsButtonUpdateManually = _SettingsButtonUpdateManually;
@synthesize SettingsButtonRemoveMyLocation = _SettingsButtonRemoveMyLocation;


- (void)awakeFromNib {
    // Initialization code
    _SettingsButtonUpdateManually.layer.masksToBounds = YES;
    _SettingsButtonUpdateManually.layer.cornerRadius = 7.0f;
    _SettingsButtonUpdateManually.layer.borderWidth = 1.0f;
    _SettingsButtonUpdateManually.layer.borderColor = [[UIColor grayColor] CGColor];
    _SettingsButtonRemoveMyLocation.layer.masksToBounds = YES;
    _SettingsButtonRemoveMyLocation.layer.cornerRadius = 7.0f;
    _SettingsButtonRemoveMyLocation.layer.borderWidth = 1.0f;
    _SettingsButtonRemoveMyLocation.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)updateManually:(id)sender
{
    NSLog(@"updateManually");
}

- (IBAction)removeMyLocation:(id)sender
{
    NSLog(@"removemylocation");
}

- (void)setEnable:(BOOL)enable
{
    [_SettingsButtonUpdateManually setEnabled:enable];
    [_SettingsButtonRemoveMyLocation setEnabled:enable];
}

@end
