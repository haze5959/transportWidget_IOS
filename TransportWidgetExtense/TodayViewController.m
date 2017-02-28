//
//  TodayViewController.m
//  TransportWidgetExtense
//
//  Created by 권오규 on 2017. 1. 9..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "BusInfoCell.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) NSMutableData *responseData;
@property NSMutableArray *array;
@property BusInfoDO *infoDO;    //한 버스의 정보들을 담을 곳
@property bool isParseLineEnd;  //파싱할 때 데이터를 가져올지 말지
@property bool doGetItemList;  //아이템을 만났다면
@property bool doGetData;  //파싱할 때 데이터를 가져올지 말지
@property NSMutableString* combineString;  //파싱된 문자열을 조합할 때 사용

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *initDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"arrmsg1":@"",
                                                                                    @"arrmsg2":@"",
                                                                                    @"rtNm":@"정류장 번호를 입력하세요.",
                                                                                    @"stNm":@""}];
    BusInfoDO *initDO = [BusInfoDO setBusInfo:initDic];
    self.array = [[NSMutableArray alloc]initWithObjects:initDO, nil];
    
    [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    [self.extensionContext setWidgetLargestAvailableDisplayMode:NCWidgetDisplayModeExpanded];
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
    else{
        
        self.preferredContentSize = CGSizeMake(0, ([self.array count] * 60) + 132);
        //self.preferredContentSize = self.tableView.contentSize;
        NSLog(@"난다고래");
        [self findBus];
    }
}

#pragma mark - xml 파싱하고 테이블에 넣기까지...

//정류소 찾기
- (void)findBus{
    NSLog(@"OQ - find the bus Station");
    
    NSString *path = [NSString stringWithFormat:@"http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?serviceKey=Hn1zrxA4VzEINy0sxFra88Pznz3ZZeKyvzHA3G5ikHFfeLG2VYUmpoYcZGZ0Pn3CcwsQXhaRUJM7qbYwbMakkA==&arsId=%@", @"19132"];
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
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"데이터도 받았다 => %lu bytes of data", (unsigned long)[data length]);
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"실패!!!!");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"로딩 끝");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    //해석 시작!
    //NSString *dataToString = [[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding];
    NSXMLParser *xmlData = [[NSXMLParser alloc] initWithData:self.responseData];
    xmlData.delegate = self;
    [self.array removeAllObjects];  //모든 입력값을 지우고 값을 받아들일 준비를 한다.
    self.infoDO = [BusInfoDO alloc];
    if ([xmlData parse]) {
        NSLog(@"파싱 가능!!");
        [self.tableView reloadData];
    }else{
        NSLog(@"파싱 불가능...");
    }
    
}
#pragma mark - xml 파싱 델리게이트
-(void) parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"파싱 시작!~");
    self.isParseLineEnd = YES;
}

-(void) parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if (self.doGetItemList) {
        
        if ([elementName isEqualToString:@"arrmsg1"]){//첫번째 버스 도착 시간
            self.doGetData = YES;
        }else if ([elementName isEqualToString:@"arrmsg2"]){//두번째 버스 도착 시간
            self.doGetData = YES;
        }else if ([elementName isEqualToString:@"rtNm"]){//해당 버스 번호
            self.doGetData = YES;
        }else if ([elementName isEqualToString:@"stNm"]){//현재역
            self.doGetData = YES;
        }
        
        self.isParseLineEnd = NO;
        self.combineString = [[NSMutableString alloc] initWithString:@""];    //초기화
    }else{
        if ([elementName isEqualToString:@"itemList"]) {
            self.doGetItemList = YES;
            NSLog(@"=================================");
        }
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string{
    
    if (self.doGetData) {
        [self.combineString appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if (self.doGetData) {
        NSLog(@"결과는 => %@", self.combineString );
        self.doGetData = NO;
        
        if ([elementName isEqualToString:@"arrmsg1"]){//첫번째 버스 도착 시간
            self.infoDO.arrmsg1 = [NSString stringWithFormat:@"- %@", self.combineString];
        }else if ([elementName isEqualToString:@"arrmsg2"]){//두번째 버스 도착 시간
            self.infoDO.arrmsg2 = [NSString stringWithFormat:@"- %@", self.combineString];
        }else if ([elementName isEqualToString:@"rtNm"]){//해당 버스 번호
            self.infoDO.rtNm = self.combineString;
        }else if ([elementName isEqualToString:@"stNm"]){//현재역
            self.infoDO.stNm = self.combineString;
        }
    }
    
    self.isParseLineEnd = YES;
    
    if ([elementName isEqualToString:@"itemList"]) {
        self.doGetItemList = NO;
        NSLog(@"=================================");
        [self.array addObject:self.infoDO];
        //self.navBar.topItem.title = self.infoDO.stNm; //써먹을거임
        self.infoDO = [BusInfoDO alloc];
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"파싱 끝!~");
    
    if ([self.array count] > 0) {
        //검색 됨
    }else{
        self.infoDO.rtNm = @"검색되지 않는 번호 입니다.";
        [self.array addObject:self.infoDO];
    }
}

#pragma mark - 테이블

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BusInfoCell";
    BusInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [BusInfoCell cell];
    }
    BusInfoDO *busInfo = [self.array objectAtIndex:indexPath.row];
    [cell setUIWihtDeviceData:busInfo];
    return cell;
}

-(CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    
    return 60.0f;
}



/*
 버스 정류장 찾아서 로컬 데이터에 저장
 버스 정류장 로컬 데이터 불러오기 확인
 버스 실시간 정보 구현
 
 그담에 지하철도 구현
 */


@end
