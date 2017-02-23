//
//  BusInfoDO.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 2. 23..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "BusInfoDO.h"

@implementation BusInfoDO

+ (BusInfoDO *)setBusInfo:(NSDictionary *)DictionaryObject{
    
    BusInfoDO *dataObject = [BusInfoDO alloc];
    
    dataObject.arrmsg1 = [DictionaryObject objectForKey:@"arrmsg1"];
    dataObject.arrmsg2 = [DictionaryObject objectForKey:@"arrmsg2"];
    dataObject.rtNm = [DictionaryObject objectForKey:@"rtNm"];
    dataObject.stNm = [DictionaryObject objectForKey:@"stNm"];
    
    return dataObject;
}

@end
