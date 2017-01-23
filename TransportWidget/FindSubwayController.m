//
//  FindSubwayController.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 20..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "FindSubwayController.h"

@interface FindSubwayController ()
@property NSMutableArray *array;
@end

@implementation FindSubwayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 테이블

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}


@end
