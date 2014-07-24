//
//  JMPRflannMatcher.h
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;

@interface JMPRflannMatcher : NSObject

Mat testFlann(Mat cameraM, Mat distM, Mat &img_drawkey);


@end
