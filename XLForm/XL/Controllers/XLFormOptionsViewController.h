//
//  XLFormOptionsViewController.h
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Created by Martin Barreto on 31/3/14.
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

@class XLFormOptionsViewController;

@protocol XLSelectorTableViewControllerProtocol <NSObject>

@property NSString * tag;

@end

@protocol XLFormOptionsViewControllerDelegate <NSObject>

@required
-(NSArray *)optionsViewControllerOptions:(XLFormOptionsViewController *)optionsViewController;

@optional
-(void)optionsViewController:(id<XLSelectorTableViewControllerProtocol>)optionsViewController didSelectOption:(id)option atIndex:(NSIndexPath *)indexPath;
-(void)optionsViewController:(id<XLSelectorTableViewControllerProtocol>)optionsViewController didDeselectOption:(id)option atIndex:(NSIndexPath *)indexPah;
-(BOOL)optionsViewControllerOptions:(id<XLSelectorTableViewControllerProtocol>)optionsViewController isOptionSelected:(id)option;

@end


@interface XLFormOptionsViewController : UITableViewController

@property (nonatomic) NSIndexSet * selectedIndexSet;
@property (nonatomic) NSString * tag;
@property (readonly) NSString * valueKey;
@property (readonly) NSString * titleHeaderSection;
@property (readonly) NSString * titleFooterSection;

- (id)initWithDelegate:(id<XLFormOptionsViewControllerDelegate>)delegate;

- (id)initWithDelegate:(id<XLFormOptionsViewControllerDelegate>)delegate
     multipleSelection:(BOOL)multipleSelection;

- (id)initWithDelegate:(id<XLFormOptionsViewControllerDelegate>)delegate
     multipleSelection:(BOOL)multipleSelection
                 style:(UITableViewStyle)style;

- (id)initWithDelegate:(id<XLFormOptionsViewControllerDelegate>)delegate
     multipleSelection:(BOOL)multipleSelection
                 style:(UITableViewStyle)style
    titleHeaderSection:(NSString *)titleHeaderSection
    titleFooterSection:(NSString *)titleFooterSection;

- (void)reloadOptions;

@end

// Protected fields
@interface XLFormOptionsViewController()

@property NSArray * options;
@property (weak) id<XLFormOptionsViewControllerDelegate> delegate;
@property BOOL isMultipleSelection;

@end
