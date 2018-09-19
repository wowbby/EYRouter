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
    [self sortRedirecters];
}
- (NSString *)autoDirecterURL:(NSString *)url registerParameters:(NSDictionary<NSString *, NSString *> *)parameters
{
    for (id<LogicRedirecterProtocol> logicRedirecter in self.redirecters) {
        if ([logicRedirecter isNeedRedirectURL:parameters]) {
            url = [logicRedirecter redirectURL:url];
            continue;
        }
    }
    return url;
}
- (void)sortRedirecters
{

    [self.redirecters sortUsingComparator:^NSComparisonResult(id<LogicRedirecterProtocol> _Nonnull obj1, id<LogicRedirecterProtocol> _Nonnull obj2) {
      return obj1.level < obj2.level;
    }];
}
@end
