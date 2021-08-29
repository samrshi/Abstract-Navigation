//
//  NavvyTests.swift
//  NavvyTests
//
//  Created by Samuel Shi on 8/28/21.
//

@testable import Navvy
import XCTest

class NavvyDirectionTests: XCTestCase {
  func test_Direction_Forward() throws {
    let input = 0
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Forwards"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Backward() throws {
    let input = 180
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Backwards"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Acute() throws {
    let input = 45
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Left"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Right() throws {
    let input = 90
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Left"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Left_Positive_Obtuse() throws {
    let input = 135
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Left"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Acute() throws {
    let input = -45
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Right() throws {
    let input = -90
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Negative_Obtuse() throws {
    let input = -135
    let output = accessibilityHeadingDirection(angle: input)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Acute() throws {
    let input = 225.0
    let angle = accessibilityHeading(angle: input)
    let output = accessibilityHeadingDirection(angle: angle)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Right() throws {
    let input = 270.0
    let angle = accessibilityHeading(angle: input)
    let output = accessibilityHeadingDirection(angle: angle)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
  
  func test_Direction_Right_Positive_Obtuse() throws {
    let input = 315.0
    let angle = accessibilityHeading(angle: input)
    let output = accessibilityHeadingDirection(angle: angle)
    let expected = "Right"

    XCTAssertEqual(output, expected)
  }
}
