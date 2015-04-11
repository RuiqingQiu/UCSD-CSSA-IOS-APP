//
//  EventViewController.h
//  Scavenger Hunt
//
//  Created by TK on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPartDViewController.h"
@interface EventViewController : UIViewController
{

    IBOutlet UIPageControl *pageCtrl;
    //IBOutlet UILabel *number;
    IBOutlet UIView *view;
    NSArray * imgarr;
    IBOutlet UIImageView *img;
}
- (IBAction)changePage:(id)sender;
- (IBAction)click:(id)sender;
@end
