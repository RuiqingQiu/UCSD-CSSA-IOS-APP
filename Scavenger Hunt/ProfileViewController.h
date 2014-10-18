//
//  ProfileViewController.h
//  Scavenger Hunt
//
//  Created by ennuma on 14-10-15.
//  Copyright (c) 2014年 Ruiqing Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileViewController : UIViewController
{
    __weak IBOutlet UILabel *Department;
    __weak IBOutlet UILabel *Motto;
    __weak IBOutlet UILabel *Status;
    __weak IBOutlet UILabel *Major;
    __weak IBOutlet UILabel *College;
    __weak IBOutlet UILabel *JobTitle;
    __weak IBOutlet UILabel *Name;
    IBOutlet UITextField *loging_user;
    IBOutlet UITextField *login_pass;
    IBOutlet UIView *loginView;
    IBOutlet UIView *profileView;
}
- (IBAction)login:(id)sender;
- (IBAction)dismissLoginName:(id)sender;
- (IBAction)dismissPassword:(id)sender;
@property (nonatomic, strong) NSMutableData *responseData;
@end
