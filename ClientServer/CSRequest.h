//
//  CSRequest.h
//  Fetch
//
//  Created by lei on 2018/5/28.
//  Copyright © 2018 lei. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JavaScriptCore;


@protocol CSResponseProtocol <JSExport>

- (instancetype)initWithData:(NSData *)data resposne:(NSURLResponse *)response error:(NSError *)error;

- (NSString *)text;
- (NSString *)textASCII;
- (NSString *)json;

@end

@protocol CSRequestProtool <JSExport>

+ (NSString *)hi;

+ (void)request:(NSString *)url  handler:(JSValue *)handler;


@end

@interface CSResponse : NSObject<CSResponseProtocol>

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSURLResponse *response;

- (instancetype)initWithData:(NSData *)data resposne:(NSURLResponse *)response error:(NSError *)error;

- (NSString *)text;
- (NSString *)json;

@end

@interface CSRequest : NSObject<CSRequestProtool>



@end
