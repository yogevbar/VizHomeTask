//
//  FaceRectangleModel.m
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import "FaceRectangleModel.h"

@implementation FaceRectangleModel
+(FaceRectangleModel*)parseFaceRectangle:(NSDictionary*)unparsedFaceRectangle{
    FaceRectangleModel *faceRectangle = [[FaceRectangleModel alloc] init];
    faceRectangle.x = [unparsedFaceRectangle[@"left"] floatValue];
    faceRectangle.y = [unparsedFaceRectangle[@"top"] floatValue];
    faceRectangle.width = [unparsedFaceRectangle[@"width"] floatValue];
    faceRectangle.height = [unparsedFaceRectangle[@"height"] floatValue];
    return faceRectangle;
}

-(CGRect)getRect{
    return CGRectMake(self.x, self.y, self.width, self.height);
}
@end
