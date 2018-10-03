//
//  SettingsViewController.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaneButton.h"

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UITableView *settingslist;

@property(nonatomic, strong) IBOutlet UITextField *emailtextTX;
@property(nonatomic, strong) IBOutlet UITextField *passwordTX;

@property(nonatomic) BOOL isRegistering;

@property(nonatomic,strong) PaneButton * logButton;
@property(nonatomic,strong) PaneButton * regButton;

@property(nonatomic,strong) UIView * header;
@property(nonatomic,strong) UIView * container;

@end
