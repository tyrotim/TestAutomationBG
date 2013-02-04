//
//  BGCBGLoginViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/8/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCLoginViewController.h"
#import "BGMSLoginNetworkCall.h"
#import "BGMSubscriptionManager.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface BGCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextInputBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextInputBox;
@property (nonatomic, assign) BOOL isShiftedForKeyboard;

@property (nonatomic, assign) CGFloat animatedDistance;

@end

@implementation BGCLoginViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShiftedForKeyboard = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender
{    
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickedFromLogin)]) {
        [self.delegate cancelButtonClickedFromLogin];
    }
}

- (IBAction)loginButtonPressed:(id)sender
{
    [self logIn];
}

- (void)logIn
{
    BGMSLoginNetworkCall *call = [[BGMSLoginNetworkCall alloc] init];
    call.username = self.emailTextInputBox.text;
    call.password = self.passwordTextInputBox.text;
    
    [call executeAsyncWithSuccessBlock:^(void){
        // Call succeeded, but not guaranteed to log in
        if (call.userData) {
            
            [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:[call.userData objectForKey:Token] recipt:nil subscription:BGPrintSubscription];
            [[NSNotificationCenter defaultCenter] postNotificationName:BOSTON_GLOBE_LOGIN_SUCCEEDED_NOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RESET_SETTINGS_TAB_CLICK_NOTIFICATION object:nil];

        }
    } failureBlock:^(NSError *error){
        // Call failed
        UIAlertView *callFailedAlert = [[UIAlertView alloc] initWithTitle: @"Call Failed"
                                                                  message: @"The login call was unable to complete!"
                                                                 delegate: nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [callFailedAlert show];
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        self.animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self logIn];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
