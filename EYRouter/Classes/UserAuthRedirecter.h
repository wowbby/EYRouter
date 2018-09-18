//
//  UserAuthRedirecter.h
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import <Foundation/Foundation.h>
#import "LogicRedirecterProtocol.h"
#import "LoginStateProviderProtocol.h"
@interface UserAuthRedirecter : NSObject
- (instancetype)initWithLoginStateProvider:(id<LoginStateProviderProtocol>)provider NS_DESIGNATED_INITIALIZER;
@end
