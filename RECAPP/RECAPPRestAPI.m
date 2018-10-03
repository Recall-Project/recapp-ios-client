//
//  REST.m
//  reflect
//
//  Created by RECAPP Developer on 12/01/2012.
//  Copyright (c) 2012 Lancaster University. All rights reserved.
//

#import "RECAPPRestAPI.h"
#import "AppDelegate.h"
#import "AlertsManager.h"
#import "CurrentUser.h"
#import "User.h"
#import "FilledSurveyForm.h"
#import "StudiesFactory.h"
#import "FilledFormCache.h"
#import "HTTPResponse.h"
#import "RECAPPMainViewController.h"


@implementation RECAPPRestAPI
@synthesize host = _host, uri = _uri, connection = _connection, appDel = _appDel, request = _request, responseData = _responseData, requestType = _requestType, queryString = _queryString, bodyData = _bodyData, contentType = _contentType;

#define LOGIN @"login"
#define REGISTER @"register"
#define SAVE_SURVEY @"survey/save"
#define USER_STUDIES @"user/surveys"

#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

-(void)setupHostInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recapp_configuration" ofType:@"plist"];
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    _host = [plist objectForKey:@"host"];
    
    _appDel = (AppDelegate*) [[UIApplication sharedApplication] delegate];
}

-(id) initStudiesRequest
{
    [self setupHostInfo];
    _uri = USER_STUDIES;
    _requestType = @"GET";
    
    User *user = [[CurrentUser getInstance] getUser];
    
    ////NSLog(@"USER_STUDIES REQ");
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"xpr_username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:user.email forKey:NSHTTPCookieValue];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"xpr_password" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:user.passphrase forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
    
    _queryString = @"";
    
    return self;
}

-(id) initLoginRequest
{
    [self setupHostInfo];
    _uri = LOGIN;
    _requestType = @"GET";
    
    User *user = [[CurrentUser getInstance] getUser];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"xpr_username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:user.email forKey:NSHTTPCookieValue];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"xpr_password" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:user.passphrase forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];

    _queryString = @"";//[NSString stringWithFormat:@"?email=%@&passphrase=%@",user.email, user.passphrase];
    
    return self;
}


-(id) initRegisterRequest
{
    [self setupHostInfo];
    _uri = REGISTER;
    _requestType = @"GET";
    
    User *user = [[CurrentUser getInstance] getUser];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"xpr_username" forKey:NSHTTPCookieName];
    [cookieProperties setObject:user.email forKey:NSHTTPCookieValue];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"xpr_password" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:user.passphrase forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:self.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
    
    _queryString = @"";//[NSString stringWithFormat:@"?email=%@&passphrase=%@",user.email, user.passphrase];
    
    return self;
}

-(id) initPostSurveyRequest:(NSDictionary *)data;
{
    [self setupHostInfo];
    _uri = SAVE_SURVEY;
    _requestType = @"POST";
    _queryString = @"";
    
    _bodyData = [self generateFormDataFromPostDictionary:data];
    
    return self;
}

- (NSData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    id boundary = BOUNDARY;
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
	
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        
        NSString *boundaryData = [NSString stringWithFormat:@"--%@\r\n", boundary];
        [result appendData:DATA(boundaryData)];
        ////////NSLog(@"%@", boundaryData );
		
		if ([value isKindOfClass:[NSData class]])
		{
			NSString *dispHeader = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i], [keys objectAtIndex:i]];
            [result appendData: DATA(dispHeader)];
            ////////NSLog(@"%@",dispHeader);
			[result appendData:value];
            ////////NSLog(@"%@", value);
            NSString *formstring = @"\r\n";
            [result appendData:DATA(formstring)];
            ////////NSLog(@"%@", formstring);
		}
        else
        {
            NSString *dispHeader = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\" \nContent-Type: application/json\r\n\r\n", [keys objectAtIndex:i]];
            [result appendData: DATA(dispHeader)];
            ////////NSLog(@"%@", dispHeader);
			[result appendData:DATA(value)];
            ////////NSLog(@"%@", value);
            NSString *formstring = @"\r\n";
            [result appendData:DATA(formstring)];
            ////////NSLog(@"%@", formstring);
        }
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    
    [result appendData:DATA(formstring)];
     ////////NSLog(@"%@", formstring);
    
    //NSString *jsonItemsAsString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
   
    
    return result;
}



-(void)executeRequest
{
    id boundary = BOUNDARY;
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@%@",_host,_uri, _queryString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ////////NSLog(@"%@", urlStr);
    
    _request = [NSMutableURLRequest requestWithURL:url];
    [_request setTimeoutInterval:10];
    [_request setHTTPMethod:_requestType];
    
    if([_requestType isEqualToString:@"POST"])
    {
      
        [_request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"content-Type"];
        //NSData *jsonData = [test dataUsingEncoding:NSUTF8StringEncoding];
        //[_request addValue:@"plain/text" forHTTPHeaderField:@"content-Type"];
        [_request setHTTPBody:_bodyData];
        
        
    }
    else
    {
        [_request addValue:_contentType forHTTPHeaderField:@"content-Type"];
    }
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
}


#pragma URLConnection Delegate Callbacks

-(void)connection:(NSURLConnection*)connection didReceiveReponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    if((_responseData == nil) || (_responseData == NULL)){
		_responseData = [[NSMutableData alloc] init];
	}
	[_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_responseData != nil)
    {
        
        /*for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
        {
            //////////NSLog(@"name: '%@'\n",   [cookie name]);
            //////////NSLog(@"value: '%@'\n",  [cookie value]);
            //////////NSLog(@"domain: '%@'\n", [cookie domain]);
            //////////NSLog(@"path: '%@'\n",   [cookie path]);
        }*/
        
        if([_uri isEqualToString:LOGIN])
        {
            NSString *newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            //////NSLog(@"%@", newStr);
            
            AppDelegate *del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            if([newStr isEqualToString:@"success"])
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"has_registered"];
                [defaults synchronize];
                [del.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
                [[FilledFormCache getInstance] updateStudiesList];
            }
            else
            {
                [[AlertsManager getInstance] registerIssue];
            }
            
            [del stopSpinner];
            
        }
        else if([_uri isEqualToString:USER_STUDIES])
        {
            
    
            ////NSLog(@"USER_STUDIES RESP");
            
            NSString *newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            ////NSLog(@"%@", newStr);
            
            if(![newStr isEqualToString:@"empty"])
            {
            
                StudiesFactory *factory = [[StudiesFactory alloc] initWithData:_responseData];
                [[FilledFormCache getInstance].operationQueue addOperation:factory];
            }
            else
            {
                [self killrefresh];
            }
        }
        else if([_uri isEqualToString:SAVE_SURVEY])
        {
            NSString *newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", newStr);
         
            
            AppDelegate *ap = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            NSFetchRequest *filledFormReq = [[NSFetchRequest alloc] init];
            NSEntityDescription *entityform = [NSEntityDescription entityForName:@"FilledSurveyForm" inManagedObjectContext:[ap managedObjectContext]];
            [filledFormReq setEntity:entityform];
            [filledFormReq setFetchLimit:1];
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"identifier == %@",newStr];
            [filledFormReq setPredicate:predicate1];
            NSError *error;
            NSArray *filledForms = [[ap managedObjectContext] executeFetchRequest:filledFormReq error:&error];
            
            for(FilledSurveyForm *filledform in filledForms)
            {
                [filledform setSync:@"0"];
                [ap dirtyMOCSave];
                break;
            }
            
        }
        else if([_uri isEqualToString:REGISTER])
        {
            NSString *newStr = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
            //////NSLog(@"%@", newStr);
            
            NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:nil];
           
            //NSString *jsonItemsAsString = [[NSString alloc] initWithData:studies encoding:NSUTF8StringEncoding];
            
            ////////NSLog(@"%@ %@", [resp objectForKey:@"code"],[resp objectForKey:@"message"]);
            
            AppDelegate *del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
            
            if([[resp objectForKey:@"code"] isEqualToString:@"100"])
            {            
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"has_registered"];
                [defaults synchronize];
                [del.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
                [[FilledFormCache getInstance] updateStudiesList];
            }
            else if([[resp objectForKey:@"code"] isEqualToString:@"409"])
            {
                [[AlertsManager getInstance] pinExists];
            }
            else
            {
                [[AlertsManager getInstance] registerIssue];
            }
            
            [del stopSpinner];
        }
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error
{  
    [self killrefresh];
}


-(void)killrefresh
{
    ////////NSLog(@"REST Connection Error:%@",error);
    AppDelegate *del = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    RECAPPMainViewController *mainView = (RECAPPMainViewController*) del.window.rootViewController;
    if(mainView)
    {
        [mainView endRefresh];
    }
}



@end
