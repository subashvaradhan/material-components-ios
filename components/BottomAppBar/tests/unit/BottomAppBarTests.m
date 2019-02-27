// Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <MaterialComponents/MaterialBottomAppBar.h>

#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCTest.h>

#import "../../src/private/MDCBottomAppBarLayer.h"
#import <MaterialComponents/MaterialNavigationBar.h>

@interface MDCBottomAppBarLayer (Testing)
- (UIBezierPath *)drawWithPathToCut:(UIBezierPath *)bottomBarPath
                            yOffset:(CGFloat)yOffset
                              width:(CGFloat)width
                             height:(CGFloat)height
                          arcRadius:(CGFloat)arcRadius
                         arcCenter1:(CGPoint)arcCenter1
                         arcCenter2:(CGPoint)arcCenter2;
- (UIBezierPath *)drawWithPlainPath:(UIBezierPath *)bottomBarPath
                            yOffset:(CGFloat)yOffset
                              width:(CGFloat)width
                             height:(CGFloat)height
                         arcCenter1:(CGPoint)arcCenter1
                         arcCenter2:(CGPoint)arcCenter2
                          arcRadius:(CGFloat)arcRadius;
@end

@interface MDCBottomAppBarView (Testing)
@property(nonatomic, strong) MDCNavigationBar *navBar;
@end

@interface BottomAppBarTests : XCTestCase
@property(nonatomic, strong) MDCBottomAppBarView *bottomAppBar;
@end

@implementation BottomAppBarTests

- (void)setUp {
  [super setUp];
  self.bottomAppBar = [[MDCBottomAppBarView alloc] init];
}

- (void)tearDown {
  self.bottomAppBar = nil;
  [super tearDown];
}

#pragma mark - Color

- (void)testLeadingBarItemTintColorDefault {
  // Then
  XCTAssertEqualObjects(self.bottomAppBar.leadingBarItemsTintColor, UIColor.blackColor);
}

- (void)testLeadingBarItemTintColorAppliesToNavigationBar {
  // When
  self.bottomAppBar.leadingBarItemsTintColor = UIColor.cyanColor;

  // Then
  XCTAssertEqualObjects(self.bottomAppBar.navBar.leadingBarItemsTintColor, UIColor.cyanColor);
}

- (void)testTrailingBarItemTintColorDefault {
  // Then
  XCTAssertEqualObjects(self.bottomAppBar.trailingBarItemsTintColor, UIColor.blackColor);
}

- (void)testTrailingBarItemTintColorAppliesToNavigationBar {
  // When
  self.bottomAppBar.trailingBarItemsTintColor = UIColor.purpleColor;

  // Then
  XCTAssertEqualObjects(self.bottomAppBar.navBar.trailingBarItemsTintColor, UIColor.purpleColor);
}

#pragma mark - Floating Button

- (void)testCustomizedFloatingButtonVerticalHeight {
  CGFloat veriticalOffset = 5;
  self.bottomAppBar.floatingButtonVerticalOffset = veriticalOffset;
  [self.bottomAppBar layoutSubviews];
  CGPoint floatingButtonPosition = self.bottomAppBar.floatingButton.center;
  CGPoint navigationBarPosition = self.bottomAppBar.navBar.frame.origin;
  XCTAssertEqualWithAccuracy(floatingButtonPosition.y + veriticalOffset, navigationBarPosition.y,
                             (CGFloat)0.001);
}

#pragma mark - Path test

- (void)testPathToAndFromEqualNumberOfPoints {
  // Given
  MDCBottomAppBarLayer *bottomAppLayer = [[MDCBottomAppBarLayer alloc] init];
  UIBezierPath *fakeToPath = [[UIBezierPath alloc] init];
  UIBezierPath *fakeFromPath = [[UIBezierPath alloc] init];
  CGFloat fakeYOffset = 38;
  CGFloat fakeWidth = 414;
  CGFloat fakeHeight = 130;
  CGFloat fakeArcRadius = 32;
  CGPoint fakeCenter = CGPointMake(207, 38);

  // When
  fakeToPath = [bottomAppLayer drawWithPathToCut:fakeToPath
                                         yOffset:fakeYOffset
                                           width:fakeWidth
                                          height:fakeHeight
                                       arcRadius:fakeArcRadius
                                      arcCenter1:fakeCenter
                                      arcCenter2:fakeCenter];
  fakeFromPath = [bottomAppLayer drawWithPlainPath:fakeFromPath
                                           yOffset:fakeYOffset
                                             width:fakeWidth
                                            height:fakeHeight
                                        arcCenter1:fakeCenter
                                        arcCenter2:fakeCenter
                                         arcRadius:fakeArcRadius];

  // Then
  XCTAssertEqual([self numberOfPointsInPath:fakeToPath], [self numberOfPointsInPath:fakeFromPath]);
}

- (int)numberOfPointsInPath:(UIBezierPath *)bezierPath {
  __block int numberOfPoints = 0;
  if (@available(iOS 11.0, *)) {
    CGPathApplyWithBlock(bezierPath.CGPath, ^(const CGPathElement *_Nonnull element) {
      switch (element->type) {
        case kCGPathElementMoveToPoint:
          numberOfPoints = numberOfPoints + 1;
          break;
        case kCGPathElementAddLineToPoint:
          numberOfPoints = numberOfPoints + 1;
          break;
        case kCGPathElementAddCurveToPoint:
          numberOfPoints = numberOfPoints + 3;
          break;
        case kCGPathElementAddQuadCurveToPoint:
          numberOfPoints = numberOfPoints + 2;
          break;
        case kCGPathElementCloseSubpath:
          break;
        default:
          break;
      }
    });
    return numberOfPoints;
  } else {
    return numberOfPoints;
  }
}

@end
