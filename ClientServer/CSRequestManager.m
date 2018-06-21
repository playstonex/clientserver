//
//  CSRequestManager.m
//  ClientServer
//
//  Created by lei on 2018/6/21.
//  Copyright © 2018年 lei. All rights reserved.
//

#import "CSRequestManager.h"
#import "CSRequest.h"

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

typedef void(^CALLBACK)(NSString *, NSString*);

@interface NSString (MD5)
- (NSString *)md5;
@end



@import JavaScriptCore;

@interface CSRequestManager ()

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) JSValue *requestModel;
@property (nonatomic, copy) void(^callback)(NSString *, NSString *, NSString *);
@property (nonatomic,strong) NSMutableDictionary* callbackPool;
@property (nonatomic,strong) NSMutableDictionary* requestPool;

@end



@implementation CSRequestManager

- (instancetype)initWithJSFile:(NSURL *)path
{
    self = [super init];
    if (self) {
        self.callbackPool = [NSMutableDictionary dictionaryWithCapacity:4];
        self.requestPool = [NSMutableDictionary dictionaryWithCapacity:4];
        [self setupContextWithJSFile:path];
    }
    return self;
}


- (void)setupContextWithJSFile:(NSURL *)path {
    self.context = [[JSContext alloc] init];
    NSString *scriptString = [NSString stringWithContentsOfURL:path encoding:NSUTF8StringEncoding error:nil];
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error in:%@, exception: %@", context, exception.description);
    };
    [self.context evaluateScript:scriptString];
    [self.context setObject:[CSRequest class] forKeyedSubscript:@"CSRequest"];
    [self.context setObject:[CSResponse class] forKeyedSubscript:@"CSResponse"];
    
    JSValue * model = [self.context objectForKeyedSubscript:@"black"];
    self.requestModel = model;
    __weak CSRequestManager *weakSelf =  self;
    self.callback = ^(NSString *identifier, NSString *message, NSString *error) {
        CALLBACK callback = (CALLBACK)[weakSelf.callbackPool objectForKey:identifier];
        callback(message, error);
        [weakSelf.callbackPool removeObjectForKey:identifier];
        [weakSelf.requestPool removeObjectForKey:identifier];
    };
    
    void(^log)(NSString *) = ^(NSString *message) {
        NSLog(@"%@", message);
    };
    [self.context setObject:log forKeyedSubscript:@"log"];
}

- (void)call:(NSString *)name arguments:(NSArray *)arguments completeHandle:(CSRequestCallback)handler {
    
    NSArray *fes = [@[name] arrayByAddingObjectsFromArray:arguments];
    NSString *identifier =  [[fes componentsJoinedByString:@":"] md5];
    [self.callbackPool setObject:handler forKey:identifier];
    JSValue *jsfun = [self.requestModel objectForKeyedSubscript:name];
    JSValue *jsCallback = [JSValue valueWithObject:self.callback inContext:self.context];
    JSValue *aRequest = [jsfun callWithArguments:[arguments arrayByAddingObjectsFromArray:@[jsCallback, identifier]]];
    [self.requestPool setObject:aRequest forKey:identifier];
    
    
}

@end

@implementation NSString (MD5)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}



@end


