//
//  UIViewController+MapViewController.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import "MapViewController.h"
#import "Annotation.h"
#import "NearbyViewController.h"


#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface MapViewController ()
-(void)tapRight;
-(void)tapLeft;
@end
@implementation MapViewController
@synthesize myMapView;
@synthesize locationManager;
@synthesize popoverController;
UIApplication *app;
static NSMutableData *responseData;
double latitude, longitude;
static BOOL locationStarted = FALSE;
static BOOL updateLocation = TRUE;
NSString *rkey;
//Timer for update
NSTimer *timer;
NSMutableArray *anno_list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    
    if(IS_IOS_8_OR_LATER){
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    //初始化一个地图
    [self.view addSubview:self.myMapView];
    
    //设置经度纬度
    MKCoordinateRegion region;
    region.center.latitude=32.8664011;
    region.center.longitude=-117.2233901;
    //设置显示范围
    region.span.latitudeDelta=0.05;
    region.span.longitudeDelta=0.05;
    //指定代理
    
    self.myMapView.delegate=self;
    
    //
    self.myMapView.showsUserLocation=YES;
    self.myMapView.region=region;
    
    [UIButton buttonWithType:UIButtonTypeSystem];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSLog(@"width is %f\n",self.view.frame.size.width);
    button1.frame = CGRectMake(self.view.frame.size.width*8/10, 475, 40, 40);
    [UIColor clearColor];
    UIImage *btnImage = [UIImage imageNamed:@"refresh0.png"];
    [button1 setImage:btnImage forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    button1.tintColor = [UIColor blackColor];
    [self.myMapView addSubview:button1];
    
    UIButton *nearby = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nearby.frame = CGRectMake(self.view.frame.size.width/10, 475, 50, 50);
    UIImage *btnImage2 = [UIImage imageNamed:@"nearby.png"];
    nearby.tintColor = [UIColor blackColor];
    [nearby setImage:btnImage2 forState:UIControlStateNormal];
    [nearby addTarget:self action:@selector(showNearbyList:) forControlEvents:UIControlEventTouchUpInside];
    [self.myMapView addSubview:nearby];
    
    //Create an empty anno list
    anno_list = [NSMutableArray array];
    
    //Tutorial part when first time opened up the app
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.titlePositionY = 500;
    page1.desc = @"Welcome to CSSAMon";
    page1.descPositionY = 480;
    page1.bgImage = [UIImage imageNamed:@"Sun_god_hug.png"];
    // custom
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"CSSAMon\nGotta Catch Them All";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page2.titlePositionY = 250;
    page2.desc = @"You will now be redirected to CSSAMon Map";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page2.descPositionY = 200;
    //page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sun_god_hug.png"]];
    //page2.titleIconPositionY = 20;
    // custom view from nib
    //EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage"];
    //page3.bgImage = [UIImage imageNamed:@"bg2"];
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2]];
    [intro showInView:self.view animateDuration:0.0];
    
}
-(void)buttonDidTap:(UIButton *)sender{
    [self loadDataWithRKey:rkey];
}

-(void)showNearbyList:(UIButton *)sender{
    NSLog(@"show near by list");
    UIView *btn = (UIView *)sender;
    //[self loadDataWithRKey:str];
    NearbyViewController *nearbyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NearbyViewController"];
    nearbyVC.preferredContentSize = CGSizeMake(200, 200);
    nearbyVC.title = @"nearby people";
    nearbyVC.anno_list = anno_list.copy;
    
    popoverController = [[WYPopoverController alloc] initWithContentViewController:nearbyVC];
    popoverController.delegate = self;
    popoverController.passthroughViews = @[btn];
    popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    popoverController.wantsDefaultContentAppearance = NO;
    
    [popoverController presentPopoverFromRect:btn.bounds inView:btn permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    CLLocation *location=userLocation.location;
    latitude = location.coordinate.latitude;
    longitude = location.coordinate.longitude;
    CLLocationCoordinate2D center=location.coordinate;
    //[self.myMapView setCenterCoordinate:center animated:YES];
    NSLog(@"update location");
    //Send data for updating location
    //[self send];
    
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    /*NSLog(@"%d",self.myMapView.annotations.count);
    for (id<MKAnnotation> currentAnnotation in self.myMapView.annotations) {
        [self.myMapView selectAnnotation:currentAnnotation animated:FALSE];
        NSLog(@"here");
    }
    NSLog(@"mapview did finish loading");*/
}
//与tableViewCell一样
//在[self.myMapView addAnnotation:anno];后， 会马上调用这个协议中的方法 返回一个MKAnnotationView供地图显示
//注意：在地图本身去添加用户位置的时候（小蓝点）也会调用这个方法
//mapView:regionWillChangeAnimated:

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[Annotation class]])//If this is custom class
    {
        Annotation *myLocation = (Annotation*) annotation;
        MKAnnotationView *annotationView = [myMapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
        if(annotationView == nil)
            annotationView = myLocation.annotationView;
        else
            annotationView.annotation = annotation;
        return annotationView;
    }
    //如果是系统的小蓝点，就返回nil
    if ([annotation.title isEqualToString:@"Current Location"]==YES)
    {
        return nil;
    }
    //大头针的重用
    static NSString *idPin=@"1";
    
    MKPinAnnotationView *pinView=nil;
    pinView=(MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:idPin];
    
    if (pinView==nil)
    {
        //只能写不变的东西
        pinView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:idPin];
    }
    
    //是否展示掉下来的动画效果
    pinView.animatesDrop=YES;
    
    //允许Callout弹出，默认是不允许
    pinView.canShowCallout=YES;
    
    //设置颜色
    pinView.pinColor=MKPinAnnotationColorPurple;
    
    UIButton *right=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [right addTarget:self action:@selector(tapRight) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView=right;
    
    UIButton *left=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [left addTarget:self action:@selector(tapLeft) forControlEvents:UIControlEventTouchUpInside];
    pinView.leftCalloutAccessoryView=left;
    
    pinView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pinView;
    
}
+(void)right_function{
    NSLog(@"hello");
    //ProfileViewController *profile = [[ProfileViewController alloc]init];
}
-(void)tapLeft
{
    NSString *str=[NSArray array];
    if ([str isKindOfClass:[NSString class]]==YES)
    {
        ;
    }
    else if([str isKindOfClass:[NSArray class]]==YES)
    {
        ;
    }
}
-(void)tapRight
{
    NSLog(@"Information query");
}
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"%@",views);
    
    [views enumerateObjectsUsingBlock:^(MKAnnotationView *pinView, NSUInteger idx, BOOL *stop) {
        if ([pinView isEqual:@"Current Location"]==NO)
        {
            //[mapView selectAnnotation:pinView.annotation animated:YES];
        }
    }];
}
// pinView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure]

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    //[locationManager startUpdatingLocation];
    responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    rkey = [[NSUserDefaults standardUserDefaults] stringForKey:@"rkey"];
    NSLog(@"key %@", rkey);
    if(updateLocation){
        NSLog(@"test");
        [self loadDataWithRKey:rkey];
        [self send:nil];    //update when first opened.
    }
    if(!timer){
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(send:) userInfo:nil repeats:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    //[locationManager stopUpdatingLocation];
    if ([timer isValid]){
        // the timer is valid and running, how about invalidating it
        //[timer invalidate];
        //timer = nil;
        //self.navigationController.navigationBar.hidden = NO;
    }
}


/* For sending location data */
- (void)send:(NSTimer *)timer
{
    if(updateLocation){

    double time = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"lastUpdateLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[NSNumber numberWithDouble:latitude] stringValue],@"latitude",
                                [[NSNumber numberWithDouble:longitude]stringValue],@"longitude",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/updateLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    rkey = [[NSUserDefaults standardUserDefaults]stringForKey:@"rkey"];
    NSLog(@"update location, key %@", rkey);
    NSString* str_tmp = [NSString stringWithFormat:@"rkey=%@&latitude=%@&longitude=%@", rkey,[[NSNumber numberWithDouble:latitude] stringValue], [[NSNumber numberWithDouble:longitude]stringValue]];
    NSLog(@"%@",str_tmp);
    [request setHTTPBody:[str_tmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self loadDataWithRKey:rkey];
    }
}

/* For sending location data */
- (void)sendBackground:(NSTimer *)timer
{
    double time = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"lastUpdateLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[NSNumber numberWithDouble:latitude] stringValue],@"latitude",
                                [[NSNumber numberWithDouble:longitude]stringValue],@"longitude",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/updateLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    rkey = [[NSUserDefaults standardUserDefaults]stringForKey:@"rkey"];
    NSLog(@"update location, key %@", rkey);
    NSString* str_tmp = [NSString stringWithFormat:@"rkey=%@&latitude=%@&longitude=%@", rkey,[[NSNumber numberWithDouble:latitude] stringValue], [[NSNumber numberWithDouble:longitude]stringValue]];
    NSLog(@"%@",str_tmp);
    [request setHTTPBody:[str_tmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

}
/* For loading datas */

-(void)loadDataWithRKey:(NSString*) rkey
{
    [anno_list removeAllObjects];
    [self.myMapView removeAnnotations:myMapView.annotations];   // show all values
    if(rkey == nil){
        return;
    }
    //TODO, change it to load location
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://b.ucsdcssa.org/getLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"rkey=%@", rkey];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"load data");
    
    
    
    //NSData *receive;
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

/* Loading other users' location */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"mapview connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[responseData length]);
    [anno_list removeAllObjects];
    // convert to JSON
    NSError *myError = nil;
    NSLog(@"self response data, %@", responseData);
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    for(id key in res) {
        NSLog(@"mapview in loop");
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        
        
        double latitude;
        double longitude;
        if(valueAsString == [NSNull null]){
            continue;
        }
        //Check if it's the result
        if([keyAsString isEqualToString:@"result"]){
            NSArray*dic = (NSArray*)value;
            
            //Loop through all the data in the dictionary and put markers
            for(int i = 0; i < dic.count; i++){
                NSLog(@"zzzz%@", [[value objectAtIndex:i]objectForKey:@"name"]);
                //NSLog(@"latitude%@", [[value objectAtIndex:i]objectForKey:@"latitude"]);
                //NSLog(@"longitude%@", [[value objectAtIndex:i]objectForKey:@"longitude"]);
                //NSLog(@"avatar_url%@", [[value objectAtIndex:i]objectForKey:@"avatar_small"]);
                
                NSString* url =[[value objectAtIndex:i]objectForKey:@"avatar_small"];
                
                NSLog(@"%@", url);
                if([url isEqual:[NSNull null]]){
                    url = @"";
                    NSLog(@"is null");
                }
                
                CLLocationCoordinate2D tmp = CLLocationCoordinate2DMake([[[value objectAtIndex:i]objectForKey:@"latitude"] doubleValue],[[[value objectAtIndex:i]objectForKey:@"longitude"] doubleValue]);
                Annotation *place_anno = [[Annotation alloc]initWithTitle:[[value objectAtIndex:i]objectForKey:@"name"] Location:tmp image_url:url];
                [self.myMapView addAnnotation:place_anno];
                [anno_list addObject:place_anno];
                NSLog(@"anno list size %lu", (unsigned long)[anno_list count]);
            }
        }
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotation:(MKAnnotationView *)view{
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotation:(MKAnnotationView *)view{
    
}
-(void)setTimerInterval:(int) time_interval{
    timer = [NSTimer scheduledTimerWithTimeInterval:time_interval target:self selector:@selector(send:) userInfo:nil repeats:YES];
}
-(void)setUpdateLocation:(BOOL) updating{
    updateLocation = updating;
}


@end
