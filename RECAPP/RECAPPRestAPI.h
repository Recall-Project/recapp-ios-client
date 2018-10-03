//
//  REST.h
//  reflect
//
//  Created by RECAPP Developer on 12/01/2012.
//  Copyright (c) 2012 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>


@interface RECAPPRestAPI : NSObject

@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLConnection *connection;

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) NSString *requestType;
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *queryString;
@property (strong, nonatomic) NSData *bodyData;

@property (weak, nonatomic) AppDelegate *appDel;

@property (strong, nonatomic) NSMutableData *responseData;

-(void)connection:(NSURLConnection*)connection didReceiveReponse:(NSURLResponse *)response;
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;

/*Current Flooder Graph Calls*/
-(id) initLoginRequest;
-(id) initRegisterRequest;
-(id) initStudiesRequest;
-(id) initLoginRequest;

-(id) initPostSurveyRequest:(NSDictionary *)data;
-(void) executeRequest;


@end
