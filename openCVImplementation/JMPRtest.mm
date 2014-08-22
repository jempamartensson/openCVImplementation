//
//  JMPRtest.m
//  openCVImplementation
//
//  Created by johndoe on 13/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRtest.h"
#import <fstream>


@implementation JMPRtest


void testOutput(vector<Point2f> img_1_pts,vector<Point2f> img_2_pts,const Mat& K,Mat pointcloud,
                const Mat &Kinv, const Mat &distCoeff, vector<Point3d> &pointCloud)
{
    undistortPoints( img_1_pts, img_1_pts , K, distCoeff );
    undistortPoints( img_2_pts, img_2_pts , K, distCoeff );
    
    /* Try to find essential matrix from the points */
    Mat fundamental = findFundamentalMat( img_1_pts, img_2_pts, FM_RANSAC, 3.0, 0.99 );
    Mat essential   = K.t() * fundamental * K;
    
    /* Find the projection matrix between those two images */
    SVD svd( essential );
    static const Mat W = (Mat_<double>(3, 3) <<
                          0, -1, 0,
                          1, 0, 0,
                          0, 0, 1);
    
    static const Mat W_inv = W.inv();
    
    Mat_<double> R1 = svd.u * W * svd.vt;
    Mat_<double> T1 = svd.u.col( 2 );
    
    Mat_<double> R2 = svd.u * W_inv * svd.vt;
    Mat_<double> T2 = -svd.u.col( 2 );
    
    static const Mat P1 = Mat::eye(3, 4, CV_64FC1 );
    Mat P2 =( Mat_<double>(3, 4) <<
             R1(0, 0), R1(0, 1), R1(0, 2), T1(0),
             R1(1, 0), R1(1, 1), R1(1, 2), T1(1),
             R1(2, 0), R1(2, 1), R1(2, 2), T1(2));
    
    /*  Triangulate the points to find the 3D homogenous points in the world space
     Note that each column of the 'out' matrix corresponds to the 3d homogenous point
     */
    Mat out;
    triangulatePoints( P1, P2, img_1_pts, img_2_pts, out );
    
    /* Since it's homogenous (x, y, z, w) coord, divide by w to get (x, y, z, 1) */
    vector<Mat> splitted = {
        out.row(0) / out.row(3),
        out.row(1) / out.row(3),
        out.row(2) / out.row(3)
    };
    
    merge( splitted, out );
    pointcloud = out;
    vector<Point3d> points_3d;
    
    ofstream myfile;
    myfile.open("/Users/johndoe/Develop/statue_picture/test.txt");
    
    for (int i = 0; i<int(img_2_pts.size());i++)
    {
        Mat m = out.col(i);
        float x = m.at<float>(0);
        float y = m.at<float>(1);
        float z = m.at<float>(2);
        
        Point3d __pts_3d(x,y,z);
        points_3d.push_back(__pts_3d);
        myfile<<x<<" "<<y<<" "<<z<<"\n";
    }
    myfile.close();
    
}

@end
