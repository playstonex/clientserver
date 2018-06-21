//
//  CSRequestManager.h
//  ClientServer
//
//  Created by lei on 2018/6/21.
//  Copyright © 2018年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CSRequestCallback)(NSString *, NSString*);


@interface CSRequestManager : NSObject

- (instancetype)initWithJSFile:(NSURL *)path;
- (void)call:(NSString *)name arguments:(NSArray *)arguments completeHandle:(CSRequestCallback)handler;


@end
