//
//  UIViewController+MapViewController.h
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WYPopoverController.h"
#import "EAIntroView.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>
//@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property CLLocationManager *locationManager;
@property WYPopoverController* popoverController;
//For loading data from the server
//@property (nonatomic, strong) NSMutableData *responseData;
-(void)sendBackground:(NSTimer*)timer;
-(void)send:(NSTimer*) timer;
-(void)setTimerInterval:(int) time_interval;
-(void)setUpdateLocation:(BOOL) updating;
@end
