//
//  ViewController.m
//  wit-ios-eval
//
//  Created by Aric Lasry on 10/21/14.
//  Copyright (c) 2014 Aric Lasry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    UILabel *statusView;
    UILabel *intentView;
    UITextView *entitiesView;
    WITMicButton* witButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // set the WitDelegate object
    [Wit sharedInstance].delegate = self;
    [self setupUI];
}

-(void)setupUI {
    // create the button
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, 60, w, 100);
    
    witButton = [[WITMicButton alloc] initWithFrame:rect];
    [self.view addSubview:witButton];
    
    // create the label
    intentView = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, screen.size.width, 50)];
    intentView.textAlignment = NSTextAlignmentCenter;
    entitiesView = [[UITextView alloc] initWithFrame:CGRectMake(0, 250, screen.size.width, screen.size.height - 300)];
    entitiesView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    [self.view addSubview:entitiesView];
    [self.view addSubview:intentView];
    intentView.text = @"Intent will show up here";
    entitiesView.textAlignment = NSTextAlignmentCenter;
    entitiesView.text = @"Entities will show up here";
    entitiesView.editable = NO;
    entitiesView.font = [UIFont systemFontOfSize:17];
    
    statusView = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, screen.size.width, 50)];
    statusView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id) customData error:(NSError*)e {
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        return;
    }
    NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
    NSString *intent = [firstOutcome objectForKey:@"intent"];
    
    
    intentView.text = [NSString stringWithFormat:@"intent = %@", intent];
    statusView.text = @"";
    
    NSData *json;
    NSError *error = nil;
    if ([NSJSONSerialization isValidJSONObject:outcomes])
    {
        entitiesView.textAlignment = NSTextAlignmentLeft;
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:outcomes options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON: %@", jsonString);
            entitiesView.text = jsonString;
        }
    }
    
}



- (void)witActivityDetectorStarted {
    statusView.text = @"Just listening... Waiting for voice activity";
}

-(void)witDidStartRecording {
    statusView.text = @"Witting...";
    entitiesView.text = @"";
}

- (void)witDidStopRecording {
    statusView.text = @"Processing...";
    entitiesView.text = @"";
}

@end
