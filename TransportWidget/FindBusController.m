//
//  FindBusController.m
//  TransportWidget
//
//  Created by 권오규 on 2017. 1. 9..
//  Copyright © 2017년 권오규. All rights reserved.
//

#import "FindBusController.h"
#import "BusInfoCell.h"
#import "WidgetSelectPopUp.h"
#import "AppDelegate.h"

#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface FindBusController ()

@property NSString *searchNum;   //검색을 눌렀을 때의 해당 값
@property bool doGetItemList;  //아이템을 만났다면
@property bool doGetData;  //파싱할 때 데이터를 가져올지 말지
@property bool isParseLineEnd;  //파싱할 때 데이터를 가져올지 말지
@property NSMutableString* combineString;  //파싱된 문자열을 조합할 때 사용
@property NSMutableArray *array;
@property BusInfoDO *infoDO;    //한 버스의 정보들을 담을 곳
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation FindBusController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableDictionary *initDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"arrmsg1":@"",
                                                                    @"arrmsg2":@"",
                                                                    @"rtNm":@"정류장 번호를 입력하세요.",
                                                                    @"stNm":@""}];
    BusInfoDO *initDO = [BusInfoDO setBusInfo:initDic];
    self.array = [[NSMutableArray alloc]initWithObjects:initDO, nil];
    
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
    
    self.registBtn.enabled = NO;
    self.searchNum = self.inputText.text;
    
    NSString *path = [NSString stringWithFormat:@"http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?serviceKey=Hn1zrxA4VzEINy0sxFra88Pznz3ZZeKyvzHA3G5ikHFfeLG2VYUmpoYcZGZ0Pn3CcwsQXhaRUJM7qbYwbMakkA==&arsId=%@", self.searchNum];
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
        self.navBar.topItem.title = self.infoDO.stNm;
        self.infoDO = [BusInfoDO alloc];
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"파싱 끝!~");
    
    if ([self.array count] > 0) {
        self.registBtn.enabled = YES;
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

#pragma mark - 등록하기 버튼

- (IBAction)clickRegistBtn:(id)sender {
    //팝업창
    WidgetSelectPopUp *widgetSelectPopUp = [WidgetSelectPopUp viewController];
    widgetSelectPopUp.delegate = self;
    widgetSelectPopUp.view.frame = self.view.frame;
    [self.view addSubview:widgetSelectPopUp.view];
    [self addChildViewController:widgetSelectPopUp];
}

#pragma mark - 선택값 위젯에 저장시키기 위한 팝업

//저장 버튼 눌렀을 때
- (void) CheckBoxAlertPopUpViewControllerDidConfirmed:(WidgetSelectPopUp *)controller optionalDic:(NSDictionary *)optionalDic{
    NSLog(@"출퇴근 => %@", [optionalDic objectForKey:@"ComeAndGo"]);
    NSLog(@"북마크 => %@", [optionalDic objectForKey:@"BookMarkNum"]);
    NSString *saveInfo;
    
    //저장로직
    switch ([[optionalDic objectForKey:@"BookMarkNum"] intValue]) {
        case 1:
            if ([[optionalDic objectForKey:@"ComeAndGo"] isEqualToString:@"go"]) {
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM1_go"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 출근길 북마크1에 저장되었습니다.", self.searchNum];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM1_come"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 퇴근길 북마크1에 저장되었습니다.", self.searchNum];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"BM1_isBus"];
            
            break;
            
        case 2:
            if ([[optionalDic objectForKey:@"ComeAndGo"] isEqualToString:@"go"]) {
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM2_go"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 출근길 북마크2에 저장되었습니다.", self.searchNum];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM2_come"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 퇴근길 북마크2에 저장되었습니다.", self.searchNum];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"BM2_isBus"];
            
            break;
            
        case 3:
            if ([[optionalDic objectForKey:@"ComeAndGo"] isEqualToString:@"go"]) {
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM3_go"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 출근길 북마크3에 저장되었습니다.", self.searchNum];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM3_come"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 퇴근길 북마크3에 저장되었습니다.", self.searchNum];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"BM3_isBus"];
            
            break;
            
        case 4:
            if ([[optionalDic objectForKey:@"ComeAndGo"] isEqualToString:@"go"]) {
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM4_go"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 출근길 북마크4에 저장되었습니다.", self.searchNum];
            }else{
                [[NSUserDefaults standardUserDefaults] setValue:self.searchNum forKey:@"BM4_come"];
                saveInfo = [NSString stringWithFormat:@"[%@]가 퇴근길 북마크4에 저장되었습니다.", self.searchNum];
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"BM4_isBus"];
            
            break;
    }
    
    //토스트 뛰우기
    [APP_DELEGATE showToastMessage:saveInfo duration:2.0];
}

// 취소 버튼 눌렀을 때
- (void) CheckBoxAlertPopUpViewControllerDidClosed:(WidgetSelectPopUp *)controller{
}
@end
