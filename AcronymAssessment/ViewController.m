//
//  ViewController.m
//  AcronymAssessment
//
//  Created by Makkena, Ramakrishna on 4/11/16.
//  Copyright (c) 2016 Makkena, Ramakrishna. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

//Constants
NSString *const kURL = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
NSString *const kShortForm = @"sf";
NSString *const kLongForms = @"lfs";
NSString *const kLongForm = @"lf";
NSString *const kTextFormat = @"text/plain";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper methods
//method to get the data
-(void)getResponseFromURL:(NSString *)acronym
{
    //URl for the Acronym Data
    NSURL *URL = [NSURL URLWithString:kURL];
    
    //Getting the sessionManager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    //Setting the Acceptable content types
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:kTextFormat, nil]];
    
    //Seeting the required parametrs
    NSDictionary *requestParameters = @{kShortForm : acronym};
    
    //To show the loading view while downloading data
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Getting the data or error from the URL with parameters
    [sessionManager GET:URL.absoluteString parameters:requestParameters progress:nil success:^(NSURLSessionTask *task, NSData *responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Background work
            NSLog(@"JSON: %@", responseObject);
            NSError *error;
            
            //convert the nsdata to nsarray
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            NSMutableArray *arrayofMeanings=[self getParsedData:jsonArray];
            
            //Updating the UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //Hide the loading view after downloading.
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *meaning = [arrayofMeanings componentsJoinedByString:@"\n\n"];
                if([meaning isEqual: @""])
                    self.listOfMeaningTV.text= [NSString stringWithFormat:@"No results found for %@.", self.acronymTF.text];
                else
                    self.listOfMeaningTV.text=meaning;
                
            });
        });
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//Parsing the Data
-(NSMutableArray *)getParsedData:(NSArray *)responseData
{
    NSMutableArray *arrayOfMeanings = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in responseData)
    {
        NSArray *lfsArray=[dict valueForKey:kLongForms];
        for (NSDictionary *lfDict in lfsArray) {
            [arrayOfMeanings addObject:[lfDict valueForKey:kLongForm]];
        }
    }
    return arrayOfMeanings;
}


#pragma mark - Button Actions

- (IBAction)submitAction:(id)sender
{
    NSString *acronym = self.acronymTF.text;
    [self getResponseFromURL:acronym];
}

- (IBAction)clearAction:(id)sender
{
    self.acronymTF.text = @"";
    self.listOfMeaningTV.text = @"";
}

#pragma  TextField Delegate method
//Textfield delegate method for hiding the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
