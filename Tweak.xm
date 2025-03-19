#import "header.h"

CGPoint initialPoint;
static UIImpactFeedbackGenerator* _feedbackGenerator;

%hook SBFluidSwitcherGestureManager

    -(void)grabberTongueBeganPulling:(id)arg1 withDistance:(double)initialDistance andVelocity:(double)arg3 andGesture:(id)arg4 {
        initialPoint = CGPointZero;
        CGPoint point = [[self.deckGrabberTongue valueForKey:@"_edgePullGestureRecognizer"] locationInView:[self.deckGrabberTongue valueForKey:@"_tongueContainer"]];
        int orientation = [((SpringBoard *)[UIApplication sharedApplication]) _frontMostAppOrientation];

        bool onLeftEdge = point.x < 60;
        bool onRightEdge = point.x > [UIScreen mainScreen].bounds.size.width - 60;     

        if (orientation == 1 && (onLeftEdge || onRightEdge) && initialDistance >= 20) {
            initialPoint = point;

            if (!_feedbackGenerator)
                _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];            
                
            [_feedbackGenerator prepare]; 
        }
        else {
            %orig;
        }
    }

    -(void)grabberTongueEndedPulling:(id)arg1 withDistance:(double)finalDistance andVelocity:(double)arg3 andGesture:(id)arg4  {

        if(CGPointEqualToPoint(initialPoint,CGPointZero) || finalDistance <= 20) {
            %orig;
            return;
        }        

        bool onLeftEdge = initialPoint.x < 60;
        bool onRightEdge = initialPoint.x > [UIScreen mainScreen].bounds.size.width - 60;        

        if (onLeftEdge || onRightEdge) {
            if (onLeftEdge) {
                if (![[%c(SBCoverSheetPresentationManager) sharedInstance] isPresented]) {
                    [_feedbackGenerator impactOccurredWithIntensity:1.0];
                    [[%c(SBCoverSheetPresentationManager) sharedInstance] setCoverSheetPresented:YES animated:YES withCompletion:nil];
                }
            }
            else if (onRightEdge) {
                if (![[%c(SBControlCenterController) sharedInstance] isPresented]) {
                    [_feedbackGenerator impactOccurredWithIntensity:1.0];
                    [[%c(SBControlCenterController) sharedInstance] presentAnimated:YES];
                }
            }
        }
        
        %orig;
    }
%end
