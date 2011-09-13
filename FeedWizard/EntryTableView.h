//
//  EntryTableView.h
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/13/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

@interface NSObject (EntryTableViewDelegate)

- (NSMenu *)tableView:(NSTableView *)tableView menuForEvent:(NSEvent *)event;

@end

@interface EntryTableView : NSTableView

@end
