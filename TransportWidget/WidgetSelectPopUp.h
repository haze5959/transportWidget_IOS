//
//  WidgetSelectPopUp.h
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 20..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WidgetSelectPopUp : UIViewController

@property (assign, nonatomic) id delegate;

//생성자
+ (WidgetSelectPopUp *)viewController;
//- (void) setData:(NSString *)saveNum isBus:(NSString *)isBus;

@end

@protocol WidgetSelectPopUpDelegate <NSObject>

@required

// 확인
- (void) CheckBoxAlertPopUpViewControllerDidConfirmed:(WidgetSelectPopUp *)controller optionalDic:(NSDictionary *)optionalDic;

// 취소
- (void) CheckBoxAlertPopUpViewControllerDidClosed:(WidgetSelectPopUp *)controller;

@end

