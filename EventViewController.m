//
//  EventViewController.m
//  Scavenger Hunt
//
//  Created by TK on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "EventViewController.h"
NSInteger text_num = 1;
@implementation EventViewController

-(void)viewDidAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.hidden;
    imgarr = [NSArray arrayWithObjects:@"Poster_halloween_v2.png",@"Poster_scavengerhuntcs2.png", @"Poster_halloween_v2.png", nil];
    [pageCtrl setNumberOfPages:[imgarr count]];
    
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
/**-(void)viewWillDisappear:(BOOL)animated
{
 self.navigationController.navigationBar.hidden = NO;
}**/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    NSLog(@"!!");
    return UIStatusBarStyleLightContent;
}
-(void)viewDidLoad{
       UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(left:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    //tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftRecognizer];
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    //tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightRecognizer];
    
    
    //Add tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    
    tapGesture.numberOfTapsRequired = 1;
    
    [tapGesture setDelegate:self];
    
    [self.view addGestureRecognizer:tapGesture];
    
}

- (IBAction)changePage:(id)sender {
    
    
}
-(void)left:(UISwipeGestureRecognizer *)recog;
{
    NSLog(@"left");
    [self change_page_left:nil];


}

-(void)right:(UISwipeGestureRecognizer *)recog;
{
    NSLog(@"right");
    [self change_page_right:nil];

    
}

- (IBAction)change_page_left:(id)sender {

    pageCtrl.currentPage = (pageCtrl.currentPage + 1) % pageCtrl.numberOfPages;

    int num = pageCtrl.currentPage;
    NSLog(@"%d", num);
    [img setImage:[UIImage imageNamed:(NSString*)[imgarr objectAtIndex:num]]];
    
    
    
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        //[self.view removeFromSuperview];
                        [self.view addSubview:view];
                        
                    } completion:nil];
}

- (void) tapGesture: (id)sender
{
    if(pageCtrl.currentPage == 1){
        CAPartDViewController *partDVC = [[CAPartDViewController alloc] init];
        [self presentViewController:partDVC animated:YES completion:nil];
    }

}

- (void) go_to_food:(id)sender
{
    NSLog(@"It works!");
}


- (IBAction)change_page_right:(id)sender {
    
    if(pageCtrl.currentPage - 1 < 0){
        pageCtrl.currentPage = pageCtrl.numberOfPages - 1;
    }
    else{
        pageCtrl.currentPage = (pageCtrl.currentPage - 1) % pageCtrl.numberOfPages;
    }
    
    int num = pageCtrl.currentPage;
    NSLog(@"%d", num);
    [img setImage:[UIImage imageNamed:(NSString*)[imgarr objectAtIndex:num]]];
    
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        //[self.view removeFromSuperview];
                        [self.view addSubview:view];
                        
                    } completion:nil];
}
- (IBAction)click:(id)sender {
  
        [self change_page_left:sender];
}

@end
