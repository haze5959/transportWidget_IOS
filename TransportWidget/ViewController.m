//
//  ViewController.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 5..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//버스 정류장 찾기
- (IBAction)goFindBus:(UIButton *)sender {
    FindBusController *findBusController = [[FindBusController alloc] initWithNibName:@"FindBusController" bundle:nil];
    
    findBusController.view.frame = self.view.frame;
    [self.view addSubview:findBusController.view];
    [self addChildViewController:findBusController];
}


@end
