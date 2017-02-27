//
//  FindStationController.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 2. 24..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindStationController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *inputText;

@end
