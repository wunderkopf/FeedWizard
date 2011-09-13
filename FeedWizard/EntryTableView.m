//
//  EntryTableView.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "EntryTableView.h"

@implementation EntryTableView

- (NSMenu *)menuForEvent:(NSEvent *)event 
{
    return [[self delegate] tableView:self menuForEvent:event];
}

@end
