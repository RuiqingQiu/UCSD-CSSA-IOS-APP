//
//  ChatHistoryTableViewController.m
//  CSSAMon
//
//  Created by Ruiqing Qiu on 2/28/15.
//  Copyright (c) 2015 Ruiqing Qiu. All rights reserved.
//

#import "ChatHistoryTableViewController.h"


NSArray* chat_list;
NSArray* chat_history;
@implementation ChatHistoryTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    chat_list = [[NSArray alloc] initWithObjects:@"0", @"= =!", @"约吗", @"你好", @"再见", @"5", @"6", @"7", @"8", @"9", nil];
    //Msg range 1 to 8
    chat_history = [TalkToServer getChatWithPerrorString:nil];
    
    for(int i = 0; i < [chat_history count]; i++){
        NSLog(@"to %@", [[chat_history objectAtIndex:i] objectForKey:@"to"]);
        NSLog(@"from %@", [[chat_history objectAtIndex:i] objectForKey:@"from_name"]);
        NSLog(@"time %@", [[chat_history objectAtIndex:i] objectForKey:@"time"]);
        NSLog(@"msg %@", [[chat_history objectAtIndex:i] objectForKey:@"msg"]);
    }
    NSLog([[chat_history objectAtIndex:0] objectForKey:@"from"]);
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of rows: %lu", (unsigned long)[chat_history count]);
    //Add one because of the segue padding
    return [chat_history count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatHistoryTable"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatHistoryTable"];
    }
    if(indexPath.row == 0){
    
    }
    else{
        NSString *str1 = @"【";
        NSString *str2 = @"】对你说：";
        NSString *str = [NSString stringWithFormat: @"%@%@%@%@", str1, [[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"from_name"], str2, [chat_list objectAtIndex: [[[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"msg"] intValue]]];
        //[] 对【】说：
        cell.textLabel.text = str;
    }
    return cell;
}


@end
