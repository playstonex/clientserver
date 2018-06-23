//
//  ViewController.m
//  Fetch-Mac
//
//  Created by lei on 2018/6/22.
//  Copyright © 2018年 lei. All rights reserved.
//

#import "ViewController.h"
#import <ClientServer/ClientServer.h>


@interface ViewController ()

@property(nonatomic, strong)CSRequestManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bundle" withExtension:@"js"];
    CSRequestManager *manager = [[CSRequestManager alloc] initWithJSFile:url];
    self.manager = manager;
    
    [manager call:@"smartTranslate" arguments:@[@"利益", @"zh-CN",@"en",@"en"] completeHandle:^(NSString *message, NSString *err) {
        NSLog(message);
        NSLog(err);
    }];
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
