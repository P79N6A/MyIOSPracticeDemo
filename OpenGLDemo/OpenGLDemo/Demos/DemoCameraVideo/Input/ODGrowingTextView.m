//
//  ODTextView.m
//
//  Created by Hans Pinckaers on 29-06-10.
//
//	MIT License
//
//	Copyright (c) 2011 Hans Pinckaers
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

#import "ODGrowingTextView.h"
#import "ODTextViewInternal.h"

@interface ODGrowingTextView () <UITextViewDelegate>
-(void)commonInitialiser;
-(void)resizeTextView:(NSInteger)newSizeH;
-(void)growDidStop;
@end

@implementation ODGrowingTextView {
    ODTextViewInternal *internalTextView;
    NSUInteger maxLength;
    
    int maxNumberOfLines;
    int minNumberOfLines;
    int maxHeight;
    int minHeight;
    BOOL animateHeightChange;
    CGFloat animationDuration;
    
    UIEdgeInsets contentInset;
}

@dynamic maxNumberOfLines;
@dynamic minNumberOfLines;
@dynamic maxHeight;
@dynamic minHeight;
@dynamic placeholder;
@dynamic placeholderColor;
@dynamic maxLength;
@dynamic text;
@dynamic font;
@dynamic textColor;
@dynamic textAlignment;
@dynamic selectedRange;
@dynamic editable;
@dynamic dataDetectorTypes;
@dynamic returnKeyType;
@dynamic keyboardType;
@dynamic contentInset;
@dynamic isScrollable;
@dynamic enablesReturnKeyAutomatically;
@dynamic internalTextView;

- (void)dealloc {
    if (internalTextView) {
        [internalTextView release];
        internalTextView = nil;
    }
    
    [super dealloc];
}

// having initwithcoder allows us to use ODGrowingTextView in a Nib. -- aob, 9/2011
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInitialiser];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser];
    }
    return self;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
- (id)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser:textContainer];
    }
    return self;
}

-(void)commonInitialiser {
    [self commonInitialiser:nil];
}

-(void)commonInitialiser:(NSTextContainer *)textContainer
#else
-(void)commonInitialiser
#endif
{
    // Initialization code
    CGRect r = self.frame;
    r.origin.y = 0;
    r.origin.x = 0;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    internalTextView = [[ODTextViewInternal alloc] initWithFrame:r textContainer:textContainer];
#else
    internalTextView = [[ODTextViewInternal alloc] initWithFrame:r];
#endif
    internalTextView.delegate = self;
    internalTextView.scrollEnabled = NO;
    internalTextView.font = [UIFont fontWithName:@"Helvetica" size:13];
    internalTextView.contentInset = UIEdgeInsetsZero;
    internalTextView.showsHorizontalScrollIndicator = NO;
    internalTextView.text = @"-";
    internalTextView.contentMode = UIViewContentModeRedraw;
    [self addSubview:internalTextView];
    
    minHeight = internalTextView.CZ_F_SizeH;
    minNumberOfLines = 1;
    
    animateHeightChange = YES;
    animationDuration = 0.1f;
    
    internalTextView.text = @"";
    
    [self setMaxNumberOfLines:3];
    
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    internalTextView.displayPlaceHolder = YES;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    if (self.text.length == 0) {
        size.height = minHeight;
    }
    return size;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.bounds;
    r.origin.y = 0;
    r.origin.x = contentInset.left;
    r.size.width -= contentInset.left + contentInset.right;
    internalTextView.frame = r;
}

-(void)setContentInset:(UIEdgeInsets)inset
{
    contentInset = inset;
    
    CGRect r = self.frame;
    r.origin.y = inset.top - inset.bottom;
    r.origin.x = inset.left;
    r.size.width -= inset.left + inset.right;
    
    CZ_setFrame(internalTextView, r);
    
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIEdgeInsets)contentInset
{
    return contentInset;
}

-(void)setMaxNumberOfLines:(int)n
{
    if(n == 0 && maxHeight > 0) return; // the user specified a maxHeight themselves.
    
    // Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text;
    NSString *newText = @"-";
    
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < n; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    maxHeight = [self measureHeight];
    
    internalTextView.text = saveText;
    CZ_SetUIViewHiddenNO(internalTextView);
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    maxNumberOfLines = n;
}

-(int)maxNumberOfLines
{
    return maxNumberOfLines;
}

- (void)setMaxHeight:(int)height
{
    maxHeight = height;
    maxNumberOfLines = 0;
}

-(void)setMinNumberOfLines:(int)m
{
    if(m == 0 && minHeight > 0) return; // the user specified a minHeight themselves.
    
    // Use internalTextView for height calculations, thanks to Gwynne <http://blog.darkrainfall.org/>
    NSString *saveText = internalTextView.text;
    NSString *newText = @"-";
    
    internalTextView.delegate = nil;
    CZ_SetUIViewHiddenYES(internalTextView);
    
    for (int i = 1; i < m; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    
    minHeight = [self measureHeight];
    
    internalTextView.text = saveText;
    CZ_SetUIViewHiddenNO(internalTextView);
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    minNumberOfLines = m;
}

-(int)minNumberOfLines
{
    return minNumberOfLines;
}

- (void)setMinHeight:(int)height
{
    minHeight = height;
    minNumberOfLines = 0;
}

- (NSString *)placeholder
{
    return internalTextView.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [internalTextView setPlaceholder:placeholder];
    [internalTextView setNeedsDisplay];
}

- (UIColor *)placeholderColor
{
    return internalTextView.placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [internalTextView setPlaceholderColor:placeholderColor];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self checkLength];
    [self refreshHeight];
}

- (void)checkLength{
    NSRange range;
    NSString *str = internalTextView.text;
    NSUInteger count = 0;
    NSUInteger i = 0;
    
    UITextRange *selectedRange = [internalTextView markedTextRange];
    UITextPosition *pos = [internalTextView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && pos) {
        return;
    }
    
    for (; i < str.length && count < maxLength; i += range.length, count++) {
        range = [str rangeOfComposedCharacterSequenceAtIndex:i];
    }
    if (count == maxLength && i < str.length && i > 0) {
        [internalTextView.textStorage deleteCharactersInRange:NSMakeRange(i, str.length - i)];
    }
}

- (void)refreshHeight
{
    //size of content, so we can set the frame of self
    NSInteger newSizeH = [self measureHeight];
    if (newSizeH < minHeight || !internalTextView.hasText) {
        newSizeH = minHeight; //not smalles than minHeight
    }
    else if (maxHeight && newSizeH > maxHeight) {
        newSizeH = maxHeight; // not taller than maxHeight
    }
    
    if (internalTextView.CZ_F_SizeH != newSizeH)
    {
        // if our new height is greater than the maxHeight
        // sets not set the height or move things
        // around and enable scrolling
        if (newSizeH >= maxHeight)
        {
            if(!internalTextView.scrollEnabled){
                internalTextView.scrollEnabled = YES;
                [internalTextView flashScrollIndicators];
            }
            
        } else {
            internalTextView.scrollEnabled = NO;
        }
        
        // [fixed] Pasting too much text into the view failed to fire the height change,
        // thanks to Gwynne <http://blog.darkrainfall.org/>
        if (newSizeH <= maxHeight)
        {
            if(animateHeightChange) {
                
                if ([UIView resolveClassMethod:@selector(animateWithDuration:animations:)]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
                    [UIView animateWithDuration:animationDuration
                                          delay:0
                                        options:(UIViewAnimationOptionAllowUserInteraction|
                                                 UIViewAnimationOptionBeginFromCurrentState)
                                     animations:^(void) {
                                         [self resizeTextView:newSizeH];
                                     }
                                     completion:^(BOOL finished) {
                                         if ([self.delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
                                             [self.delegate growingTextView:self didChangeHeight:newSizeH];
                                         }
                                     }];
#endif
                } else {
                    [UIView beginAnimations:@"" context:nil];
                    [UIView setAnimationDuration:animationDuration];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(growDidStop)];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [self resizeTextView:newSizeH];
                    [UIView commitAnimations];
                }
            } else {
                [self resizeTextView:newSizeH];
                // [fixed] The growingTextView:didChangeHeight: delegate method was not called at all when not animating height changes.
                // thanks to Gwynne <http://blog.darkrainfall.org/>
                
                if ([self.delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
                    [self.delegate growingTextView:self didChangeHeight:newSizeH];
                }
            }
        }
    }
    // Display (or not) the placeholder string
    
    BOOL wasDisplayingPlaceholder = internalTextView.displayPlaceHolder;
    internalTextView.displayPlaceHolder = internalTextView.text.length == 0;
    
    if (wasDisplayingPlaceholder != internalTextView.displayPlaceHolder) {
        [internalTextView setNeedsDisplay];
    }
    
    
    // scroll to caret (needed on iOS7)
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        [self performSelector:@selector(resetScrollPositionForIOS7) withObject:nil afterDelay:0.1f];
    }
    
    // Tell the delegate that the text view changed
    if ([self.delegate respondsToSelector:@selector(growingTextViewDidChange:)]) {
        [self.delegate growingTextViewDidChange:self];
    }
}

// Code from apple developer forum - @Steve Krulewitz, @Mark Marszal, @Eric Silverberg
- (CGFloat)measureHeight
{
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        return ceilf([internalTextView sizeThatFits:internalTextView.frame.size].height);
    }
    else {
        return internalTextView.contentSize.height;
    }
}

- (void)resetScrollPositionForIOS7
{
    CGRect r = [internalTextView caretRectForPosition:internalTextView.selectedTextRange.end];
    CGFloat l = r.origin.y - internalTextView.CZ_F_SizeH + r.size.height + 8;
    CGFloat caretY =  l > 0 ? l : 0;
    if (internalTextView.contentOffset.y < caretY)
        internalTextView.contentOffset = CGPointMake(0, caretY);
}

-(void)resizeTextView:(NSInteger)newSizeH
{
    if ([self.delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
        [self.delegate growingTextView:self willChangeHeight:newSizeH];
    }
    
    CGRect internalTextViewFrame = self.frame;
    internalTextViewFrame.size.height = newSizeH; // + padding
    CZ_setFrame(self, internalTextViewFrame);
    
    internalTextViewFrame.origin.y = contentInset.top - contentInset.bottom;
    internalTextViewFrame.origin.x = contentInset.left;
    
    if(!CGRectEqualToRect(internalTextView.frame, internalTextViewFrame)) internalTextView.frame = internalTextViewFrame;
}

- (void)growDidStop
{
    // scroll to caret (needed on iOS7)
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        [self resetScrollPositionForIOS7];
    }
    
    if ([self.delegate respondsToSelector:@selector(growingTextView:didChangeHeight:)]) {
        [self.delegate growingTextView:self didChangeHeight:self.CZ_F_SizeH];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [internalTextView becomeFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [internalTextView becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [internalTextView resignFirstResponder];
}

-(BOOL)isFirstResponder
{
    return [internalTextView isFirstResponder];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UITextView properties
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setText:(NSString *)newText
{
    internalTextView.text = newText;
    
    // include this line to analyze the height of the textview.
    // fix from Ankit Thakur
    [self performSelector:@selector(textViewDidChange:) withObject:internalTextView];
}

-(NSString*) text
{
    return internalTextView.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setFont:(UIFont *)afont
{
    internalTextView.font = afont;
    
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
    return internalTextView.font;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextColor:(UIColor *)color
{
    internalTextView.textColor = color;
}

-(UIColor*)textColor{
    return internalTextView.textColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    internalTextView.backgroundColor = backgroundColor;
}

-(UIColor*)backgroundColor
{
    return internalTextView.backgroundColor;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setTextAlignment:(NSTextAlignment)aligment
{
    internalTextView.textAlignment = aligment;
}

-(NSTextAlignment)textAlignment
{
    return internalTextView.textAlignment;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setSelectedRange:(NSRange)range
{
    internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
    return internalTextView.selectedRange;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setIsScrollable:(BOOL)isScrollable
{
    internalTextView.scrollEnabled = isScrollable;
}

- (BOOL)isScrollable
{
    return internalTextView.scrollEnabled;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setEditable:(BOOL)beditable
{
    internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
    return internalTextView.editable;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
    internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
    return internalTextView.returnKeyType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setKeyboardType:(UIKeyboardType)keyType
{
    internalTextView.keyboardType = keyType;
}

- (UIKeyboardType)keyboardType
{
    return internalTextView.keyboardType;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
{
    internalTextView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}

- (BOOL)enablesReturnKeyAutomatically
{
    return internalTextView.enablesReturnKeyAutomatically;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setDataDetectorTypes:(UIDataDetectorTypes)datadetector
{
    internalTextView.dataDetectorTypes = datadetector;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
    return internalTextView.dataDetectorTypes;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)hasText{
    return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [internalTextView scrollRangeToVisible:range];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(growingTextViewShouldBeginEditing:)]) {
        return [self.delegate growingTextViewShouldBeginEditing:self];
        
    } else {
        return YES;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(growingTextViewShouldEndEditing:)]) {
        return [self.delegate growingTextViewShouldEndEditing:self];
        
    } else {
        return YES;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(growingTextViewDidBeginEditing:)]) {
        [self.delegate growingTextViewDidBeginEditing:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(growingTextViewDidEndEditing:)]) {
        [self.delegate growingTextViewDidEndEditing:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)atext {
    
    //weird 1 pixel bug when clicking backspace when textView is empty
    if(![textView hasText] && [atext isEqualToString:@""]) return NO;
    
    if ([atext isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(growingTextViewShouldReturn:)]) {
            if (![self.delegate performSelector:@selector(growingTextViewShouldReturn:) withObject:self]) {
                return YES;
            } else {
                //[textView resignFirstResponder];
                return NO;
            }
        }
    }
    
    //Added by bretdabaker: sometimes we want to handle this ourselves
    if ([self.delegate respondsToSelector:@selector(growingTextView:shouldChangeTextInRange:replacementText:)])
        return [self.delegate growingTextView:self shouldChangeTextInRange:range replacementText:atext];
    
    
    
    return YES;
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(growingTextViewDidChangeSelection:)]) {
        [self.delegate growingTextViewDidChangeSelection:self];
    }
}

- (void)setMaxLength:(NSUInteger)length {
    maxLength = length;
}

- (NSUInteger)maxLength {
    return maxLength;
}

- (UITextView *)internalTextView {
    return internalTextView;
}

@end
