//
//  ViewController.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 20/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "ViewController.h"
#import "DropMenu.h"
#import "HostView.h"


@interface ViewController ()
@property (nonatomic) DropMenu *menuView;
@property (nonatomic) HostView *host;

@property (nonatomic, strong) NSMutableArray * arrData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawTheBtns];
    [self designTheScrView];
    
}

- (void)drawTheBtns
{
    
    NSArray *btnArray = @[@{
                                @"btnTitle":@"Switch",
                                @"action" : @"switchAction:"
                            },
                          @{
                              @"btnTitle":@"Refresh",
                              @"action" : @"refreshView:"
                            }
                          ];
    
    [btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        UIButton *btnToAdd = [[UIButton alloc] initWithFrame:CGRectMake((250+30) * idx + 30, 30, 250, 40)];
        [btnToAdd setBackgroundColor:[UIColor darkGrayColor]];
        [btnToAdd setTitle:obj[@"btnTitle"] forState:UIControlStateNormal];
        [btnToAdd addTarget:self action:NSSelectorFromString(obj[@"action"]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnToAdd];
    }];
}

- (void)refreshView:(id)obj
{
    NSMutableArray *yAxisValueArray =[NSMutableArray array];
    NSMutableArray *xAxisValueArray =[NSMutableArray array];
    switch (_host.typeOfGraph) {
        case graphTypeBar:
        {
//            Here the array contains plain data , since the number of bars per X axis coordinate is currently one. Working on multiple bars.
            NSInteger countOfY = [self randomNumberWithMin:1 WithMax:13];
            
            for (NSInteger i = 0; i<countOfY; i++)
            {
                [yAxisValueArray addObject:[NSNumber numberWithInt:[self randomNumberWithMin:100000 WithMax:999999]]];
            }
            
            NSArray *monthArray =@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12];
            xAxisValueArray = [monthArray mutableCopy];
        }
            break;
            
        case graphTypeLine:
        {
//          Here the array contains dictionaries equal to the numberOfLines. Each dictionary has a key 'Y' which means nth line's y coordinates and it represents the array of Y axis coordinates to be ploted.
            for (NSInteger i = 0; i<2; i++)
            {
                NSInteger countOfY = [self randomNumberWithMin:12 WithMax:32];
                NSMutableArray *yArray = [NSMutableArray array];
                for (NSInteger j = 0; j<countOfY; j++)
                {
                    [yArray addObject:[NSNumber numberWithInt:[self randomNumberWithMin:100000 WithMax:999999]]];
                }
                [yAxisValueArray addObject:@{@"Y":yArray}];
            }
            for (NSInteger d = 1; d<=31; d++)
            {
                [xAxisValueArray addObject:[NSNumber numberWithInteger:d]];
            }
        }
            break;
    }
   
    [_host setXArray:xAxisValueArray];
    [_host setYArray:yAxisValueArray];
    [_host drawTheGraph];
}

- (void)switchAction:(UIButton *)btn
{

    [_host setTypeOfGraph:(_host.typeOfGraph==graphTypeBar)?graphTypeLine:graphTypeBar];
    [_host setLinePArray:@[
                           @{
                             @"isDashed":@NO,
                             @"lineType":[NSNumber numberWithInteger:lineTypeCurrent]
                             },
                           @{
                             @"isDashed":@YES,
                              @"lineType":[NSNumber numberWithInteger:lineTypeProjected]
                             }]];
    [self refreshView:nil];
}
- (void)designTheScrView
{
    _host = [[HostView alloc] initWithFrame:CGRectMake(10, 150, [[UIScreen mainScreen]bounds].size.width-50, [[UIScreen mainScreen]bounds].size.height-225)];
//    [_host setBackgroundColor:[UIColor whiteColor]];
    [_host setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.2]];
    [_host setNumOfyDivs:10];
    [self.view addSubview:_host];
}
-(void)tappedAtBar:(NSDictionary *)tappedData
{
    NSLog(@" tappedData is %@",tappedData);
}
- (int)randomNumberWithMin:(int)min WithMax:(int)max {
    if (min>max) {
        int tempMax=max;
        max=min;
        min=tempMax;
    }
    int randomy=arc4random() % (max-min+1);
    randomy=randomy+min;
    return randomy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
