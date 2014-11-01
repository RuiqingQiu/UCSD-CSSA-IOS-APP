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
    
    

    IBOutlet UITextField *positionField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *collegeField;
    IBOutlet UITextField *majorField;

    IBOutlet UITextField *mottoField;

    ;
    /*
    __weak IBOutlet UILabel *Motto;
    __weak IBOutlet UILabel *Status;
    __weak IBOutlet UILabel *Major;
    __weak IBOutlet UILabel *College;
    __weak IBOutlet UILabel *JobTitle;
     */
    
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *signoutButton;
     
    IBOutlet UITextField *loging_user;
    IBOutlet UITextField *login_pass;
    IBOutlet UIImageView *avatar;
    IBOutlet UIView *loginView;
    IBOutlet UIView *profileView;
}
- (IBAction)editProfile:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)dismissLoginName:(id)sender;
- (IBAction)dismissNmae:(id)sender;

- (IBAction)dismissPassword:(id)sender;
- (IBAction)dismissMajor:(id)sender;
- (IBAction)dismissPosition:(id)sender;
- (IBAction)signOut:(id)sender;
- (IBAction)dismissMotto:(id)sender;
- (IBAction)dismissCollege:(id)sender;
- (IBAction)didBeginEditing:(id)sender;
- (IBAction)didEndEditing:(id)sender;
@property (nonatomic, strong) NSMutableData *responseData;
@end
