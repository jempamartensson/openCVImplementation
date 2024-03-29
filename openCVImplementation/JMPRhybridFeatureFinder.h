//
//  JMPRhybridFeatureFinder.h
//  openCVImplementation
//
//  Created by johndoe on 29/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;


@interface JMPRhybridFeatureFinder : NSObject

void hybridFeatureFinder(Mat img_1,Mat img_2,Mat K, Mat distCoeffs,vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts,Mat &outimage);

@end
