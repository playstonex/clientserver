//
//  CSRequest.m
//  Fetch
//
//  Created by lei on 2018/5/28.
//  Copyright © 2018 lei. All rights reserved.
//

#import "CSRequest.h"

@implementation CSResponse

- (instancetype)initWithData:(NSData *)data resposne:(NSURLResponse *)response error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.data = data;
        self.error = error;
        self.response = response;
    }
    return self;
}

- (NSString *)text {
    return  [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

- (NSString *)textASCII {
    return  [[NSString alloc] initWithData:self.data encoding:NSASCIIStringEncoding];
}

- (NSString *)json {
    return [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:nil];
}

@end

@implementation CSRequest

+ (NSString *)hi {
    return @"hi";
}

+ (void)request:(NSString *)url  handler:(JSValue *)handler {
    [self request:url callback:^(CSResponse *response) {
        //NetResponse *res = (NetResponse *)response;
        [handler callWithArguments:@[response]];
        
    }];
}


+ (void)request:(NSString *)url  callback:(void(^)(CSResponse *))handler {
    NSLog(@"begin request");
    NSLog(@"URL: %@", url);
    NSURLSessionConfiguration * conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
    NSURLSessionTask *task =  [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Request call back");
        CSResponse *r =  [[CSResponse alloc] initWithData:data resposne:response error:error];
        if (handler) {
            handler(r);
        }
    }];
    
    [task resume];
}

@end
