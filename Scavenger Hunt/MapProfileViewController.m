//
//  MapProfileViewController.m
//  CSSAMon
//
//  Created by TK on 1/24/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import "MapProfileViewController.h"

#import "TalkToServer.h"
#import "WYPopoverController.h"
#import "ChatSelectController.h"

@interface MapProfileViewController ()

@end

@implementation MapProfileViewController
@synthesize popoverController;

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
    
    
    departmentName = [departmentArray objectAtIndex:department];
    collegeName = [collegeArray objectAtIndex:college-1];
    [_nameField setText:name];
    [_departmentField setText:departmentName];
    [_collegeField setText:collegeName];
    [_majorField setText:major];
    [_mottoField setText:motto];
    [_avatar setImage:avatar_large];
    
    //Adding buttons for chat
    UIButton *sayhi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sayhi.frame = CGRectMake(self.view.frame.size.width*7/10, 475, 70, 70);
    UIImage *btnImage2 = [UIImage imageNamed:@"sayhi.png"];
    [sayhi setTintColor:[UIColor colorWithRed:161/256.0f  green:135/256.0f  blue:135/256.0f  alpha:1]];

    [sayhi setImage:btnImage2 forState:UIControlStateNormal];
    [sayhi addTarget:self action:@selector(sayhi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sayhi];
        
}

-(void)sayhi:(UIButton *)sender{
    NSLog(@"show chat list");
    UIView *btn = (UIView *)sender;
    //[self loadDataWithRKey:str];
    ChatSelectController *charVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatSelectController"];
    charVC.preferredContentSize = CGSizeMake(200, 200);
    charVC.title = @"chat selection";
    charVC.person_to = self.number;
    popoverController = [[WYPopoverController alloc] initWithContentViewController:charVC];
    popoverController.delegate = self;
    popoverController.passthroughViews = @[btn];
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    
    [popoverController presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
