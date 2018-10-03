//
//  FilledFormCache.m
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "FilledFormCache.h"
#import "FilledFormUploader.h"
#import "RECAPPRestAPI.h"

#import "StudiesFactory.h"

@implementation FilledFormCache

@synthesize cacheThread,cacheUpdateTimer, operationQueue;

static FilledFormCache *cache = nil;

-(id)init
{
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
    return self;
}

+(FilledFormCache*)getInstance
{
    if(!cache)
    {
        cache = [[FilledFormCache alloc] init];
        [cache startCacheAutoUpdate];
    }
    return cache;
}

-(void)startCacheAutoUpdate
{
    if(cacheThread == nil)
    {
        cacheThread = [[NSThread alloc] initWithTarget:self selector:@selector(initializeCacheAutoUpdate) object:nil];
        [cacheThread start];
    }
}

-(void)initializeCacheAutoUpdate
{
    ////////////NSLog(@"Initialize Updater Thread");
    cacheUpdateTimer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                                interval:20
                                                  target:self
                                                selector:@selector(uploadFilledForms)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:cacheUpdateTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

-(void)updateStudiesList
{
    RECAPPRestAPI *restApi = [[RECAPPRestAPI alloc] initStudiesRequest];
    [restApi executeRequest];
    
    /*NSString *json = @"[{\"revision\":\"26A9412A-9F55-4EF7-8B26-18B7323E317C\",\"studyType\":0,\"stimulus_alloc\":[{\"trial_identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae7cc45\",\"stimulus\":[{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-11111111\",\"value\":\"apple\",\"type\":\"Stimulus\",\"identifier\":\"8888\"},{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100af5\",\"value\":\"watch\",\"type\":\"Stimulus\",\"identifier\":\"11234\"}],\"type\":\"StimulusAllocation\",\"stimulus_list_identifier\":\"444444444\"}],\"stimulus_pool_identifier\":\"123545\",\"identifier\":\"8498184f-89b3-4240-a397-255ec6359a26\",\"type\":\"StimulusStudy\",\"name\":\"Word Recall Memory Test\",\"surveys\":[{\"triggers\":[{\"activation_time\":\"2015-06-25T10:35:00.00+0000\",\"type\":\"TemporalTrigger\",\"children\":[],\"state\":0,\"interval\":1,\"identifier\":\"ba7575a9-8cc4-4cd9-a972-f86a81c1ee32\",\"duration\":120}],\"title\":\"Memory Trial 1\",\"state\":0,\"identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae7cc45\",\"type\":\"StimulusSurveyForm\",\"questions\":[{\"ordinal\":2,\"question\":\"Please enter the number of words you can remember\",\"type\":\"RecallQuestion\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100ay3\"},{\"ordinal\":1,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-11111111\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":6}]},{\"ordinal\":0,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100af5\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":6},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3}]}]}]}]";
    
    
    
    NSString *json2 = @"[{\"revision\":\"26A9412A-9F55-4EF7-8B26-18B7323E317C\",\"studyType\":0,\"stimulus_alloc\":[{\"trial_identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae7cc45\",\"stimulus\":[{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-11111111\",\"value\":\"apple\",\"type\":\"Stimulus\",\"identifier\":\"8888\"},{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100af5\",\"value\":\"watch\",\"type\":\"Stimulus\",\"identifier\":\"11234\"}],\"type\":\"StimulusAllocation\",\"stimulus_list_identifier\":\"444444444\"},{\"trial_identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae79999\",\"stimulus\":[{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-11110989\",\"value\":\"red\",\"type\":\"Stimulus\",\"identifier\":\"787\"},{\"stimulus_question_identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100000\",\"value\":\"blue\",\"type\":\"Stimulus\",\"identifier\":\"9876666\"}],\"type\":\"StimulusAllocation\",\"stimulus_list_identifier\":\"444444444\"}],\"stimulus_pool_identifier\":\"123545\",\"identifier\":\"8498184f-89b3-4240-a397-255ec6359a26\",\"type\":\"StimulusStudy\",\"name\":\"Word Recall Memory Test\",\"surveys\":[{\"triggers\":[{\"activation_time\":\"2015-06-23T15:30:00.00+0000\",\"type\":\"TemporalTrigger\",\"children\":[],\"state\":0,\"interval\":1,\"identifier\":\"ba7575a9-8cc4-4cd9-a972-f86a81c1ee32\",\"duration\":120}],\"title\":\"Memory Trial 1\",\"state\":0,\"identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae7cc45\",\"type\":\"StimulusSurveyForm\",\"questions\":[{\"ordinal\":2,\"question\":\"Please enter the number of words you can remember\",\"type\":\"RecallQuestion\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100ay3\"},{\"ordinal\":1,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-11111111\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":6}]},{\"ordinal\":0,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100af5\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":6},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3}]}]},{\"triggers\":[{\"activation_time\":\"2015-06-23T15:28:00.00+0000\",\"type\":\"TemporalTrigger\",\"children\":[],\"state\":0,\"interval\":1,\"identifier\":\"ba7575a9-8cc4-4cd9-a972-f86a81c11111\",\"duration\":120}],\"title\":\"Memory Trial 2\",\"state\":0,\"identifier\":\"c1a4ca99-e031-4a18-ada1-1c10fae79999\",\"type\":\"StimulusSurveyForm\",\"questions\":[{\"ordinal\":2,\"question\":\"Please enter the number of words you can remember\",\"type\":\"RecallQuestion\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d104857\"},{\"ordinal\":1,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-11110989\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":6}]},{\"ordinal\":0,\"question\":\"How stressed do you currently feel?\",\"identifier\":\"0b492a70-65f3-4db5-89f6-f9635d100000\",\"low_end_descriptor\":\"Not At All\",\"type\":\"StimulusQuestion\",\"high_end_descriptor\":\"Very Stressed\",\"options\":[{\"type\":\"LikertOption\",\"value\":5},{\"type\":\"LikertOption\",\"value\":1},{\"type\":\"LikertOption\",\"value\":6},{\"type\":\"LikertOption\",\"value\":4},{\"type\":\"LikertOption\",\"value\":2},{\"type\":\"LikertOption\",\"value\":7},{\"type\":\"LikertOption\",\"value\":3}]}]}]}]";
    
    
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\*" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:json options:0 range:NSMakeRange(0, [json length]) withTemplate:@""];
    //////NSLog(@"%@", modifiedString);
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    StudiesFactory *factory = [[StudiesFactory alloc] initWithData:data];
    [self.operationQueue addOperation:factory];*/
}

-(void) uploadFilledForms
{
    FilledFormUploader *uploadRun = [[FilledFormUploader alloc] init];
    [self.operationQueue addOperation:uploadRun];
}



@end
