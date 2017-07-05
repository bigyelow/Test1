//
//  TestSwift.swift
//  Test1
//
//  Created by bigyelow on 05/07/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import UIKit

class TestSwift: NSObject {
  func test() {
    print("http".urlEncoded == "http")
    print("http://".urlEncoded == "http://")
    print("://douban.com".urlEncoded == "://douban.com")
    print("douban.com".urlEncoded == "douban.com")
    print("http://douban.com".urlEncoded == "http://douban.com")
    print("http://bigyelow@douban.com".urlEncoded == "http://bigyelow@douban.com")
    print("http://bigyelow:1@douban.com".urlEncoded == "http://bigyelow:1@douban.com")
    print("http://bigyelow:1@douban.com/".urlEncoded)
    print("http://bigyelow:1@douban.com/aa".urlEncoded == "http://bigyelow:1@douban.com/aa")
    print("http://bigyelow:1@douban.com/aa/bb".urlEncoded == "http://bigyelow:1@douban.com/aa/bb")
    print("http://bigyelow:1@douban.com/aa/bb/".urlEncoded == "http://bigyelow:1@douban.com/aa/bb/")
    print("http://bigyelow:1@douban.com/?type=a".urlEncoded == "http://bigyelow:1@douban.com/?type=a")
    print("http://bigyelow:1@douban.com?type=a".urlEncoded)
  }
}
