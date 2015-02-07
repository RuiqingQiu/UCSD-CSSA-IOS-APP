//
//  MapProfileViewController.m
//  CSSAMon
//
//  Created by TK on 1/24/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import "MapProfileViewController.h"

#import "TalkToServer.h"

@interface MapProfileViewController ()

@end

@implementation MapProfileViewController

NSArray* departmentArray;
NSArray* collegeArray;
NSString* departmentName;
NSString* collegeName;
/*UIImage* avatar_large;
BOOL* isOfficer;
NSInteger* department;
NSString* departmentName;
NSString* name;
NSString* position;
NSInteger* college;
NSInteger* collegeName;
NSString* g_major;
NSString* motto;
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"@%ld",(long)self.number);
    collegeArray = [[NSArray alloc]initWithObjects:@"ERC", @"Marshall", @"Muir", @"Revelle", @"Warren", @"Sixth",nil];
    departmentArray = [[NSArray alloc]initWithObjects:@"非officer", @"PM", @"学术部", @"宣传部", @"文体部", @"技术部",@"外联部", @"Advisor&前辈", @"其他officer",nil];
    
    UIImage* avatar_large;
    BOOL isOfficer;
    BOOL b;
    NSInteger department;
    NSString* name;
    NSString* position;
    NSInteger college;
    NSString* major;
    NSString* motto;
    
    b = [TalkToServer getProfileWithId:self.number  Pname:&name Pavatar_large:&avatar_large PisOfficer:nil Pdepartment:&department Pposition:&position Pcollege:&college Pmajor:&major Pmotto:&motto PerrorString:nil];
    //g_major = college;
    NSLog(@"%d!!!!",department);
    
    
    departmentName = [departmentArray objectAtIndex:department];
    collegeName = [collegeArray objectAtIndex:college-1];
    [_nameField setText:name];
    [_departmentField setText:departmentName];
    [_collegeField setText:collegeName];
    [_majorField setText:major];
    [_mottoField setText:motto];
    [_avatar setImage:avatar_large];
    
    
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
