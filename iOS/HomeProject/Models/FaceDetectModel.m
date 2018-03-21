//
//  FaceDetectModel.m
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import "FaceDetectModel.h"
#import "FaceRectangleModel.h"

#define FACE_RECTANGLE @"faceRectangle"
#define EMOTION @"emotion"
#define FACE_ATTRIBUTES @"faceAttributes"

@implementation FaceDetectModel
+(FaceDetectModel*)parseFaceDetect:(NSDictionary*)unparsedFaceDetect{
    if (!unparsedFaceDetect) {
        return nil;
    }
    
    FaceDetectModel* faceDetect = [[FaceDetectModel alloc] init];
    faceDetect.faceRectangle = [FaceRectangleModel parseFaceRectangle:unparsedFaceDetect[FACE_RECTANGLE]];
    faceDetect.emotions = unparsedFaceDetect[FACE_ATTRIBUTES][EMOTION];
    return faceDetect;
}

-(NSString*)getStrongestEmotion{
    float max = 0;
    NSString *selectedKey;
    for(NSString* key in self.emotions){
        if ([self.emotions[key] floatValue] > max) {
            max = [self.emotions[key] floatValue];
            selectedKey = key;
        }
    }
    return selectedKey;
}
@end
