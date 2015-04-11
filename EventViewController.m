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
    imgarr = [NSArray arrayWithObjects:@"Poster_halloween_v2.png",@"Poster_scavengerhuntcs2.png", nil];
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
    
    //Create an empty anno list
    UIButton *test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSLog(@"width is %f\n",self.view.frame.size.width);
    test.frame = CGRectMake(self.view.frame.size.width*5/10, 475, 40, 40);
    [UIColor clearColor];
    UIImage *btnImage = [UIImage imageNamed:@"refresh0.png"];
    
    [test setImage:btnImage forState:UIControlStateNormal];
    [test addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    test.tintColor = [UIColor redColor];
    [self.view addSubview:test];
    
}

-(void)test:(UIButton *)sender{
    CAPartDViewController *partDVC = [[CAPartDViewController alloc] init];
    [self presentViewController:partDVC animated:YES completion:nil];
}

- (IBAction)changePage:(id)sender {
    
    
}
-(void)left:(UISwipeGestureRecognizer *)recog;
{
    NSLog(@"left");
    [self changePage2:nil];


}

-(void)right:(UISwipeGestureRecognizer *)recog;
{
    NSLog(@"right");
    [self changePage3:nil];

    
}

- (IBAction)changePage2:(id)sender {
    //NSLog(@"%d", pageCtrl.numberOfPages);
    //NSInteger currentPage = pageCtrl.currentPage + 1;
    //CGPoint offset = CGPointMake(currentPage * self.scrollView.frame.size.width, 0);
    //[self.scrollView setContentOffset:offset animated:YES];
    
    if(pageCtrl.currentPage >= pageCtrl.numberOfPages-1){
        pageCtrl.currentPage = 0;
    }
    else
        pageCtrl.currentPage = pageCtrl.currentPage + 1;
    //NSLog(@"%d", pageCtrl.currentPage);

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

- (IBAction)changePage3:(id)sender {
    //to right
    // TO DO: finx order
    
    if(pageCtrl.currentPage >= pageCtrl.numberOfPages-1){
        pageCtrl.currentPage = 0;
    }
    else
        pageCtrl.currentPage = pageCtrl.currentPage + 1;
    //NSLog(@"%d", pageCtrl.currentPage);
    
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
  
        [self changePage2:sender];
}

@end
