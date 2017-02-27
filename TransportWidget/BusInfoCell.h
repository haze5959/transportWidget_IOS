//
//  BusInfoCell.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 2. 23..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusInfoDO.h"

@interface BusInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rtNm;
@property (weak, nonatomic) IBOutlet UILabel *arrmsg1;
@property (weak, nonatomic) IBOutlet UILabel *arrmsg2;


+ (BusInfoCell*)cell;
- (void)setUIWihtDeviceData:(BusInfoDO*)dataObject;

@end
