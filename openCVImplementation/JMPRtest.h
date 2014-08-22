//
//  JMPRtest.h
//  openCVImplementation
//
//  Created by johndoe on 13/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;

@interface JMPRtest : NSObject

void testOutput(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,const Mat& K,Mat pointcloud,
                const Mat &Kinv, const Mat &distCoeff, vector<Point3d> &pointCloud);


@end
