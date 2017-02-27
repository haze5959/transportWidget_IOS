//
//  BusInfoCell.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 2. 23..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "BusInfoCell.h"

@implementation BusInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (BusInfoCell*)cell{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BusInfoCell" owner:self options:nil];
    BusInfoCell *cell = [nibs objectAtIndex:0];
    
    return cell;
}

- (void)setUIWihtDeviceData:(BusInfoDO*)dataObject{

    self.rtNm.text = dataObject.rtNm;
    self.arrmsg1.text = dataObject.arrmsg1;
    self.arrmsg2.text = dataObject.arrmsg2;
}

@end
