//
//  SHMapViewController.h
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SHMapViewController : UIViewController <CLLocationManagerDelegate>
{}
@property (weak, nonatomic) IBOutlet UIImageView *Image1;
@property (weak, nonatomic) IBOutlet UIImageView *Image2;
@property IBOutlet GMSMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;
- (void)startLocationServices;
@end
