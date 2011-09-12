//
//  AMButtonBar.h
//  ButtonBarTest
//
//  Created by Andreas on 09.02.07.
//  Copyright 2007 Andreas Mayer. All rights reserved.
//  Copyright 2011 Hardcoded Software (http://www.hardcoded.net)
//

#import <Cocoa/Cocoa.h>

@class AMButtonBarItem;
@class AMButtonBarCell;

extern NSString *const AMButtonBarSelectionDidChangeNotification;


@interface NSObject (AMButtonBarDelegate)
- (void)buttonBarSelectionDidChange:(NSNotification *)aNotification;
@end


@interface AMButtonBar : NSView {
	id delegate;
	BOOL delegateRespondsToSelectionDidChange;
	NSGradient *backgroundGradient;
	NSColor *baselineSeparatorColor;
	BOOL showsBaselineSeparator;
	BOOL allowsMultipleSelection;
	NSMutableArray *items;
	AMButtonBarCell *buttonCell;
	BOOL needsLayout;
}


- (id)initWithFrame:(NSRect)frame;

- (AMButtonBarCell *)buttonCell;

- (NSArray *)items;

- (NSString *)selectedItemIdentifier;
- (NSArray *)selectedItemIdentifiers;

- (AMButtonBarItem *)itemAtIndex:(int)index;

- (void)insertItem:(AMButtonBarItem *)item atIndex:(int)index;

- (void)removeItem:(AMButtonBarItem *)item;
- (void)removeItemAtIndex:(int)index;
- (void)removeAllItems;

- (void)enableAllItems:(BOOL)enable;

- (void)selectItemWithIdentifier:(NSString *)identifier;
- (void)selectItemsWithIdentifiers:(NSArray *)identifierList;

- (id)delegate;
- (void)setDelegate:(id)value;

- (BOOL)allowsMultipleSelection;
- (void)setAllowsMultipleSelection:(BOOL)value;

- (NSGradient *)backgroundGradient;
- (void)setBackgroundGradient:(NSGradient *)value;

- (NSColor *)baselineSeparatorColor;
- (void)setBaselineSeparatorColor:(NSColor *)value;

- (BOOL)showsBaselineSeparator;
- (void)setShowsBaselineSeparator:(BOOL)value;
@end
