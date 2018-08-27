//
//  TestTransitionAnimator.m
//  Test1
//
//  Created by bigyelow on 2018/8/27.
//  Copyright © 2018 huangduyu. All rights reserved.
//

#import "TestTransitionAnimator.h"

@interface TestTransitionAnimator ()

@property (nonatomic, assign) BOOL presenting;

@end

@implementation TestTransitionAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
  UIView *containerView = transitionContext.containerView;
  UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
  UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
  UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

  // Set up some variables for the animation.
  CGRect containerFrame = containerView.frame;
  CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
  CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
  CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];

  // Set up the animation parameters.
  if (self.presenting) {
    // Modify the frame of the presented view so that it starts
    // offscreen at the lower-right corner of the container.
    toViewStartFrame.origin.x = containerFrame.size.width;
    toViewStartFrame.origin.y = containerFrame.size.height;
  }
  else {
    // Modify the frame of the dismissed view so it ends in
    // the lower-right corner of the container view.
    fromViewFinalFrame = CGRectMake(containerFrame.size.width,
                                    containerFrame.size.height,
                                    toView.frame.size.width,
                                    toView.frame.size.height);
  }
}

@end
