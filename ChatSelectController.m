//
//  ChatSelectController.m
//  CSSAMon
//
//  Created by Ruiqing Qiu on 2/7/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import "ChatSelectController.h"

@interface ChatSelectController()

@end
NSArray* chat_list;
@implementation ChatSelectController
@synthesize person_to;


UITableView *tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    chat_list = [[NSArray alloc] initWithObjects:@"= =!", @"约吗", @"你好", @"再见", nil];

    // Do any additional setup after loading the view.
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
        sectionTitle = @"Chat";
    }
    
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 8;
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
    //Send information
    if (indexPath.section == 0)
    {
        switch(indexPath.row+1){
            case 0:
                [TalkToServer sendChatWithReceiverId:person_to msg:0 PerrorString:nil];
                break;
            case 1:
                [TalkToServer sendChatWithReceiverId:person_to msg:1 PerrorString:nil];
                break;
            case 2:
                [TalkToServer sendChatWithReceiverId:person_to msg:2 PerrorString:nil];
                break;
            case 3:
                [TalkToServer sendChatWithReceiverId:person_to msg:3 PerrorString:nil];
                break;
            case 4:
                [TalkToServer sendChatWithReceiverId:person_to msg:4 PerrorString:nil];
                break;
            default:
                [TalkToServer sendChatWithReceiverId:person_to msg:5 PerrorString:nil];
                break;
        }

    }
    
}

#pragma mark - Private

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0){

        switch(indexPath.row){
            case 0:
                cell.textLabel.text = [chat_list objectAtIndex:0];
                break;
            case 1:
                cell.textLabel.text = [chat_list objectAtIndex:1];
                break;
            case 2:
                cell.textLabel.text = [chat_list objectAtIndex:2];
                break;

            case 3:
                cell.textLabel.text = [chat_list objectAtIndex:3];
                break;
            default:
                cell.textLabel.text = @"hello";
                break;
        }
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
