//
//  ViewController.h
//  AcronymAssessment
//
//  Created by Makkena, Ramakrishna on 4/11/16.
//  Copyright (c) 2016 Makkena, Ramakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kURL;
extern NSString *const kShortForm;
extern NSString *const kLongForms;
extern NSString *const kLongForm;
extern NSString *const kTextFormat;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *acronymTF;
- (IBAction)submitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *listOfMeaningTV;
- (IBAction)clearAction:(id)sender;

@end

