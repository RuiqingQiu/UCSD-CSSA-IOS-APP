//
//  UIViewController+MapViewController.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import "MapViewController.h"
#import "Annotation.h"

#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface MapViewController ()
-(void)tapRight;
-(void)tapLeft;
@end
@implementation MapViewController
@synthesize myMapView;
@synthesize locationManager;

UIApplication *app;

double latitude, longitude;
NSString* str;
BOOL locationStarted = FALSE;
NSString *rkey;

//Timer for update
NSTimer *timer;

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
//与tableViewCell一样
//在[self.myMapView addAnnotation:anno];后， 会马上调用这个协议中的方法 返回一个MKAnnotationView供地图显示
//注意：在地图本身去添加用户位置的时候（小蓝点）也会调用这个方法

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
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:@"rkey"];
    str = (NSString*)obj;
    rkey = (NSString*)obj;
    NSLog(@"key %@", str);
    [self loadDataWithRKey:str];
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(send:) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[locationManager stopUpdatingLocation];
    if ([timer isValid]){
        // the timer is valid and running, how about invalidating it
        [timer invalidate];
        timer = nil;
    }
}


/* For sending location data */
- (void)send:(NSTimer *)timer
{
    double time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[NSNumber numberWithDouble:latitude] stringValue],@"latitude",
                                [[NSNumber numberWithDouble:longitude]stringValue],@"longitude",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/updateLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:@"rkey"];
    NSString* rkey = (NSString*)obj;
    NSLog(@"update location, key %@", rkey);
    NSString* str_tmp = [NSString stringWithFormat:@"rkey=%@&latitude=%@&longitude=%@", rkey,[[NSNumber numberWithDouble:latitude] stringValue], [[NSNumber numberWithDouble:longitude]stringValue]];
    NSLog(@"%@",str_tmp);
    [request setHTTPBody:[str_tmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self loadDataWithRKey:str];
}


-(void)sendLocationBackground{
    double time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[NSNumber numberWithDouble:latitude] stringValue],@"latitude",
                                [[NSNumber numberWithDouble:longitude]stringValue],@"longitude",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/updateLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    NSLog(@"update location, key %@", rkey);
    NSString* str_tmp = [NSString stringWithFormat:@"rkey=%@&latitude=%@&longitude=%@", rkey,[[NSNumber numberWithDouble:latitude] stringValue], [[NSNumber numberWithDouble:longitude]stringValue]];
    NSLog(@"%@",str_tmp);
    [request setHTTPBody:[str_tmp dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self loadDataWithRKey:str];

}

/* For loading datas */

-(void)loadDataWithRKey:(NSString*) rkey
{
    [self.myMapView removeAnnotations:myMapView.annotations];   // show all values
    if(rkey == nil){
        return;
    }
    //TODO, change it to load location
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/getLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
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
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    for(id key in res) {
        NSLog(@"in loop");
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
                NSLog(@"latitude%@", [[value objectAtIndex:i]objectForKey:@"latitude"]);
                NSLog(@"longitude%@", [[value objectAtIndex:i]objectForKey:@"longitude"]);
                NSLog(@"avatar_url%@", [[value objectAtIndex:i]objectForKey:@"avatar_small"]);
                
                NSString* url =[[value objectAtIndex:i]objectForKey:@"avatar_small"];
                
                NSLog(@"%@", url);
                if([url isEqual:[NSNull null]]){
                    url = @"";
                    NSLog(@"is null");
                }
                
                CLLocationCoordinate2D tmp = CLLocationCoordinate2DMake([[[value objectAtIndex:i]objectForKey:@"latitude"] doubleValue],[[[value objectAtIndex:i]objectForKey:@"longitude"] doubleValue]
);
                Annotation *place_anno = [[Annotation alloc]initWithTitle:[[value objectAtIndex:i]objectForKey:@"name"] Location:tmp image_url:url];
                [self.myMapView addAnnotation:place_anno];
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


//run background task
-(void)runBackgroundTask: (int) time{
    
    UIApplication * application = [UIApplication sharedApplication];
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        NSLog(@"Multitasking Supported");
        
        __block UIBackgroundTaskIdentifier background_task;
        background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
        
        //To make the code block asynchronous
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //### background task starts
            NSLog(@"Running in the background\n");
            while(TRUE)
            {
                NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
                [NSThread sleepForTimeInterval:1]; //wait for 1 sec
            }
            //#### background task ends
            
            //Clean up code. Tell the system that we are done.
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid; 
        });
    }
    else
    {
        NSLog(@"Multitasking Not Supported");
    }
/*
    
    //check if application is in background mode
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        
        //create UIBackgroundTaskIdentifier and create tackground task, which starts after time
        __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        }];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self send:timer];
            NSLog(@"background");
            NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(startTrackingBg) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        });
        
    }*/
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"enter background");
}


//starts when application switchs into backghround
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"enter background");
    //check if application status is in background
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"start backgroun tracking from appdelegate");
        
        //start updating location with location manager
        [locationManager startUpdatingLocation];
    }
    //change locationManager status after time
    [self runBackgroundTask:10];
}

//starts with background task
-(void)startTrackingBg{
    //write background time remaining
    NSLog(@"backgroundTimeRemaining: %.0f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
    //set default time
    int time = 10;
    
    [self runBackgroundTask:time];
}

/*
//application switchs back from background
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    locationStarted = FALSE;
    //stop updating
    [locationManager stopUpdatingLocation];
}
*/



@end
