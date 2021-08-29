//
//  NavvyTests.swift
//  NavvyTests
//
//  Created by Samuel Shi on 8/28/21.
//

@testable import Navvy
import XCTest

class NavvyAccessibilityHeadingTests: XCTestCase {
  func test_Direction_Forward() throws {
    let input = 0.0
    let output = accessibilityHeading(angle: input)
    let expected = 0

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Backward() throws {
    let input = 180.0
    let output = accessibilityHeading(angle: input)
    let expected = 180

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Acute() throws {
    let input = 45.0
    let output = accessibilityHeading(angle: input)
    let expected = 45

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Right() throws {
    let input = 90.0
    let output = accessibilityHeading(angle: input)
    let expected = 90

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Obtuse() throws {
    let input = 135.0
    let output = accessibilityHeading(angle: input)
    let expected = 135

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Acute() throws {
    let input = -45.0
    let output = accessibilityHeading(angle: input)
    let expected = -45

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Right() throws {
    let input = -90.0
    let output = accessibilityHeading(angle: input)
    let expected = -90

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Obtuse() throws {
    let input = -135.0
    let output = accessibilityHeading(angle: input)
    let expected = -135

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Acute() throws {
    let input = 225.0
    let output = accessibilityHeading(angle: input)
    let expected = -135

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Right() throws {
    let input = 270.0
    let output = accessibilityHeading(angle: input)
    let expected = -90

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Obtuse() throws {
    let input = 315.0
    let output = accessibilityHeading(angle: input)
    let expected = -45

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Acute_Big() throws {
    let input = 585.0
    let output = accessibilityHeading(angle: input)
    let expected = 135

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Right_Big() throws {
    let input = 630.0
    let output = accessibilityHeading(angle: input)
    let expected = 90

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Obtuse_Big() throws {
    let input = 675.0
    let output = accessibilityHeading(angle: input)
    let expected = 45

    XCTAssertEqual(output, expected)
  }
  
  func test_Big() throws {
    let input = 393.0
    let output = accessibilityHeading(angle: input)
    let expected = 33

    XCTAssertEqual(output, expected)
  }
}
