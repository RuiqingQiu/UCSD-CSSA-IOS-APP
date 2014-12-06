//
//  LoginViewController.h
//  Scavenger Hunt
//
//  Created by TK on 10/12/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITextField *loginNameFiled;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *majorField;
    IBOutlet UITextField *mottoField;
    IBOutlet UITextField *departmentField;
    
    IBOutlet UIButton *buttonDepartment;
    IBOutlet UIPickerView *picker;
    IBOutlet UIPickerView *departmentPicker;
    NSArray *dataArray;
    NSArray *departmentArray;
    IBOutlet UIButton *button;
    IBOutlet UINavigationBar *bar;
    IBOutlet UIBarButtonItem *doneButton;
    
    bool departmentShow;
    bool collegeShow;
}

- (IBAction)save:(id)sender;

- (IBAction)dismissLoginName:(id)sender;
- (IBAction)dismissPassword:(id)sender;
- (IBAction)dismissName:(id)sender;
- (IBAction)dismissMajor:(id)sender;
- (IBAction)dismissMotto:(id)sender;
- (IBAction)dismissDepartment:(id)sender;
- (IBAction)departmentPressed:(id)sender;

-(IBAction)btnPressed:(id)sender;
-(IBAction)doneButton:(id)sender;

@end

