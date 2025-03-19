#import "header.h"

double initialDistance = 0;
static UIImpactFeedbackGenerator* _feedbackGenerator;

%hook SBFluidSwitcherGestureManager

    -(void)grabberTongueBeganPulling:(id)arg1 withDistance:(double)arg2 andVelocity:(double)arg3 andGesture:(id)arg4 {
        initialDistance = arg2;
        CGPoint point = [[self.deckGrabberTongue valueForKey:@"_edgePullGestureRecognizer"] locationInView:[self.deckGrabberTongue valueForKey:@"_tongueContainer"]];
        int orientation = [((SpringBoard *)[UIApplication sharedApplication]) _frontMostAppOrientation];

        bool onLeftEdge = point.x < 60;
        bool onRightEdge = point.x > [UIScreen mainScreen].bounds.size.width - 60;     

        if (orientation == 1 && (onLeftEdge || onRightEdge)) {
            if (!_feedbackGenerator)
                _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];            
                
            [_feedbackGenerator prepare]; 
        }
        else {
            %orig;
        }
    }

    -(void)grabberTongueEndedPulling:(id)arg1 withDistance:(double)finalDistance andVelocity:(double)arg3 andGesture:(id)arg4  {
        %orig;

        if(finalDistance - initialDistance <= 20) {
            return;
        }        

        CGPoint point = [[self.deckGrabberTongue valueForKey:@"_edgePullGestureRecognizer"] locationInView:[self.deckGrabberTongue valueForKey:@"_tongueContainer"]];
        int orientation = [((SpringBoard *)[UIApplication sharedApplication]) _frontMostAppOrientation];

        bool onLeftEdge = point.x < 60;
        bool onRightEdge = point.x > [UIScreen mainScreen].bounds.size.width - 60;        

        if (orientation == 1 && (onLeftEdge || onRightEdge)) {
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
    }
%end
