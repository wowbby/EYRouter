//
//  EYViewController.m
//  EYRouter
//
//  Created by wowbby on 09/18/2018.
//  Copyright (c) 2018 wowbby. All rights reserved.
//

#import "EYViewController.h"
#import "EYRouter.h"
#import "UserAuthRedirecter.h"
@interface EYViewController () <LoginStateProviderProtocol>

@end

@implementation EYViewController
- (IBAction)btnAction:(id)sender
{

    //    [EYRouter openURL:@"mgj://beauty/def?id=1&name=2"
    //         withUserInfo:@{}
    //           completion:^(id result){
    //
    //           }];

    //    [EYRouter openURL:@"mgj://beauty/def"
    //         withUserInfo:nil
    //           completion:^(id result){
    //
    //           }];

    [EYRouter openURL:@"EY://adb/edf"];
}
- (BOOL)isLogin
{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [EYRouter registerURL:@"EY://adb"
                 toHandle:^(NSDictionary *parameter){

                 }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
