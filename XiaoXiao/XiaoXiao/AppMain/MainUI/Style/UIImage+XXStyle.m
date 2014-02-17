//
//  UIImage+XXStyle.m
//  NavigationTest
//
//  Created by ZYVincent on 14-1-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "UIImage+XXStyle.h"

@implementation UIImage (XXStyle)

- (UIImage*)makeStretchWithEdegeInsets:(UIEdgeInsets)edgeInsets
{
    return [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}
- (UIImage*)makeStretchForBubbleLeft
{
    UIEdgeInsets bLeft = UIEdgeInsetsMake(35.f,15.f,5.f,5.f);
    return [self makeStretchWithEdegeInsets:bLeft];
}
- (UIImage*)makeStretchForBubbleRight
{
    UIEdgeInsets bRight = UIEdgeInsetsMake(35.f,5.f,5.f,15.f);
    return [self makeStretchWithEdegeInsets:bRight];
}
- (UIImage*)makeStretchForBubbleLeftVertical
{
    UIEdgeInsets bLeft = UIEdgeInsetsMake(0.f,15.f,0.f,5.f);
    return [self makeStretchWithEdegeInsets:bLeft];
}
- (UIImage*)makeStretchForBubbleRightVertical
{
    UIEdgeInsets bRight = UIEdgeInsetsMake(0.f,5.f,0.f,15.f);
    return [self makeStretchWithEdegeInsets:bRight];
}
- (UIImage*)makeStretchForSingleRoundCell
{
    UIEdgeInsets sCell = UIEdgeInsetsMake(0.f,30.f,0.f,30.f);
    return [self makeStretchWithEdegeInsets:sCell];
}
- (UIImage*)makeStretchForSingleCornerCell
{
    UIEdgeInsets sCCell = UIEdgeInsetsMake(0.f,30.f,0.f,30.f);
    return [self makeStretchWithEdegeInsets:sCCell];
}
- (UIImage*)makeStretchForCellTop
{
    UIEdgeInsets cellTop = UIEdgeInsetsMake(3.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:cellTop];
}
- (UIImage*)makeStretchForCellMiddle
{
    UIEdgeInsets cellMiddle = UIEdgeInsetsMake(3.f,3.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:cellMiddle];
}
- (UIImage*)makeStretchForCellBottom
{
    UIEdgeInsets cellBottom = UIEdgeInsetsMake(3.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:cellBottom];
}
- (UIImage*)makeStretchForSharePostList
{
    UIEdgeInsets shareList = UIEdgeInsetsMake(5.f,5.f,5.f,5.f);
    return [self makeStretchWithEdegeInsets:shareList];
}

- (UIImage*)makeStretchForSharePostDetail
{
    UIEdgeInsets shareListDetail = UIEdgeInsetsMake(5.f,5.f,3.f,5.f);
    return [self makeStretchWithEdegeInsets:shareListDetail];
}
- (UIImage*)makeStretchForSharePostDetailMiddle
{
    UIEdgeInsets shareListDetailMiddle = UIEdgeInsetsMake(3.f,3.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailMiddle];
}
- (UIImage*)makeStretchForSharePostDetailBottom
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,5.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];
}

- (UIImage*)makeStretchForSegmentLeft
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,6.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}
- (UIImage*)makeStretchForSegmentMiddle
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,3.f,3.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}
- (UIImage*)makeStretchForSegmentRight
{
    UIEdgeInsets shareListDetailBottom = UIEdgeInsetsMake(3.f,3.f,3.f,6.f);
    return [self makeStretchWithEdegeInsets:shareListDetailBottom];

}

@end
