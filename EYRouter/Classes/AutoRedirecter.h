//
//  AutoRedirecter.h
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import <Foundation/Foundation.h>
#import "LogicRedirecterProtocol.h"
@interface AutoRedirecter : NSObject
- (void)addRedirecter:(id<LogicRedirecterProtocol>)redirecter;
- (NSString *)autoDirecterURL:(NSString *)url registerParameters:(NSDictionary<NSString *, NSString *> *)parameters;
@end
