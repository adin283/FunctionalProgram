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

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

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
    
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"New Value: %@", x);
    } error:^(NSError *error) {
        NSLog(@"Error: %@", error);
    } completed:^{
        NSLog(@"Completed.");
    }];
    
    RACSignal *validEmailSignal = [self.textField.rac_textSignal map:^id(NSString *value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    
//    RAC(self.button, enabled) = validEmailSignal;
    self.button.rac_command = [[RACCommand alloc] initWithEnabled:validEmailSignal signalBlock:^RACSignal *(id input) {
        NSLog(@"Button pressed.");
        return [RACSignal empty];
    }];
    
    RAC(self.textField, textColor) = [validEmailSignal map:^id(id value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        } else {
            return [UIColor redColor];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
