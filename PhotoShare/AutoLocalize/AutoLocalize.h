//
//  AutoLocalize.h
//  AutoLocalize
//
//  Created by Stefan Matthias Aust on 05.08.11.
//  Copyright 2011 I.C.N.H. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (ICNH)

/// Localize all strings settable by IB which start with %.
- (void)icnh_autoLocalize;

@end


@interface UIView (ICNH)

/// Localize all strings settable by IB which start with %.
- (void)icnh_autoLocalize;

@end
