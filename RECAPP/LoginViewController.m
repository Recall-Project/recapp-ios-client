//
//  SettingsViewController.m
//  RECAPP
//
//  Created by RECAPP Developer on 08/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "LoginViewController.h"
#import "PaneButton.h"
#import "EmailEntryCell.h"
#import "PassphraseEntryCell.h"
#import "CurrentUser.h"
#import "RECAPPRestAPI.h"
#import "AppDelegate.h"
#import "User.h"
#import "AlertsManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize settingslist, emailtextTX, passwordTX, isRegistering, logButton, regButton, header, container;

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
    
    isRegistering = NO;
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.settingslist.contentInset =  UIEdgeInsetsMake(0, 0, 150.0, 0);
    [self.settingslist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.settingslist.contentInset =  UIEdgeInsetsMake(0, 0, 0.0, 0);
    [self.settingslist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 20.0, screenWidth, 120.0)];
    header.backgroundColor= [UIColor lightGrayColor];
    
    container = [[UIView alloc] initWithFrame:CGRectMake(0.0, 20.0, screenWidth, 90.0)];
    container.backgroundColor= [UIColor darkGrayColor];
    [header addSubview:container];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 200.0, 90.0)];
    label.textColor = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font =[UIFont fontWithName:@"Futura-CondensedMedium" size:40.0]; //Futura Condensed Medium 20.0
    [container addSubview:label];
    label.text = @"RECAPP";
    
    if(!logButton)
    {
        logButton = [PaneButton buttonWithType:UIButtonTypeCustom];
        logButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:19];
        [logButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [logButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [logButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(validateUser)]];
        logButton.frame = CGRectMake((header.frame.size.width - 90.0), 0, 90.0 , 90.0);
        UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        [logButton setBackgroundColor:logBlue forState:UIControlStateNormal];
        [logButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [logButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logButton setTitle:@"Login" forState:UIControlStateNormal];
       
        
        regButton = [PaneButton buttonWithType:UIButtonTypeCustom];
        regButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:17];
        [regButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [regButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [regButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRegistration)]];
        regButton.frame = CGRectMake((screenWidth - 180.0), 60, 90.0 , 30.0);
        //UIColor *logBlue = [UIColor colorWithRed:208.0f / 255.0f green:208.0f / 255.0f blue:34.0f / 255.0f alpha:1];
        [regButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [regButton setBackgroundColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [regButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [regButton setTitle:@"Register" forState:UIControlStateNormal];
        
        regButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        logButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
      
    }
    
    [container addSubview:logButton];
    [container addSubview:regButton];
    
    return header;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    ////NSLog(@"rotated");
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // during rotation: update our image view's bounds and centre
        //UIImageView *imageView = [self.view viewWithTag:87];
        //imageView.bounds = self.view.bounds;
        //imageView.center = self.view.center;
        
    } completion:^(id  _Nonnull context) {
        
        // after rotation
        
    }];
}


-(void)showRegistration
{
    if(!isRegistering)
    {
        
        isRegistering = YES;
        [self.settingslist reloadData];
        [regButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [logButton setTitle:@"Register" forState:UIControlStateNormal];
    }
    else
    {
        
        isRegistering = NO;
        [self.settingslist reloadData];
        [regButton setTitle:@"Register" forState:UIControlStateNormal];
        [logButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    

}

-(void)validateUser
{
    ////NSLog(@"validateUser");
    
    EmailEntryCell *emailcell = (EmailEntryCell*)[self.settingslist cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PassphraseEntryCell *passcell = (PassphraseEntryCell*)[self.settingslist cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    ////NSLog(@"%@",emailcell.email.text);
    ////NSLog(@"%@",passcell.password.text);
    
    if(emailcell.email.text.length > 0 && passcell.password.text.length > 0)
    {
        AppDelegate *del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        User *user = [[CurrentUser getInstance] getUser];
                     
        if(!user)
        {
            user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[del managedObjectContext]];
        }
        
        if(isRegistering)
        {
            PassphraseEntryCell *passcell2 = (PassphraseEntryCell*)[self.settingslist cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            
            ////NSLog(@"register click");
            if([passcell.password.text isEqualToString:passcell2.password.text])
            {
                int iValue;
                
                if (emailcell.email.text.length < 9 && emailcell.email.text.length > 3 && [[NSScanner scannerWithString:emailcell.email.text] scanInt:&iValue])
                {
                    [user setEmail:emailcell.email.text];
                    [user setPassphrase:passcell2.password.text];
                    [user setIdentifier:emailcell.email.text];
                    [del dirtyMOCSave];
                    [del showSpinner];
                    RECAPPRestAPI *registerRequest = [[RECAPPRestAPI alloc] initRegisterRequest];
                    [registerRequest executeRequest];
                }
                else
                {
                     [[AlertsManager getInstance] pinInvalid];
                }
            }
            else
            {
                [[AlertsManager getInstance] passwordMismatch];
            }
        }
        else
        {
            [user setEmail:emailcell.email.text];
            [user setPassphrase:passcell.password.text];
            [user setIdentifier:emailcell.email.text];
            [del dirtyMOCSave];
            [del showSpinner];
            RECAPPRestAPI *loginRequest = [[RECAPPRestAPI alloc] initLoginRequest];
            [loginRequest executeRequest];
        }
    }
    else
    {
        [[AlertsManager getInstance] missingUsername];
        ////NSLog(@"missing text");
    }
}

-(void) updateUserSession
{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isRegistering)
    {
        return 3;
    }
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"email";
        EmailEntryCell *tempCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (tempCell == nil)
        {
            tempCell = [[EmailEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        tempCell.backgroundView = [[UIView alloc] initWithFrame:tempCell.bounds];
                               
        return tempCell;    
    }
    else if(indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"passphrase";
        PassphraseEntryCell *tempCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (tempCell == nil)
        {
            tempCell = [[PassphraseEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        tempCell.backgroundView = [[UIView alloc] initWithFrame:tempCell.bounds];
        return tempCell;
    }
    else if(indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"passphraseconfirm";
        PassphraseEntryCell *tempCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (tempCell == nil)
        {
            tempCell = [[PassphraseEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        tempCell.backgroundView = [[UIView alloc] initWithFrame:tempCell.bounds];
        return tempCell;
    }
    
  
  
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

@end
