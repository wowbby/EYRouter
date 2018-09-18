//
//  UserAuthRedirecter.m
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import "UserAuthRedirecter.h"

static NSString *const koauthParameterKey = @"userOauth";
static NSString *const koathParameterValueKey = @"1";

@interface UserAuthRedirecter () <LogicRedirecterProtocol>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) id<LoginStateProviderProtocol> provider;
@property (nonatomic, strong) NSString *oathURL;
@end

@implementation UserAuthRedirecter
- (instancetype)init
{
    return [self initWithLoginStateProvider:nil];
}
- (instancetype)initWithLoginStateProvider:(id<LoginStateProviderProtocol>)provider
{
    if (self = [super init]) {

        self.provider = provider;
    }
    return self;
}
- (NSString *)name
{

    return @"UserAuthRedirecter";
}
- (NSInteger)level
{

    return 10;
}

- (BOOL)isNeedRedirectURL:(NSDictionary<NSString *, NSString *> *)registerParameters
{
    if (!self.provider) {
        return NO;
    }
    if (self.provider.isLogin) {

        return NO;
    }
    NSString *parameter = registerParameters[koauthParameterKey];
    BOOL isLogin = [self.provider isLogin];
    if (parameter && [parameter isEqualToString:koathParameterValueKey] && !isLogin) {

        return YES;
    }
    return NO;
}

- (NSString *)redirectURL:(NSString *)url
{

    return @"oath://login";
}

@end
