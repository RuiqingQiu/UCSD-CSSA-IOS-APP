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
//NSInteger id = self.number;
//NSString* peopleName;
UIImage* avatar_large;
BOOL* isOfficer;
NSInteger* department;
NSString* name;
NSString* position;
NSInteger* college;
NSString* g_major;
NSString* motto;


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"@%ld",(long)self.number);
    
    departmentArray = [[NSArray alloc]initWithObjects:@"非officer", @"PM", @"学术部", @"宣传部", @"文体部", @"技术部",@"外联部", @"Advisor&前辈", @"其他officer",nil];
    
    UIImage* avatar_large;
    BOOL* isOfficer;
    NSInteger* department;
    NSString* name;
    NSString* position;
    NSInteger* college;
    NSString* major;
    NSString* motto;
//getProfileWithId:(NSInteger)id_
//Pname:(NSString**)name Pavatar_large:(UIImage**)avatar_large PisOfficer:(BOOL*)isOfficer Pdepartment:(NSInteger*)department Pposition:(NSString**)position Pcollege:(NSInteger*)college Pmajor:(NSString**)major Pmotto:(NSString**)motto PerrorString:(NSString**)errorString
    
    [TalkToServer getProfileWithId:self.number Pname:nil Pavatar_large:&avatar_large PisOfficer:nil Pdepartment:department Pposition:&position Pcollege:college Pmajor:&major Pmotto:&motto PerrorString:nil];
    g_major = major;
    NSLog(@"%@",g_major);
    
     
    
    /*[TalkToServer updateProfileWithName:name department:*department position:position college:*college major: major major:major motto:motto PerrorString:nil];*/
    
    //[TalkToServer updateProfileWithName:name department:*department position:nil college:*college major:major motto:motto PerrorString:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
