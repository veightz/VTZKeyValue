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
#import <JDStatusBarNotification.h>
#import "ActionManager.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mappingAction:(id)sender {
    [self.outputTextView setText:@""];
    self.presentedMapObject = nil;
    NSString *queryString = self.inputTextField.text;
    
    [JDStatusBarNotification showWithStatus:@"Mapping..." styleName:JDStatusBarStyleDefault];
    
    @weakify(self);
    [SharedDataManager fetchMappingValueForKey:queryString completion:^(AVObject *object, NSError *error) {
        @strongify(self);
        if (object) {
            [JDStatusBarNotification showWithStatus:@"Found It!" dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
            self.presentedMapObject = object;
            if ([self.inputTextField.text isEqualToString:object[@"key"]]) {
                [self.outputTextView setText:object[@"value"]];
                @weakify(self);
                [SharedActionManager write:^(VTZPasteboardUnit *unit) {
                    @strongify(self);
                    unit.string = self.outputTextView.text;
                }];
            }
        } else {
            [JDStatusBarNotification showWithStatus:@"Not Found." dismissAfter:1.0 styleName:JDStatusBarStyleError];
        }
    }];
}

- (IBAction)pushAction:(id)sender {    
    if (!self.inputTextField.text.length || !self.outputTextView.text.length) {
        NSString *statusString = self.inputTextField.text.length ? @"Value string is too short!" : @"Key string is too short!";
        [JDStatusBarNotification showWithStatus:statusString dismissAfter:1.2 styleName:JDStatusBarStyleError];
        return;
    }
    [JDStatusBarNotification showWithStatus:@"Pushing..." styleName:JDStatusBarStyleDefault];
    if (self.presentedMapObject) {
        [SharedDataManager setMappingValue:self.outputTextView.text forObjectId:self.presentedMapObject.objectId completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [JDStatusBarNotification showWithStatus:@"Pushed It!" dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
                NSLog(@"Save %@ => %@ Done.", self.inputTextField.text, self.outputTextView.text);
            } else {
                [JDStatusBarNotification showWithStatus:@"Push failed." dismissAfter:1.0 styleName:JDStatusBarStyleError];
                NSLog(@"Save %@ => %@ failed. Reason: %@", self.inputTextField.text, self.outputTextView.text, error.description);
            }
        }];
    } else {
        [SharedDataManager setMappingValue:self.outputTextView.text forKey:self.inputTextField.text completion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [JDStatusBarNotification showWithStatus:@"Pushed It!" dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
                NSLog(@"Save %@ => %@ Done.", self.inputTextField.text, self.outputTextView.text);
            } else {
                [JDStatusBarNotification showWithStatus:@"Push failed." dismissAfter:1.0 styleName:JDStatusBarStyleError];
                NSLog(@"Save %@ => %@ failed. Reason: %@", self.inputTextField.text, self.outputTextView.text, error.description);
            }
        }];
    }
}
@end
