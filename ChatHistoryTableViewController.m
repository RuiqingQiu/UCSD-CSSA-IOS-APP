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
    chat_list = [[NSArray alloc] initWithObjects:@"0", @"「蜀将何在」", @"「呃...!」", @"「约吗？」", @"「让我一个人静静」", @"(┛`д´)┛", @"(눈‸눈)", @"┳━┳ノ( ' - 'ノ) ", nil];
    //Msg range 1 to 8
    chat_history = [TalkToServer getChatWithPerrorString:nil];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
//    if(chat_history){
//        for(int i = 0; i < [chat_history count]; i++){
//            NSLog(@"to %@", [[chat_history objectAtIndex:i] objectForKey:@"to"]);
//            NSLog(@"from %@", [[chat_history objectAtIndex:i] objectForKey:@"from_name"]);
//            NSLog(@"time %@", [[chat_history objectAtIndex:i] objectForKey:@"time"]);
//            NSLog(@"msg %@", [[chat_history objectAtIndex:i] objectForKey:@"msg"]);
//        }
//        NSLog([[chat_history objectAtIndex:0] objectForKey:@"from"]);
//    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(chat_history){
        NSLog(@"number of rows: %lu", (unsigned long)[chat_history count]);
        //Add one because of the segue padding
        return [chat_history count]+1;
    }
    else{
        return 0;
    }
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}



// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        //Need to remove the data from the server and then reload the data
        //[tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatHistoryTable"];
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatHistoryTable"];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"ChatHistoryTable"];
    }
    if(indexPath.row == 0){
    
    }
    else{
        if([chat_history count] != 0){
            if([[[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"msg"] intValue] >= [chat_list count]){
                
            }
            else{
                NSString *str1 = @"【";
                NSString *str2 = @"】对你说：";
                NSString *str = [NSString stringWithFormat: @"%@%@%@%@", str1, [[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"from_name"], str2, [chat_list objectAtIndex: [[[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"msg"] intValue]]];
                //[] 对【】说：
                cell.imageView.image = [self getImageFromURL:[[chat_history objectAtIndex:indexPath.row-1]  objectForKey:@"from_avatar"]];
                cell.textLabel.text = str;
                cell.detailTextLabel.text = [[chat_history objectAtIndex:indexPath.row-1] objectForKey:@"time"];
                cell.detailTextLabel.textColor = [UIColor grayColor];
                [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
            }
        }
    }
    return cell;
}


@end
