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


    IBOutlet UIPickerView *collegePicker;
    IBOutlet UIPickerView *departmentPicker;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *signoutButton;
     
    IBOutlet UIButton *departmentButton;
    IBOutlet UIButton *collegeButton;
    IBOutlet UITextField *loging_user;
    IBOutlet UITextField *login_pass;
    IBOutlet UIImageView *avatar;
    IBOutlet UIView *loginView;
    IBOutlet UIView *profileView;
    IBOutlet UINavigationBar *bar;
    bool departmentShow;
    bool collegeShow;
}
- (IBAction)doneButton:(id)sender;

- (IBAction)chooseCollege:(id)sender;
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
- (IBAction)chooseDepartment:(id)sender;
- (IBAction)didBeginEditing:(id)sender;
- (IBAction)didEndEditing:(id)sender;
- (IBAction)touchDown:(id)sender;

@property (nonatomic, strong) NSMutableData *responseData;
@end
