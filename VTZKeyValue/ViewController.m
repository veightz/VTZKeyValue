//
//  ViewController.m
//  VTZKeyValue
//
//  Created by Veight Zhou on 7/21/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "RACEXTScope.h"
#import <AVOSCloud.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *mappingButton;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@property (strong, nonatomic) AVObject *presentedMapObject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [SharedDataManager fetchMappingValueForKey:@"tk" completion:^(id object, NSError *error) {
//        if (object) {
//            NSLog(@"find!");
//            NSLog(@"%@ => %@", object[@"key"], object[@"value"]);
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mappingAction:(id)sender {
    [self.outputTextView setText:@""];
    self.presentedMapObject = nil;
    NSString *queryString = self.inputTextField.text;
    @weakify(self);
    [SharedDataManager fetchMappingValueForKey:queryString completion:^(AVObject *object, NSError *error) {
        @strongify(self);
        if (object) {
            self.presentedMapObject = object;
            if ([self.inputTextField.text isEqualToString:object[@"key"]]) {
                [self.outputTextView setText:object[@"value"]];
            }
        }
    }];
}

- (IBAction)pushAction:(id)sender {    
    if (!self.inputTextField.text.length || !self.outputTextView.text.length) {
        return;
    }
    if (self.presentedMapObject) {
        [SharedDataManager setMappingValue:self.outputTextView.text forObjectId:self.presentedMapObject.objectId completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Save %@ => %@ Done.", self.inputTextField.text, self.outputTextView.text);
            } else {
                NSLog(@"Save %@ => %@ failed. Reason: %@", self.inputTextField.text, self.outputTextView.text, error.description);
            }
        }];
    } else {
        [SharedDataManager setMappingValue:self.outputTextView.text forKey:self.inputTextField.text completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Save %@ => %@ Done.", self.inputTextField.text, self.outputTextView.text);
            } else {
                NSLog(@"Save %@ => %@ failed. Reason: %@", self.inputTextField.text, self.outputTextView.text, error.description);
            }
        }];
    }
}
@end
