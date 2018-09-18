//
//  LogicRedirecterProtocol.h
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import <Foundation/Foundation.h>

@protocol LogicRedirecterProtocol <NSObject>
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSInteger level;
- (BOOL)isNeedRedirectURL:(NSDictionary<NSString *, NSString *> *)registerParameters;
- (NSString *)redirectURL:(NSString *)url;
@end
