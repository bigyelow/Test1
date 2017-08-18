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
    let string1 = "http://erobo.com?target=https%3A%2F%2Fclass.hujiang.com%2Fclasstopic%2Fdetail%2F92093%3Fch_campaign%3Dcls14412%26ch_source%3Doad_ydapplm_2_db2"
    let string2 = "bopen://m.taobao.com/tbopen/index.html?action=ali.open.nav&module=h5&source=alimama&appkey=24542003&backURL=&packageName=com.douban.frodo&visa=&h5Url=http%3A%2F%2Fmclick.simba.taobao.com%2Fcc_im%3Fp%3D%26s%3D1819449181%26k%3D448%26e%3DdoExlocZg3hyJXHLzvBMyUuD%252FAzu1ezeP6Z1GD1xzTWLcSY9UYaTzT%252BfYQeW3WSdbFfI9aV3Qp6SfdgmFC5J5T6X%252F23teVxydV2imyJHJKuNtTjX4IKMcqGyy1gHbizfEi9ao67Aij3GVw96n%252FWMNBv%252BTYoccR1gqzSrrioCcjAN6B6%252Bpan9BqGyy1gHbizfEi9ao67Aij3GVw96n%252FWMNIeylVWH6KtFdfSsxIhXIXc0cbpXyOmS%252BMLT9ptCuow2iLPs6G02%252FKmvzYkqZvcUl1cGgUTS8a8j%252Fmy%252B26kZa5WqQSfGa8yI5yduYxpvZtDaz1fllvvxWr8Dc58CFnQ9SFWMKFHJKlS9meoPOK%252BNP8xOKXLiro5oCg63KGXVY1Ih4sfI4EwAoT7Ppx8aAm%252FX8UVqcK21XjeXrvM%252BqJqwc05QlfmWCVqms6l11thomfLU%26clk1%3D0a672a11000059966134665200d7abb1"
    let string3 = "http://www.codeweblog.com/http-url-%E7%9A%84path%E7%A9%B6%E7%AB%9F%E5%8F%AF%E4%BB%A5%E5%8C%85%E5%90%AB%E5%93%AA%E4%BA%9B%E5%AD%97%E7%AC%A6/"
    let string4 = "http://www.codeweblog.com/http-url-的path究竟可以包含哪些字符/"
    let string5 = "http://erobo.com?target=https://class.hujiang.com/classtopic/detail/92093?ch_campaign=cls14412&ch_source=oad_ydapplm_2_db2"
    let string6 = "http://douban.com"
    let string7 = "http://douban.com/电影?s=mubie&redir=http://douban.com?dd=yy&t=d#标签"
    let string8 = "http://douban.com#dd"
    let string9 = "http://douban.com?ddd=yy&redir=movie#dd"
    let string10 = ""
    let string11 = "http:"
    let string12 = "http://"
    let string13 = "defe"

    let encoder1 = URLStringEncoder(originalString: string1, pathEncoded: false, queryEncoded: true)
    let encoder2 = URLStringEncoder(originalString: string2, pathEncoded: false, queryEncoded: true)
    let encoder3 = URLStringEncoder(originalString: string3, pathEncoded: true)
    let encoder4 = URLStringEncoder(originalString: string4, pathEncoded: false)
    let encoder5 = URLStringEncoder(originalString: string5, pathEncoded: false, queryEncoded: false)
    let encoder6 = URLStringEncoder(originalString: string6, pathEncoded: false)
    let encoder7 = URLStringEncoder(originalString: string7, pathEncoded: false, queryEncoded: false, fragmentEncoded: false)
    let encoder8 = URLStringEncoder(originalString: string8, pathEncoded: false)
    let encoder9 = URLStringEncoder(originalString: string9, pathEncoded: false, queryEncoded: false, fragmentEncoded: false)
    let encoder10 = URLStringEncoder(originalString: string10)
    let encoder11 = URLStringEncoder(originalString: string11)
    let encoder12 = URLStringEncoder(originalString: string12)
    let encoder13 = URLStringEncoder(originalString: string13)

    testEqual(encoder1?.url?.absoluteString, "http://erobo.com?target=https%3A%2F%2Fclass.hujiang.com%2Fclasstopic%2Fdetail%2F92093%3Fch_campaign%3Dcls14412%26ch_source%3Doad_ydapplm_2_db2")
    testEqual(encoder2?.url?.absoluteString, "bopen://m.taobao.com/tbopen/index.html?action=ali.open.nav&module=h5&source=alimama&appkey=24542003&backURL=&packageName=com.douban.frodo&visa=&h5Url=http%3A%2F%2Fmclick.simba.taobao.com%2Fcc_im%3Fp%3D%26s%3D1819449181%26k%3D448%26e%3DdoExlocZg3hyJXHLzvBMyUuD%252FAzu1ezeP6Z1GD1xzTWLcSY9UYaTzT%252BfYQeW3WSdbFfI9aV3Qp6SfdgmFC5J5T6X%252F23teVxydV2imyJHJKuNtTjX4IKMcqGyy1gHbizfEi9ao67Aij3GVw96n%252FWMNBv%252BTYoccR1gqzSrrioCcjAN6B6%252Bpan9BqGyy1gHbizfEi9ao67Aij3GVw96n%252FWMNIeylVWH6KtFdfSsxIhXIXc0cbpXyOmS%252BMLT9ptCuow2iLPs6G02%252FKmvzYkqZvcUl1cGgUTS8a8j%252Fmy%252B26kZa5WqQSfGa8yI5yduYxpvZtDaz1fllvvxWr8Dc58CFnQ9SFWMKFHJKlS9meoPOK%252BNP8xOKXLiro5oCg63KGXVY1Ih4sfI4EwAoT7Ppx8aAm%252FX8UVqcK21XjeXrvM%252BqJqwc05QlfmWCVqms6l11thomfLU%26clk1%3D0a672a11000059966134665200d7abb1")
    testEqual(encoder3?.url?.absoluteString, "http://www.codeweblog.com/http-url-%E7%9A%84path%E7%A9%B6%E7%AB%9F%E5%8F%AF%E4%BB%A5%E5%8C%85%E5%90%AB%E5%93%AA%E4%BA%9B%E5%AD%97%E7%AC%A6/")
    testEqual(encoder4?.url?.absoluteString, "http://www.codeweblog.com/http-url-%E7%9A%84path%E7%A9%B6%E7%AB%9F%E5%8F%AF%E4%BB%A5%E5%8C%85%E5%90%AB%E5%93%AA%E4%BA%9B%E5%AD%97%E7%AC%A6/")
    testEqual(encoder5?.url?.absoluteString, "http://erobo.com?target=https%3A//class.hujiang.com/classtopic/detail/92093?ch_campaign%3Dcls14412&ch_source=oad_ydapplm_2_db2")
    testEqual(encoder6?.url?.absoluteString, "http://douban.com")
    testEqual(encoder7?.url?.absoluteString, "http://douban.com/%E7%94%B5%E5%BD%B1?s=mubie&redir=http%3A//douban.com?dd%3Dyy&t=d#%E6%A0%87%E7%AD%BE")
    testEqual(encoder8?.url?.absoluteString, "http://douban.com#dd")
    testEqual(encoder9?.url?.absoluteString, "http://douban.com?ddd=yy&redir=movie#dd")
    testEqual(encoder10?.url?.absoluteString, "")
    testEqual(encoder11?.url?.absoluteString, "")
    testEqual(encoder12?.url?.absoluteString, "")
    testEqual(encoder13?.url?.absoluteString, "")
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
