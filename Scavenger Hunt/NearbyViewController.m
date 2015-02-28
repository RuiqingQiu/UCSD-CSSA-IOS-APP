//
//  NearbyViewController.m
//  CSSAMon
//
//  Created by Zhaoyang Zeng on 11/15/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "NearbyViewController.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController
@synthesize anno_list;
UITableView *tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView
{
    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    NSString* sectionTitle = @"";
    
    if (section == 0)
    {
        sectionTitle = @"Nearby";
    }
    
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 1;
    
    if (section == 0)
    {
        result = [anno_list count];
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //[[cell imageView] setImage:[UIImage imageNamed:@"Icon13.png"]];
    //[[cell textLabel] setText:[NSString stringWithFormat:@"%ld",(long)[indexPath row]]];
    [self updateCell:cell atIndexPath:indexPath];
     return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* pdfPhotoSize = (indexPath.row == 0) ? @"large" : @"half";
        [defaults setObject:pdfPhotoSize forKey:@"PDF_PHOTO_SIZE"];
        [defaults synchronize];
        
        UITableViewCell* cell;
        
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
}

#pragma mark - Private

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    NSString* pdfPhotoSize = [[NSUserDefaults standardUserDefaults] stringForKey:@"PDF_PHOTO_SIZE"];

    if (indexPath.section == 0)
    {
        Annotation* tmp =(Annotation*)[anno_list objectAtIndex:indexPath.row];
        cell.textLabel.text = tmp.title;
        cell.imageView.image = [tmp getImageFromURL:tmp.image_url];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = @"End";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
