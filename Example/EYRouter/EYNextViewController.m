//
//  EYNextViewController.m
//  EYRouter_Example
//
//  Created by 郑振兴 on 2018/9/19.
//  Copyright © 2018年 wowbby. All rights reserved.
//

#import "EYNextViewController.h"
#import <EYRouter/EYRouter.h>
@interface EYNextViewController ()

@end

@implementation EYNextViewController
+ (void)load
{
    [EYRouter registerURL:@"EY://nextViewController?userOauth=1"
           toObjectHandle:^id(NSDictionary *parameter) {

             return [EYNextViewController new];
           }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.redColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
