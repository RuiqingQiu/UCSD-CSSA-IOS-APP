//
//  UIViewController+MapViewController.m
//  Scavenger Hunt
//
//  Created by Ruiqing Qiu on 10/18/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//
#import "MapViewController.h"
#import "Annotation.h"
@interface MapViewController ()
-(void)tapRight;
-(void)tapLeft;
@end
@implementation MapViewController
@synthesize myMapView;
@synthesize locationManager;

double latitude, longtitude;

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
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    //初始化一个地图
    [self.view addSubview:self.myMapView];
    
    //设置经度纬度
    MKCoordinateRegion region;
    region.center.latitude=32.8664011;
    region.center.longitude=-117.2233901;
    //设置显示范围
    region.span.latitudeDelta=0.1;
    region.span.longitudeDelta=0.1;
    //指定代理
    
    self.myMapView.delegate=self;
    
    //
    self.myMapView.showsUserLocation=YES;
    self.myMapView.region=region;
    
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(33, -117);
    Annotation *place_anno = [[Annotation alloc]initWithTitle:@"Hello" Location:place];
    [self.myMapView addAnnotation:place_anno];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation *location=userLocation.location;
    latitude = location.coordinate.latitude;
    longtitude = location.coordinate.longitude;
    CLLocationCoordinate2D center=location.coordinate;
    [self.myMapView setCenterCoordinate:center animated:YES];
    
    //建立一个遵守协议的类 作为中介
    Annotation *anno=[[Annotation alloc]init];
    //大头针的信息
    anno.title=@"title";
    anno.subtitle=@"subtitle";
    //大头针的位置
    anno.coordinate=center;
    
    [self.myMapView addAnnotation:anno];
    
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
    
    // pinView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
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
            [mapView selectAnnotation:pinView.annotation animated:YES];
            //枚举立即停止 *stop
            //*stop=YES;
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
    self.responseData = [NSMutableData data];
    [super viewWillAppear:animated];
    id obj = [[NSUserDefaults standardUserDefaults]objectForKey:@"rkey"];
    NSString* str = (NSString*)obj;
    NSLog(@"key %@", str);
    [self loadDataWithRKey:str];
}


/* For sending location data */
- (IBAction)save:(id)sender;
{
    double time = [[NSDate date] timeIntervalSince1970];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [[NSNumber numberWithDouble:latitude] stringValue],@"latitude",
                                [[NSNumber numberWithDouble:longtitude]stringValue],@"longtitude",
                                nil];
    NSLog(@"%@",dictionary);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/setLocation.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    NSString* str = [NSString stringWithFormat:@"latitude=%@&longtitude=%@", [[NSNumber numberWithDouble:latitude] stringValue], [[NSNumber numberWithDouble:longtitude]stringValue]];
    NSLog(@"%@",str);
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
}
/* For loading datas */

-(void)loadDataWithRKey:(NSString*) rkey
{
    if(rkey == nil){
        return;
    }
    //TODO, change it to load location
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://c.zinsser.me/getProfile.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* str = [NSString stringWithFormat:@"rkey=%@&profile_id=0", rkey];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
        
        
        double latitude;
        double longtitude;
        if(valueAsString == [NSNull null]){
            continue;
        }
        if([keyAsString isEqualToString:@"latitude"]){
            latitude = [valueAsString doubleValue];
        }
        if([keyAsString isEqualToString:@"longtitude"]){
            longtitude = [valueAsString doubleValue];
        }
        //Create an annotation at the place and add it to the map
        CLLocationCoordinate2D tmp = CLLocationCoordinate2DMake(latitude, longtitude);
        Annotation *place_anno = [[Annotation alloc]initWithTitle:@"Hello" Location:tmp];
        [self.myMapView addAnnotation:place_anno];
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
}


@end
