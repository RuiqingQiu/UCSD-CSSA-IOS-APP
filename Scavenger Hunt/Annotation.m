//
//  Annotation.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize title,subtitle,coordinate, image_url,user_id;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location
         image_url:(NSString*)url
           user_id:(NSString*)m_user_id
{
    self = [super init];
    if(self){
        title = newTitle;
        coordinate = location;
        image_url = url;
        user_id = m_user_id;
        NSLog(@"%@userid",m_user_id);
    }
    
    return self;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void)tapRight
{
    NSLog(@"tab right anno");
    NSInteger a = [user_id integerValue];
    [MapViewController right_function:a];
    NSLog(@"%@###",user_id);
    //MapViewController *viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];

}

-(MKAnnotationView*)annotationView{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    //All annotation is map_avatar.png
    annotationView.image = [UIImage imageNamed:@"map_pin_v3.png"];
    //For the right side to have an information button
    UIButton *right=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [right addTarget:self action:@selector(tapRight) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = right;

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:image_url]];
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    annotationView.leftCalloutAccessoryView = leftIconView;


    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    /*if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        CalloutView *calloutView = (CalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"callOutView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        [calloutView.calloutLabel setText:[(MyLocation*)[view annotation] title]];
        [calloutView.btnYes addTarget:self
                               action:@selector(checkin)
                     forControlEvents:UIControlEventTouchUpInside];
        calloutView.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        [view addSubview:calloutView];
    }*/
    NSLog(@"here");
    
    
}

@end
