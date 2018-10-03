//
//  SettingsViewController.h
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *settingslist;

@end
