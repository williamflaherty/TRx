//
//  Question.h
//  TRx
//
//  Created by John Cotham on 4/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalk.h"
#import "FMDatabase.h"
#import "Utility.h"

@interface Question : LocalTalk

+(NSString *)getEnglishLabel:(NSString *)questionId;
+(NSString *)getTranslatedLabel:(NSString *)questionId;
+(NSString *)getSpanishLabel:(NSString *)questionId;
+(NSString *)getQuestionType:(NSString *)questionId;
+(NSString *)getValueForQuestionId:(NSString *)questionId;

@end
