//
//  SettingsViewController.m
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "SettingsViewController.h"
#import "VersionCell.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize settingslist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissSettings:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 40.0)];
    header.backgroundColor= [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 70.0, 40.0)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]; //Futura Condensed Medium 20.0
    [header addSubview:label];

    if(section == 0)
    {
        label.text = @"General";
    }
 
    return header;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"VersionCell";
        VersionCell *tempCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (tempCell == nil)
        {
            tempCell = [[VersionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        tempCell.versionNumber.text = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        
        cell = tempCell;
    
    }
    else
    {
        static NSString *CellIdentifier = @"LogoutCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ////////NSLog(@"selected row:%d", indexPath.row);
    
    if(indexPath.row == 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"has_registered"];
        [defaults synchronize];
        
        AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        
        NSDictionary *allEntities = [appDel managedObjectModel].entitiesByName;
        
        for (NSString* key in allEntities) {
            NSEntityDescription *desc = [allEntities objectForKey:key];
            [self deleteAllObjects:desc.name];
        }
        
     
        
        [self dismissModalViewControllerAnimated:NO];
    }
    
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    
    AppDelegate *appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[appDel managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[appDel managedObjectContext] executeFetchRequest:fetchRequest error:&error];

    
    for (NSManagedObject *managedObject in items) {
        [[appDel managedObjectContext] deleteObject:managedObject];
       
    }
    
    [appDel dirtyMOCSave];
    
    [appDel cancelAllSurveyLocalNotifications];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}

@end
