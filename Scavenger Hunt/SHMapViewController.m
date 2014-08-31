//
//  SHMapViewController.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/23/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SHMapViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "BadgeManager.h"
#import "Badge.h"

@implementation SHMapViewController {
}
@synthesize locationManager, currentLocation;
@synthesize map = mapView_;
- (void)viewDidLoad {
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    mapView_.myLocationEnabled = YES;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    mapView_.settings.myLocationButton = YES;
    [mapView_ animateToCameraPosition:camera];
    
    for(int i = 0; i < 5; i++) {
        NSLog(@"%@", ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:i]).image);
        
    }
    //[_Image1 setImage: [UIImage imageNamed:@"UC_Sea_ovt.png"]];
    //[_Image2 setImage:((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:1]).image];
    locationManager = [[CLLocationManager alloc] init];
}

-(void) viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D target =
    CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude);
    [mapView_ animateToLocation: target];
    [mapView_ animateToZoom:17];
    [self startLocationServices];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [[BadgeManager sharedBadgeManager].badgeList count];
}

-(CGFloat) tableView: (UITableView* ) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height/2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.textLabel.text = ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:indexPath.row]).name;
    
    cell.imageView.image = ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:indexPath.row]).image;
    
    
    return cell;
    
}

- (void)startLocationServices {
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	
	if ([CLLocationManager locationServicesEnabled]) {
		[locationManager startUpdatingLocation];
	} else {
		NSLog(@"Location services is not enabled");
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    NSLog(@"Latidude %f Longitude: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    for(int i = 0; i < 5; i++){
        double b_latitude = ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:i]).latitude;
        double b_longitude =((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:i]).longtitude;
        NSLog(@"latitude: %4.0f, longitude: %4.0f", b_latitude, b_longitude);
        CLLocation *badgeLocation = [[CLLocation alloc]
                                initWithLatitude: b_latitude
                                 longitude: b_longitude];
    
        CLLocationDistance distance = [newLocation distanceFromLocation:badgeLocation];
        NSLog(@"%4.0f", distance);
        //If it's 10 meters less, then set it to be visible.
        if(distance < 10){
            ((Badge*)[[BadgeManager sharedBadgeManager].badgeList objectAtIndex:1]).isHidden = NO;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                        message:[error description]
                        delegate:nil
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
        [alert show];
    }
}

@end
