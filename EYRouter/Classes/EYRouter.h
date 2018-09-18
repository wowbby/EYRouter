//
//  EYRouter.h
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import <Foundation/Foundation.h>

extern NSString *const EYRouterParameterURL;
extern NSString *const EYRouterParameterCompletion;
extern NSString *const EYRouterParameterUserInfo;

typedef void (^EYRouterHandle)(NSDictionary *parameter);

typedef id (^EYRouterObjectHandle)(NSDictionary *parameter);

@interface EYRouter : NSObject
+ (void)registerURL:(NSString *)url toHandle:(EYRouterHandle)handle;
+ (void)registerURL:(NSString *)url toObjectHandle:(EYRouterObjectHandle)handle;
+ (void)deregisterURL:(NSString *)url;

+ (void)openURL:(NSString *)URL;
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo;
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion;

+ (id)objectForURL:(NSString *)url;
+ (id)objectForURL:(NSString *)url userInfo:(NSDictionary *)userInfo;

+ (BOOL)canOpenURL:(NSString *)URL;
@end
