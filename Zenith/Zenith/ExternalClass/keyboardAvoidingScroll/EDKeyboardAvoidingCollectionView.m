//
//  TPKeyboardAvoidingCollectionView.m
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2013 A Tasty Pixel & The CocoaBots. All rights reserved.
//

#import "EDKeyboardAvoidingCollectionView.h"

@interface EDKeyboardAvoidingCollectionView () <UITextFieldDelegate, UITextViewDelegate>
@end

@implementation EDKeyboardAvoidingCollectionView

#pragma mark - Setup/Teardown

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EDKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EDKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if ( !(self = [super initWithFrame:frame collectionViewLayout:layout]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self EDKeyboardAvoiding_updateContentInset];
}

-(void)setContentSize:(CGSize)contentSize {
    if (CGSizeEqualToSize(contentSize, self.contentSize)) {
        // Prevent triggering contentSize when it's already the same that
        // cause weird infinte scrolling and locking bug
        return;
    }
    [super setContentSize:contentSize];
    [self EDKeyboardAvoiding_updateContentInset];
}

- (BOOL)focusNextTextField {
    return [self EDKeyboardAvoiding_focusNextTextField];
    
}
- (void)scrollToActiveTextField {
    return [self EDKeyboardAvoiding_scrollToActiveTextField];
}

#pragma mark - Responders, events

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ( !newSuperview ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(EDKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self EDKeyboardAvoiding_findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( ![self focusNextTextField] ) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(EDKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    [self performSelector:@selector(EDKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) withObject:self afterDelay:0.1];
}

@end
