//
//  FindBusController.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 9..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "FindBusController.h"

@interface FindBusController ()

@property NSMutableArray *array;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation FindBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [[NSMutableArray alloc]initWithArray: @[@"정류소 고유번호를 검색하세요!"]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//뒤로가기
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    NSLog(@"뒤로가기 클릭");
    [self.view removeFromSuperview];
}

#pragma mark - 검색

//외부화면을 눌렀을 때 키보드를 없엔다.
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"OQ - touch the screen");
    [self.view endEditing:YES];
    [self.inputText resignFirstResponder];
}

//정류소 찾기
- (IBAction)findBus:(UIButton *)sender {
    NSLog(@"OQ - find the bus Station");
    
    NSString *path = [NSString stringWithFormat:@"http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?serviceKey=Hn1zrxA4VzEINy0sxFra88Pznz3ZZeKyvzHA3G5ikHFfeLG2VYUmpoYcZGZ0Pn3CcwsQXhaRUJM7qbYwbMakkA==&arsId=%@", @"19234"];
    NSString *escapedPath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10
     ];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"응답 받았다");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"데이터도 받았다 => %lu bytes of data", (unsigned long)[data length]);
    
    self.responseData = [[NSMutableData alloc] init];
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"실패!!!!");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"로딩 끝");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
//    NSError *myError = nil;
//    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
//    
//    NSArray *row = res[@"IndividuallyPostedLandPriceService"][@"row"];
//    
//    NSMutableString *valueResult = [[NSMutableString alloc] initWithFormat:@"%@ 땅값 리스트\n\n", @"임시"];
//    
//    for(NSString *key in row) {
//        NSDictionary *valueDictionary = (NSDictionary *)key;
//        
//        id value = [valueDictionary objectForKey:@"BONBEON"];
//        NSString *valueAsString = (NSString *)value;
//        NSLog(@"본번: %@", valueAsString);
//        [valueResult appendFormat:@"본번: %@ \n", valueAsString];
//        
//        value = [valueDictionary objectForKey:@"BUBEON"];
//        valueAsString = (NSString *)value;
//        NSLog(@"부번: %@", valueAsString);
//        [valueResult appendFormat:@"부번: %@ \n", valueAsString];
//        
//        value = [valueDictionary objectForKey:@"PILGI_NM"];
//        valueAsString = (NSString *)value;
//        NSLog(@"필지구분명: %@", valueAsString);
//        [valueResult appendFormat:@"필지구분명: %@ \n", valueAsString];
//        
//        value = [valueDictionary objectForKey:@"BASE_MON"];
//        valueAsString = (NSString *)value;
//        NSLog(@"기준 년월일: %@", valueAsString);
//        [valueResult appendFormat:@"기준 년월일: %@ \n", valueAsString];
//        
//        value = [valueDictionary objectForKey:@"JIGA"];
//        valueAsString = (NSString *)value;
//        NSLog(@"지가: %@", valueAsString);
//        [valueResult appendFormat:@"지가: %@ \n", valueAsString];
//        
//        [valueResult appendFormat:@"===========================\n"];
//    }
}


#pragma mark - 테이블

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}


@end
