//
//  SurveyViewController.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyForm.h"
#import "ImageExperienceCaptureController.h"

@interface SurveyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITableView *questionList;

@property (nonatomic, strong) IBOutlet UIPickerView* pickerView;
@property (nonatomic, strong) IBOutlet UIToolbar* pickerBar;

@property (nonatomic, strong) SurveyForm *surveyForm;
@property (nonatomic, strong) NSArray *sortedQuestions;

@property (nonatomic, strong) NSString *triggerID;
@property (nonatomic, strong) NSString *surveyCoreDataID;
@property (nonatomic, strong) NSNumber *questionToDisplay;

@property (nonatomic, strong) NSNumber *responseOrdinal;

@property(nonatomic) int selectedQuestionOrdinal;

@property (nonatomic, strong) NSMutableArray *captureControllers;

@property (nonatomic, strong) NSMutableDictionary *cellTypes;

@end
