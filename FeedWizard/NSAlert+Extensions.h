//
//  NSAlert+Extensions.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/16/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

// private methods
@interface NSAlert (CheckboxAdditions)
- (void)prepare;
- (id)buildAlertStyle:(int)fp8 title:(id)fp12 formattedMsg:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32;
- (id)buildAlertStyle:(int)fp8 title:(id)fp12 message:(id)fp16 first:(id)fp20 second:(id)fp24 third:(id)fp28 oldStyle:(BOOL)fp32 args:(char *)fp36;
@end

@interface NSAlertCheckbox : NSAlert 
{
	NSButton *_checkbox;
}

+ (NSAlertCheckbox *)alertWithMessageText:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton informativeText:(NSString *)format;

- (BOOL)showsCheckbox;
- (void)setShowsCheckbox:(BOOL)showsCheckbox;

- (NSString *)checkboxText;
- (void)setCheckboxText:(NSString *)text;

- (NSInteger)checkboxState;
- (void)setCheckboxState:(NSInteger)state;

@end
