@interface SpringBoard : UIApplication
  -(long long)_frontMostAppOrientation;
  -(BOOL)isLocked;
@end

@interface SBGrabberTongue : NSObject
{
  UIPanGestureRecognizer *_edgePullGestureRecognizer;
  UIView *_tongueContainer;
}
@end

@interface SBFluidSwitcherGestureManager : NSObject
  @property(retain, nonatomic) SBGrabberTongue *deckGrabberTongue; // @synthesize deckGrabberTongue=_deckGrabberTongue;
  @property (nonatomic,retain) UINotificationFeedbackGenerator * edgeProtectFeedbackGenerator; 
@end

@interface SBControlCenterController : NSObject
  +(id)sharedInstance;
  -(void)presentAnimated:(BOOL)animated;
  -(BOOL)isPresented;
@end

@interface SBCoverSheetPresentationManager : NSObject
  +(id)sharedInstance;
  -(void)setCoverSheetPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(id)arg3;
  -(BOOL)isPresented;
@end