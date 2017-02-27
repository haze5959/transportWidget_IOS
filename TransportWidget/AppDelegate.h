//
//  AppDelegate.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 5..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)showToastMessage:(NSString *)message            // 토스트 팝업 시간을 임의로 조정할 경우
                duration:(float)duration;


@end

