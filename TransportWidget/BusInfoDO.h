//
//  BusInfoDO.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 2. 23..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusInfoDO : NSObject

@property (strong, nonatomic) NSString *arrmsg1;           // 첫번째 버스 도착 시간
@property (strong, nonatomic) NSString *arrmsg2;           // 두번째 버스 도착 시간
@property (strong, nonatomic) NSString *rtNm;           // 버스 이름
@property (strong, nonatomic) NSString *stNm;           // 현재역

// 중요 알림 목록
+ (BusInfoDO *)setBusInfo:(NSDictionary *)DictionaryObject;
    
@end
