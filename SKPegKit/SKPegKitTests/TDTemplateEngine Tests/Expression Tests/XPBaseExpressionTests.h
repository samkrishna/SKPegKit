//
//  XPBaseExpressionTests.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "TDTestScaffold.h"

@interface XPBaseExpressionTests : XCTestCase
- (NSArray *)tokenize:(NSString *)input;

@property (nonatomic, readwrite, strong) TDTemplateEngine *eng;
@property (nonatomic, readwrite, strong) XPExpression *expr;
@property (nonatomic, readwrite, strong) PKTokenizer *t;

@end
