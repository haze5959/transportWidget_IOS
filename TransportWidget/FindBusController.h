//
//  FindBusController.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 9..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindBusController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *inputText;

@end
