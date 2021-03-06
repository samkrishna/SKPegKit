//
//  TDTestScaffold.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

//
//  TDTestScaffold.h
//  TDTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

@import Foundation;
@import XCTest;

#import <SKPegKit/SKPegKit.h>
#import <OCMock/OCMock.h>

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

#define TD_EMIT 0

#define VERIFY()     @try { [_mock verify]; } @catch (NSException *ex) { NSString *msg = [ex reason]; XCTAssertTrue(0, @"%@", msg); }

extern NSString *TDAssembly(NSString *s);

