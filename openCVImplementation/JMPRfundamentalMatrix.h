//
//  JMPRfundamentalMatrix.h
//  openCVImplementation
//
//  Created by johndoe on 29/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;


@interface JMPRfundamentalMatrix : NSObject

void fundamentalMatrix(vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts,Mat K, Mat &F, Mat &E,Matx34d &P,Matx34d &P1);


@end
