//
//  AutoRedirecter.m
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import "AutoRedirecter.h"

@interface AutoRedirecter ()
@property (nonatomic, strong) NSMutableArray<id<LogicRedirecterProtocol>> *redirecters;
@end

@implementation AutoRedirecter
- (NSArray<id<LogicRedirecterProtocol>> *)redirecters
{
    if (!_redirecters) {
        _redirecters = ({
            [@[] mutableCopy];
        });
    }
    return _redirecters;
}
- (void)addRedirecter:(id<LogicRedirecterProtocol>)redirecter
{
    if (!redirecter) {
        return;
    }
    NSArray *names = [self.redirecters valueForKeyPath:@"name"];
    if ([names containsObject:redirecter.name]) {
        return;
    }
    [self.redirecters addObject:redirecter];
}
- (NSString *)autoDirecterURL:(NSString *)url registerParameters:(NSDictionary<NSString *, NSString *> *)parameters
{

    NSString *targetURL = url;
    for (id<LogicRedirecterProtocol> logicRedirecter in self.redirecters) {
        if ([logicRedirecter isNeedRedirectURL:parameters]) {
            targetURL = [logicRedirecter redirectURL:url];
            continue;
        }
    }
    return targetURL;
}

@end
