//
//  WidgetSelectPopUp.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 20..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "WidgetSelectPopUp.h"

@interface WidgetSelectPopUp ()

//확인 버튼 눌렀을 때 전달할 값
@property (strong, nonatomic) NSDictionary *optionalDic;

@end

@implementation WidgetSelectPopUp

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.optionalDic = @{@"ComeAndGo" : @"go",
                         @"BookMarkNum" : @"1"};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SetUI

-(void) setUI{
}

#pragma mark - init

+ (WidgetSelectPopUp *)viewController {
    
    WidgetSelectPopUp *viewController = [[WidgetSelectPopUp alloc] initWithNibName:@"WidgetSelectPopUp" bundle:nil];
    return viewController;
}

//출근퇴근 세그먼트
- (IBAction)clickComeAndGo:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0){       //출근
        [self.optionalDic setValue:@"go" forKey:@"ComeAndGo"];
    }
    else if(sender.selectedSegmentIndex == 1){  //퇴근
        [self.optionalDic setValue:@"come" forKey:@"ComeAndGo"];
    }
}

//북마크 세그먼트
- (IBAction)clickBookMark:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex == 0){       //북마크1
        [self.optionalDic setValue:@"1" forKey:@"BookMarkNum"];
    }
    else if(sender.selectedSegmentIndex == 1){  //북마크2
        [self.optionalDic setValue:@"2" forKey:@"BookMarkNum"];
    }
    else if(sender.selectedSegmentIndex == 2){  //북마크3
        [self.optionalDic setValue:@"3" forKey:@"BookMarkNum"];
    }
    else if(sender.selectedSegmentIndex == 3){  //북마크4
        [self.optionalDic setValue:@"4" forKey:@"BookMarkNum"];
    }
}

// 확인 버튼 이벤트
- (IBAction)onConfirmButtonTouched:(id)sender {
    
    [self popUpClose];
    
    if (self.delegate) {
        [self.delegate CheckBoxAlertPopUpViewControllerDidConfirmed:self
                                                        optionalDic:self.optionalDic];
    }
}

// 취소 버튼 이벤트
- (IBAction)onCloseButtonTouched:(id)sender {
    [self popUpClose];
    
    if (self.delegate) {
        [self.delegate CheckBoxAlertPopUpViewControllerDidClosed:self];
    }
}

- (void)popUpClose {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
