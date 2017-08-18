//
//  TestSwift.swift
//  Test1
//
//  Created by bigyelow on 05/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit

class TestSwift: NSObject {
  static func test() {
    
  }

  static func testEqual(_ urlString1: String?, _ urlString2: String?) {
    print("\n")

    if urlString1 == nil && urlString2 == nil {
      print("true")
      return
    } else if urlString1 == nil || urlString2 == nil {
      print("false")
      print("\nurl1 = \(urlString1 ?? "")\nurl2 = \(urlString2 ?? "")")
      return
    } else {
      guard let urlString1 = urlString1, let urlString2 = urlString2 else {
        assert(false)
      }
      print(urlString1 == urlString2)
      if (urlString1 != urlString2) {
        print("\nurl1 = \(urlString1)\nurl2 = \(urlString2)")
      }
    }
  }

}
