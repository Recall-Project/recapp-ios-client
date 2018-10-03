//
//  RECAPPMainViewController.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SurveyForm;

@interface RECAPPMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *surveylist;

@property(nonatomic, strong) NSMutableArray *previousSurveys;
@property(nonatomic, strong) NSMutableArray *primedSurveys;
@property(nonatomic, strong) NSMutableArray *availableSurveys;


-(void)displaySurveyForm:(SurveyForm*)form forTrigger:(NSString*)triggerID;
-(void)refreshSurveyListings;
-(void) endRefresh;

@end
