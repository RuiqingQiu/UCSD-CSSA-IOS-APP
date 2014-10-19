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
    imgarr = [NSArray arrayWithObjects:@"Poster_halloween_v2.png",@"Poster_scavengerhunt.png", nil];
    [pageCtrl setNumberOfPages:[imgarr count]];
}
-(void)viewWillAppear:(BOOL)animated
{

}

- (IBAction)changePage:(id)sender {
    
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
- (IBAction)click:(id)sender {
  
        [self changePage2:sender];
}
@end
