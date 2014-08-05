//
//  JMPRtriangulate2.m
//  openCVImplementation
//
//  Created by johndoe on 04/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRtriangulate2.h"
#import "JMPRlinearLSTriangulation.h"
#import "JMPRiterativeLinearLSTriangulation.h"

using namespace cv;
using namespace std;


@implementation JMPRtriangulate2

double JMPRtriangulateTwo(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,Matx34d P,Matx34d P1,const Mat& K,
                                const Mat &Kinv,vector<Point3d> &pointCloud){
    
    //convert image points to homogenous
    unsigned int pts_size = int(img_1_pts.size());
    vector<double> reproj_error;
    
    for (unsigned int i = 0; i< pts_size; i++)
    {
        Point2f kp = img_1_pts[i];
		Point3d u(kp.x,kp.y,1.0);
        //Mat u1m(3,1,CV_32F);
        //Mat um(3,1,CV_32F);
        //um = (
		Mat_<float> um = Kinv * Mat_<float>(u);
		u.x = um(0); u.y = um(1); u.z = um(2);
        
		Point2f kp1 = img_2_pts[i];
		Point3d u1(kp1.x,kp1.y,1.0);
		Mat_<float> um1 = Kinv * Mat_<float>(u1);
		u1.x = um1(0); u1.y = um1(1); u1.z = um1(2);
        
		Mat_<double> X = IterativeLinearLSTriangulation(u,P,u1,P1);
        
        
        //calculate reprojection error
        Mat_<double> xPt_img = K * Mat(P1) * X;
        Point2f xPt_img_(xPt_img(0)/xPt_img(2),xPt_img(1)/xPt_img(2));
        reproj_error.push_back(norm(xPt_img_-kp1));
        
        //store 3D point
        pointCloud.push_back(Point3d(X(0),X(1),X(2)));

        
        
    
    }
    
    
    
    //return mean reprojection error
    Scalar me = mean(reproj_error);
    return me[0];
    
}


@end
