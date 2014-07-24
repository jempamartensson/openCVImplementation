//
//  JMPRfarnebackOf.m
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRfarnebackOf.h"

using namespace std;
using namespace cv;


@implementation JMPRfarnebackOf




Mat sfm( Mat& img1, Mat& img2, Mat& cam_matrix, Mat& dist_coeff ) {
    Mat gray1, gray2;
    cvtColor( img1, gray1, CV_BGR2GRAY );
    cvtColor( img2, gray2, CV_BGR2GRAY );
    
    /*  Find the optical flow using farneback dense algorithm
     Note that you might need to tune the parameters, especially window size.
     Smaller window size param, means more ambiguity when calculating the flow.
     */
    Mat flow_mat;
    calcOpticalFlowFarneback( gray1, gray2, flow_mat, 0.5, 3, 12, 3, 5, 1.2, 0 );
    
    vector<Point2f> left_points, right_points;
    for ( int y = 0; y < img1.rows; y+=6 ) {
        for ( int x = 0; x < img1.cols; x+=6 ) {
            /* Flow is basically the delta between left and right points */
            Point2f flow = flow_mat.at<Point2f>(y, x);
            
            /*  There's no need to calculate for every single point,
             if there's not much change, just ignore it
             */
            if( fabs(flow.x) < 0.1 && fabs(flow.y) < 0.1 )
                continue;
            
            left_points.push_back(  Point2f( x, y ) );
            right_points.push_back( Point2f( x + flow.x, y + flow.y ) );
        }
    }
    
    cout<<"There are number of points ->"<<left_points.size()<<endl;
    
    /* Undistort the points based on intrinsic params and dist coeff */
    undistortPoints( left_points, left_points, cam_matrix, dist_coeff );
    undistortPoints( right_points, right_points, cam_matrix, dist_coeff );
    
    /* Try to find essential matrix from the points */
    Mat fundamental = findFundamentalMat( left_points, right_points, FM_RANSAC, 3.0, 0.99 );
    Mat essential   = cam_matrix.t() * fundamental * cam_matrix;
    
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
    triangulatePoints( P1, P2, left_points, right_points, out );
    
    /* Since it's homogenous (x, y, z, w) coord, divide by w to get (x, y, z, 1) */
    vector<Mat> splitted = {
        out.row(0) / out.row(3),
        out.row(1) / out.row(3),
        out.row(2) / out.row(3)
    };
    
    merge( splitted, out );
    
    return out;
}

@end
