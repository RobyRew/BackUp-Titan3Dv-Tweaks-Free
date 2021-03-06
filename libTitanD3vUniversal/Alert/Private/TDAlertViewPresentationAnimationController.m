#import "TDAlertViewPresentationAnimationController.h"

static CGFloat const kDefaultPresentationAnimationDuration = 0.7f;

@implementation TDAlertViewPresentationAnimationController

- (instancetype)init {
  self = [super init];

  if (self) {
    self.duration = kDefaultPresentationAnimationDuration;
  }

  return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (self.transitionStyle == TDAlertViewControllerTransitionStyleSlideFromTop || self.transitionStyle == TDAlertViewControllerTransitionStyleSlideFromBottom) {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect initialFrame = [transitionContext finalFrameForViewController:toViewController];

    initialFrame.origin.y = self.transitionStyle == TDAlertViewControllerTransitionStyleSlideFromTop ? -(initialFrame.size.height + initialFrame.origin.y) : (initialFrame.size.height + initialFrame.origin.y);
    toViewController.view.frame = initialFrame;

    [[transitionContext containerView] addSubview:toViewController.view];

    if (self.transitionStyle == TDAlertViewControllerTransitionStyleSlideFromTop) {
      CATransform3D transform = CATransform3DIdentity;
      transform.m34 = -1.0f / 600.0f;
      transform = CATransform3DRotate(transform, M_PI_4 * 1.3f, 1.0f, 0.0f, 0.0f);

      toViewController.view.layer.zPosition = 100.0f;
      toViewController.view.layer.transform = transform;
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
    delay:0.0f
    usingSpringWithDamping:0.76f
    initialSpringVelocity:0.2f
    options:0
    animations:^{
      toViewController.view.layer.transform = CATransform3DIdentity;
      toViewController.view.layer.opacity = 1.0f;
      toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    }
    completion:^(BOOL finished) {
      [transitionContext completeTransition:YES];
    }];
  } else {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [[transitionContext containerView] addSubview:toViewController.view];

    toViewController.view.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.2f);
    toViewController.view.layer.opacity = 0.0f;

    [UIView animateWithDuration:[self transitionDuration:transitionContext]
    animations:^{
      toViewController.view.layer.transform = CATransform3DIdentity;
      toViewController.view.layer.opacity = 1.0f;
    }
    completion:^(BOOL finished) {
      [transitionContext completeTransition:YES];
    }];
  }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  switch (self.transitionStyle) {
    case TDAlertViewControllerTransitionStyleFade:
    return 0.3f;
    break;

    case TDAlertViewControllerTransitionStyleSlideFromTop:
    case TDAlertViewControllerTransitionStyleSlideFromBottom:
    return 0.6f;
  }
}

@end
