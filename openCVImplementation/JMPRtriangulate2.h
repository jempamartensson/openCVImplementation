//
//  JMPRtriangulate2.h
//  openCVImplementation
//
//  Created by johndoe on 04/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>

using namespace cv;
using namespace std;

@interface JMPRtriangulate2 : NSObject

double JMPRtriangulateTwo(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,Matx34d P,Matx34d P1,const Mat& K,
                                const Mat &Kinv,vector<Point3d> &pointCloud);




@end
