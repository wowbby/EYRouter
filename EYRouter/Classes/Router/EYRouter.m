//
//  EYRouter.m
//  EYRouter
//
//  Created by 郑振兴 on 2018/9/18.
//

#import "EYRouter.h"
#import "AutoRedirecter.h"
static NSString *const kEYRouterHandleKey = @"kEYRouterHandle";
static NSString *const kEYRouterParametersKey = @"kEYRouterParameters";
static NSString *const kEmptyString = @"";
static NSString *const kpathJoinedString = @".";
static NSString *const kparameterJoinedString = @"&";
static NSString *const kpathSeparator = @"/";


NSString *const EYRouterParameterURL = @"EYRouterParameterURL";
NSString *const EYRouterParameterCompletion = @"EYRouterParameterCompletion";
NSString *const EYRouterParameterUserInfo = @"EYRouterParameterUserInfo";

#pragma mark - extension OF EYRouter

@interface EYRouter ()
@property (nonatomic, strong) NSMutableDictionary *routers;
@property (nonatomic, strong) AutoRedirecter *redirecter;
@end


@implementation EYRouter
#pragma mark - init
- (instancetype)init
{
    if (self = [super init]) {

        self.routers = [@{} mutableCopy];
        self.redirecter = [AutoRedirecter new];
    }
    return self;
}
+ (instancetype)shareRouter
{

    static EYRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      router = [[[self class] alloc] init];
    });
    return router;
}
+ (void)addLogicRedirecter:(id<LogicRedirecterProtocol>)redirecter
{
    [[[self shareRouter] redirecter] addRedirecter:redirecter];
}
+ (void)registerURL:(NSString *)url toHandle:(EYRouterHandle)handle
{

    [[self shareRouter] addURL:url handle:handle];
}
+ (void)registerURL:(NSString *)url toObjectHandle:(EYRouterObjectHandle)handle
{
    [[self shareRouter] addURL:url objectHandle:handle];
}
+ (void)deregisterURL:(NSString *)url
{

    [[self shareRouter] removeURL:url];
}
+ (void)openURL:(NSString *)URL
{

    [self openURL:URL withUserInfo:nil];
}
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo
{

    [self openURL:URL withUserInfo:userInfo completion:nil];
}
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion
{
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *subRoute = [[self shareRouter] subRouteWithURL:URL];

    NSDictionary<NSString *, NSString *> *queryParameters = [[self shareRouter] queryParametersFromURL:URL];

    NSDictionary<NSString *, NSString *> *registerParameterNames = subRoute[kEYRouterParametersKey];

    NSString *redirecterUrl = [[self shareRouter] autoDirecterURL:URL registerParameters:registerParameterNames];
    if (![redirecterUrl isEqualToString:URL]) {

        [self openURL:redirecterUrl withUserInfo:userInfo completion:completion];

        return;
    }

    NSMutableDictionary *parameters = [@{} mutableCopy];

    [registerParameterNames enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
      [parameters setObject:obj forKey:queryParameters[obj] ?: kEmptyString];
    }];

    if (completion) {
        parameters[EYRouterParameterCompletion] = completion;
    }
    if (userInfo) {
        parameters[EYRouterParameterUserInfo] = userInfo;
    }
    if (subRoute && subRoute[kEYRouterHandleKey]) {
        EYRouterHandle handle = subRoute[kEYRouterHandleKey];
        handle(parameters);
    }
}
+ (id)objectForURL:(NSString *)url
{
    return [self objectForURL:url userInfo:nil];
}
+ (id)objectForURL:(NSString *)url userInfo:(NSDictionary *)userInfo
{

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *subRoute = [[self shareRouter] subRouteWithURL:url];

    NSDictionary<NSString *, NSString *> *queryParameters = [[self shareRouter] queryParametersFromURL:url];

    NSDictionary<NSString *, NSString *> *registerParameters = subRoute[kEYRouterParametersKey];

    NSString *redirecterUrl = [[self shareRouter] autoDirecterURL:url registerParameters:registerParameters];
    if (![redirecterUrl isEqualToString:url]) {

        return [self objectForURL:redirecterUrl userInfo:userInfo];
    }
    NSMutableDictionary *parameters = [@{} mutableCopy];
    [registerParameters enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
      [parameters setObject:obj forKey:queryParameters[obj] ?: kEmptyString];
    }];

    EYRouterObjectHandle handle = subRoute[kEYRouterHandleKey];

    if (userInfo) {
        parameters[EYRouterParameterUserInfo] = userInfo;
    }
    if (handle) {
        return handle(parameters);
    }

    return nil;
}
+ (BOOL)canOpenURL:(NSString *)URL
{
    NSDictionary *subRoute = [[self shareRouter] subRouteWithURL:URL];
    if (subRoute) {
        return YES;
    }
    return NO;
}
#pragma mark - private method
- (void)addURL:(NSString *)url handle:(EYRouterHandle)handle
{
    NSMutableDictionary *subRouters = [self addURL:url];
    NSDictionary<NSString *, NSString *> *parameters = [self registerParametersFromURL:url];
    if (subRouters && handle) {
        subRouters[kEYRouterHandleKey] = [handle copy];
    }
    if (subRouters && parameters) {
        subRouters[kEYRouterParametersKey] = [parameters copy];
    }
}
- (void)addURL:(NSString *)url objectHandle:(EYRouterObjectHandle)handle
{
    NSMutableDictionary *subRouters = [self addURL:url];
    NSDictionary<NSString *, NSString *> *parameters = [self registerParametersFromURL:url];
    if (subRouters && handle) {
        subRouters[kEYRouterHandleKey] = [handle copy];
    }
    if (subRouters && parameters) {
        subRouters[kEYRouterParametersKey] = [parameters copy];
    }
}
- (NSMutableDictionary *)addURL:(NSString *)url
{

    NSArray<NSString *> *pathComponents = [self urlComponentsFromURL:url];
    __block NSMutableDictionary *subRouters = self.routers;
    [pathComponents enumerateObjectsUsingBlock:^(NSString *_Nonnull pathComponent, NSUInteger idx, BOOL *_Nonnull stop) {

      if (!subRouters[pathComponent]) {
          subRouters[pathComponent] = [@{} mutableCopy];
      }
      subRouters = subRouters[pathComponent];

    }];

    return subRouters;
}
- (NSDictionary<NSString *, NSString *> *)registerParametersFromURL:(NSString *)url
{
    NSURLComponents *components = [NSURLComponents componentsWithString:url];

    if (components.queryItems.count) {
        NSMutableDictionary *parameters = [@{} mutableCopy];
        [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
          [parameters setObject:obj.value ?: kEmptyString forKey:obj.name];
        }];
        return parameters;
    }
    return nil;
}
- (NSDictionary<NSString *, NSString *> *)queryParametersFromURL:(NSString *)url
{
    NSURLComponents *components = [NSURLComponents componentsWithString:url];

    if (!components.queryItems.count) {

        return nil;
    }

    NSMutableDictionary *parameters = [@{} mutableCopy];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      [parameters setObject:obj.value forKey:obj.name ?: kEmptyString];
    }];

    return parameters;
}
- (NSArray *)urlComponentsFromURL:(NSString *)url
{

    NSURLComponents *components = [NSURLComponents componentsWithString:url];
    if (!components) {
        return nil;
    }

    NSMutableArray<NSString *> *urlComponents = [@[] mutableCopy];
    if (components.scheme && components.scheme.length) {
        [urlComponents addObject:components.scheme];
    }
    if (components.host && components.host.length) {
        [urlComponents addObject:components.host];
    }

    if (components.path.length) {
        NSString *path = [components.path substringFromIndex:1];
        NSArray<NSString *> *pathSegments = [path componentsSeparatedByString:kpathSeparator];
        [urlComponents addObjectsFromArray:pathSegments];
    }
    return urlComponents;
}
- (void)removeURL:(NSString *)url
{
    NSMutableArray<NSString *> *pathCompontents = [[self urlComponentsFromURL:url] mutableCopy];

    if (pathCompontents.count >= 1) {
        NSString *components = [pathCompontents componentsJoinedByString:kpathJoinedString];
        NSMutableDictionary *routers = [self.routers valueForKeyPath:components];
        if (routers.count >= 1) {
            NSString *lastComponent = pathCompontents.lastObject;
            [pathCompontents removeLastObject];
            routers = self.routers;
            if (pathCompontents.count) {
                NSString *componentsWithoutlast = [pathCompontents componentsJoinedByString:kpathJoinedString];
                routers = [self.routers valueForKeyPath:componentsWithoutlast];
            }
            [routers removeObjectForKey:lastComponent];
        }
    }
}
- (NSDictionary *)subRouteWithURL:(NSString *)url
{

    NSArray<NSString *> *urlComponents = [self urlComponentsFromURL:url];
    NSString *components = [urlComponents componentsJoinedByString:kpathJoinedString];
    NSDictionary *route = [self.routers valueForKeyPath:components];
    if (!route && urlComponents.count > 1) {
        NSString *lastPath = [NSString stringWithFormat:@"%@%@", kpathSeparator, urlComponents.lastObject];
        url = [url stringByReplacingOccurrencesOfString:lastPath withString:@""];
        route = [self subRouteWithURL:url];
    }
    return route;
}
- (NSString *)autoDirecterURL:(NSString *)URL registerParameters:(NSDictionary<NSString *, NSString *> *)registerParameters
{

    return [[self redirecter] autoDirecterURL:URL registerParameters:registerParameters];
}
@end
