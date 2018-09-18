//
//  EYViewController.m
//  EYRouter
//
//  Created by wowbby on 09/18/2018.
//  Copyright (c) 2018 wowbby. All rights reserved.
//

#import "EYViewController.h"
#import <EYRouter/EYRouter.h>
@interface EYViewController ()

@end

@implementation EYViewController
- (IBAction)btnAction:(id)sender
{

    //    [EYRouter openURL:@"mgj://beauty/def?id=1&name=2"
    //         withUserInfo:@{}
    //           completion:^(id result){
    //
    //           }];

    id obj = [EYRouter objectForURL:@"obj://test" userInfo:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //    NSArray * arr = [self pathComponentsFromURL:@"mgj://beauty/abc/edf?value=1&vlaue2=2"];


    [EYRouter registerURL:@"mgj://beauty/def?id&name"
                 toHandle:^(NSDictionary *parameter) {

                   void (^completion)(id result) = parameter[EYRouterParameterCompletion];

                   if (completion) {
                       completion(self);
                   }

                 }];

    [EYRouter registerURL:@"obj://test"
           toObjectHandle:^id(NSDictionary *parameter) {

             return @(1);
           }];

    //    [EYRouter deregisterURL:@"mgj://beauty/def"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
