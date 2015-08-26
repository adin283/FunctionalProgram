//
//  ViewController.m
//  FunctionalProgram
//
//  Created by 祝文博 on 15/8/26.
//  Copyright (c) 2015年 KevinLab. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@1, @2, @3];
    RACSequence *stream = [array rac_sequence];
    
    NSLog(@"%@", [[stream map:^id(id value) {
        return @(pow([value integerValue], 2));
    }] array]);
    
    
    NSLog(@"%@", [[stream filter:^BOOL(id value) {
        return [value integerValue] % 2 == 0;
    }] array]);
    
    NSLog(@"%@", [[stream map:^id(id value) {
        return [value stringValue];
    }] foldLeftWithStart:@"" reduce:^id(id accumulator, id value) {
        return [accumulator stringByAppendingString:value];
    }]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
