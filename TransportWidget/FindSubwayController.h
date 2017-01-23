//
//  FindSubwayController.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 20..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindSubwayController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *inputText;

@end
