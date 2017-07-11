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
    // 没有中文字符
    testEqual("".urlEncoded, "")
    testEqual(" ".urlEncoded, " ")
    testEqual("adfasd".urlEncoded, "adfasd")
    testEqual("http".urlEncoded, "http")
    testEqual("http://".urlEncoded, "http://")
    testEqual("://douban.com".urlEncoded, "://douban.com")
    testEqual("douban.com".urlEncoded, "douban.com")
    testEqual("http://douban.com".urlEncoded, "http://douban.com")
    testEqual("http://bigyelow@douban.com".urlEncoded, "http://bigyelow@douban.com")
    testEqual("http://bigyelow@douban.com:8080".urlEncoded, "http://bigyelow@douban.com:8080")
    testEqual("http://bigyelow:1@douban.com".urlEncoded, "http://bigyelow:1@douban.com")
    testEqual("http://bigyelow:1@douban.com/".urlEncoded, "http://bigyelow:1@douban.com") // Host's lat "/" will be removed
    testEqual("http://bigyelow:1@douban.com/aa".urlEncoded, "http://bigyelow:1@douban.com/aa")
    testEqual("http://bigyelow:1@douban.com/aa/bb".urlEncoded, "http://bigyelow:1@douban.com/aa/bb")
    testEqual("http://bigyelow:1@douban.com/aa/bb/".urlEncoded, "http://bigyelow:1@douban.com/aa/bb/")  // Note last "/"
    testEqual("http://bigyelow:1@douban.com/?type=a".urlEncoded, "http://bigyelow:1@douban.com?type=a") // Host's lat "/" will be removed
    testEqual("http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a#frag".urlEncoded, "http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a#frag")  // Note last "/"
    testEqual("http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a&type1=1&type2=2&type3=3&type4=http:douban.com/ddd?xx=yy&xx=zzdd".urlEncoded, "http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a&type1=1&type2=2&type3=3&type4=http:douban.com/ddd?xx=yy&xx=zzdd")
    testEqual("http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a&type1=1&type2=2&type3=3&type4=http://douban.com/ddd?xx=yy&xx=zzdd#fragment".urlEncoded, "http://bigyelow:1@douban.com/aa/bb/cc/new_dad?type=a&type1=1&type2=2&type3=3&type4=http://douban.com/ddd?xx=yy&xx=zzdd#fragment")

    // 有中文字符
    testEqual("电影".urlEncoded, "电影")
    testEqual("http://电影.com/".urlEncoded, "http://%E7%94%B5%E5%BD%B1.com")
    testEqual("http://测试:1232@电影.com/".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com")
    testEqual("http://电影.com/".urlEncoded, "http://%E7%94%B5%E5%BD%B1.com")
    testEqual("http://测试:1232@电影.com/path1/小电影".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1")
    testEqual("http://测试:1232@电影.com/path1/小电影/".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1/")
    testEqual("http://测试:1232@电影.com/path1/小电影?type=1&时间=很多".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A")
    testEqual("http://电影.com/path1/小电影?type=1&时间=很多".urlEncoded, "http://%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A")
    testEqual("http://测试:1232@电影.com/path1/小电影?type=1&时间=很多".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A")
    testEqual("http://测试:1232@电影.com:8080/path1/小电影?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com:8080/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89")
    testEqual("http://测试:1232@电影.com/path1/小电影?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#frag".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#frag")
    testEqual("http://测试:1232@电影.com/path1/小电影?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#哈哈".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#%E5%93%88%E5%93%88")
    testEqual("http://电影.com/path1/小电影?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#哈哈".urlEncoded, "http://%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#%E5%93%88%E5%93%88")
    testEqual("http://测试:1232dewef[];'@电影.com/path1/小电影?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#哈哈".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232dewef%5B%5D;'@%E7%94%B5%E5%BD%B1.com/path1/%E5%B0%8F%E7%94%B5%E5%BD%B1?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#%E5%93%88%E5%93%88")
    testEqual("http://测试:1232dewef[];'@电影.com?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#哈哈".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232dewef%5B%5D;'@%E7%94%B5%E5%BD%B1.com?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#%E5%93%88%E5%93%88")
    testEqual("http://测试:1232dewef[];'@电影.com/?type=1&时间=很多&redir=douban://douban.com/世界很大?类型=没有#哈哈".urlEncoded, "http://%E6%B5%8B%E8%AF%95:1232dewef%5B%5D;'@%E7%94%B5%E5%BD%B1.com?type=1&%E6%97%B6%E9%97%B4=%E5%BE%88%E5%A4%9A&redir=douban://douban.com/%E4%B8%96%E7%95%8C%E5%BE%88%E5%A4%A7?%E7%B1%BB%E5%9E%8B=%E6%B2%A1%E6%9C%89#%E5%93%88%E5%93%88")
  }

  private func testEqual(_ urlString1: String?, _ urlString2: String?) {
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
