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

#ifndef TDTestScaffold_h
#define TDTestScaffold_h

#define TDTrue(e) XCTAssertTrue((e), @"")
#define TDFalse(e) XCTAssertFalse((e), @"")
#define TDNil(e) XCTAssertNil((e), @"")
#define TDNotNil(e) XCTAssertNotNil((e), @"")
#define TDEquals(e1, e2) XCTAssertEqual((e1), (e2), @"")
#define TDEqualObjects(e1, e2) XCTAssertEqualObjects((e1), (e2), @"")

#endif /* TDTestScaffold_h */
