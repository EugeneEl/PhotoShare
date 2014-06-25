//
//  AutoLocalize.m
//  AutoLocalize
//
//  Created by Stefan Matthias Aust on 05.08.11.
//  Copyright 2011 I.C.N.H. All rights reserved.
//

#import "AutoLocalize.h"


/// Like NSLocalizedString macro, but returning the key unchanged if no value is found.
static NSString *L(NSString *key) {
    return [[NSBundle mainBundle] localizedStringForKey:key value:key table:nil];
}


/// Localize string if it starts with %, otherwise return unchanged.
static NSString *AutoLocalize(NSString *string) {
    if (string && [string hasPrefix:@"%"]) {
        string = L(string);
    }
    return string;
}


@implementation UIViewController (ICNH)

/// Localize the controller's view, the optional navigation item and all tab bar items.
- (void)icnh_autoLocalize {
    // need to translate all items or all view controllers now
    UITabBarController *tabBarController = self.tabBarController;
    if (tabBarController) {
        for (UIViewController *viewController in tabBarController.viewControllers) {
            UITabBarItem *tabBarItem = viewController.tabBarItem;
            if (tabBarItem) {
                tabBarItem.title = AutoLocalize(tabBarItem.title);
            }
        }
    }
    
    UINavigationItem *navigationItem = self.navigationItem;
    if (navigationItem) {
        navigationItem.title = AutoLocalize(navigationItem.title);
        navigationItem.prompt = AutoLocalize(navigationItem.prompt);
        navigationItem.leftBarButtonItem.title = AutoLocalize(navigationItem.leftBarButtonItem.title);
        navigationItem.rightBarButtonItem.title = AutoLocalize(navigationItem.rightBarButtonItem.title);
        navigationItem.backBarButtonItem.title = AutoLocalize(navigationItem.backBarButtonItem.title);
    }

    [self.view icnh_autoLocalize];
}

@end

@implementation UIView (ICNH)

/// Localize this view and all subviews. For generic views, accessibility stuff is translated.
- (void)icnh_autoLocalize {
    for (UIView *view in self.subviews) {
        [view icnh_autoLocalize];
    }
    if (self.isAccessibilityElement) {
        self.accessibilityHint = AutoLocalize(self.accessibilityHint);
        self.accessibilityLabel = AutoLocalize(self.accessibilityLabel);
    }
}

@end

@implementation UILabel (ICNH)

/// Localize the label's text.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    self.text = AutoLocalize(self.text);
}

@end

@implementation UIButton (ICNH)

/// Localize the button's four state labels.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateNormal]) forState:UIControlStateNormal];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateHighlighted]) forState:UIControlStateHighlighted];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateSelected]) forState:UIControlStateSelected];
    [self setTitle:AutoLocalize([self titleForState:UIControlStateDisabled]) forState:UIControlStateDisabled];
}

@end

@implementation UISegmentedControl (ICNH)

/// Localize the segmented control's title.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    for (NSUInteger index = 0; index < self.numberOfSegments; index++) {
        [self setTitle:AutoLocalize([self titleForSegmentAtIndex:index]) forSegmentAtIndex:index];
    }
}

@end

@implementation UITextField (ICNH)

/// Localize the text field's text and placeholder.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    self.text = AutoLocalize(self.text);
    self.placeholder = AutoLocalize(self.placeholder);
}

@end

@implementation UITextView (ICNH)

/// Localize the text view's text.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    self.text = AutoLocalize(self.text);
}

@end

@implementation UISearchBar (ICNH)

/// Localize text search field's text, placeholder, prompt and scope titles.
- (void)icnh_autoLocalize {
    [super icnh_autoLocalize];
    self.text = AutoLocalize(self.text);
    self.placeholder = AutoLocalize(self.placeholder);
    self.prompt = AutoLocalize(self.prompt);
    NSArray *scopeButtonTitles = self.scopeButtonTitles;
    if ([scopeButtonTitles count]) {
        NSMutableArray *translatedScopeButtonTitles = [NSMutableArray arrayWithCapacity:[scopeButtonTitles count]];
        for (NSString *title in scopeButtonTitles) {
            [translatedScopeButtonTitles addObject:AutoLocalize(title)];
        }
        self.scopeButtonTitles = translatedScopeButtonTitles;
    }
}

@end

@implementation UIToolbar (ICNH)

/// Localize the toolbar's items.
- (void)icnh_autoLocalize {
    for (UIBarButtonItem *item in self.items) {
        item.title = AutoLocalize(item.title);
    }
}

@end
