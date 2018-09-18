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

    [EYRouter openURL:@"mgj://beauty/def"
         withUserInfo:nil
           completion:^(id result){

           }];
}
- (BOOL)isLogin
{
    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //    NSArray * arr = [self pathComponentsFromURL:@"mgj://beauty/abc/edf?value=1&vlaue2=2"];

    id<LogicRedirecterProtocol> redi = (id<LogicRedirecterProtocol>)[[UserAuthRedirecter alloc] initWithLoginStateProvider:self];

    [EYRouter addLogicRedirecter:redi];


    [EYRouter registerURL:@"mgj://beauty/def?userOauth=1"
                 toHandle:^(NSDictionary *parameter) {

                   void (^completion)(id result) = parameter[EYRouterParameterCompletion];

                   if (completion) {
                       completion(self);
                   }

                 }];


    //    [EYRouter deregisterURL:@"mgj://beauty/def"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
