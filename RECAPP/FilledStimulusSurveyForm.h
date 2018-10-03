//
//  FilledStimulusSurveyForm.h
//  
//
//  Created by RECAPP Developer on 18/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FilledSurveyForm.h"

@class Stimulus;

@interface FilledStimulusSurveyForm : FilledSurveyForm

@property (nonatomic, retain) NSNumber * displayed;
@property (nonatomic, retain) NSSet *recallset;
@end

@interface FilledStimulusSurveyForm (CoreDataGeneratedAccessors)

- (void)addRecallsetObject:(Stimulus *)value;
- (void)removeRecallsetObject:(Stimulus *)value;
- (void)addRecallset:(NSSet *)values;
- (void)removeRecallset:(NSSet *)values;

@end
