//
//  StringExtension.swift
//  Frodo
//
//  Created by XueMing on 3/30/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

public extension NSString {
  /// 使用 String 初始化 URL 对象的时候需要 String 是 url-encoded 的，否则无法生成 URL 或者 URLComponents 对象。
  /// 使用下面的属性可以解析 String 并分别对 user, password, host, path, query, fragment 进行 url encoding.
  ///
  /// -Note: 如果不是合法的 url 则返回 nil
  var urlEncoded: String? {
    var user: String?
    var password: String?
    var host: String?
    var path: String?
    var query: String?
    var fragment: String?

    /// 1. Decode first
    guard let decodedStr = removingPercentEncoding else { return nil }

    /// 2. Begin to parse, sample: http://foobar:nicate@example.com:8080/some/path/file.html;params-here?foo=bar#baz
    let sep0: [String] = decodedStr.components(separatedBy: "://")  // [http, foobar:nicate@example.com:8080/some/path/file.html;params-here?foo=bar#baz]
    guard sep0.count > 1 && sep0[1] != "" && sep0[0] != "" else { return nil }
    var str0 = sep0[1]  // foobar:nicate@example.com:8080/some/path/file.html;params-here?foo=bar#baz
    for comp in sep0 {
      if comp != sep0[1] && comp != sep0[0] {
        str0.append("://" + comp) // query 里可能有重定向
      }
    }

    // Host, user, password
    var sep1: [String] = str0.components(separatedBy: "/") // [foobar:nicate@example.com:8080, some, path, file.html;params-here?foo=bar#baz]
    guard sep1.count > 0 else { return nil }
    sep1 = sep1[0].components(separatedBy: "?")
    let userHost = sep1[0]  // foobar:nicate@example.com:8080
    let sepUserHost = userHost.components(separatedBy: "@") // [foobar:nicate, example.com:8080]
    if sepUserHost.count >= 2 {
      let sepUserPassword = sepUserHost[0].components(separatedBy: ":")
      if sepUserPassword.count > 0 {
        user = sepUserPassword[0]
        if sepUserPassword.count > 1 {
          password = sepUserPassword[1]
        }
      }
      host = sepUserHost[1]
    } else if sepUserHost.count == 1 {
      host = sepUserHost[0]
    } else {
      assert(false)
      return nil
    }

    // Query, path
    if str0.characters.count > 0 {
      // Query
      let sep2: [String] = str0.components(separatedBy: "?")  // [foobar:nicate@example.com:8080/some/path/file.html;params-here, foo=bar#baz]
      if sep2.count > 1 {
        var queryFragment = sep2[1]
        for comp in sep2 {
          if comp != sep2[0] && comp != sep2[1] {
            queryFragment.append("?" + comp)  // query 中可能有重定向
          }
        }
        let sep3: [String] = queryFragment.components(separatedBy: "#")
        if sep3.count > 0 {
          query = sep3[0]
          if sep3.count > 1 {
            fragment = sep3[1]
          }
        }
      }

      // Path
      if sep2.count > 0 {
        let hostPath: String = sep2[0]
        let sep3: [String] = hostPath.components(separatedBy: "/") // [foobar:nicate@example.com:8080, some, path, file.html;params-here]
        if sep3.count > 1 {
          let sep4 = sep3[1..<sep3.count]
          path = sep4.joined(separator: "/")
        }
      }
    }

    user = user?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)
    password = password?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPasswordAllowed)
    host = host?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    path = path?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
    query = query?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    fragment = fragment?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)

    /// 3. Regenerate url string
    var urlString = sep0[0] + "://"

    var hasUser = false
    if let user = user, user.characters.count > 0 {
      hasUser = true
      urlString += user
    }
    if let password = password, password.characters.count > 0 {
      assert(hasUser == true)
      urlString += (":" + password)
    }
    if let host = host, host.characters.count > 0 {
      if hasUser {
        urlString += "@"
      }
      urlString += host
    }
    if let path = path, path.characters.count > 0 {
      urlString += ("/" + path)
    }
    if let query = query, query.characters.count > 0 {
      urlString += ("?" + query)
    }
    if let fragment = fragment, fragment.characters.count > 0 {
      urlString += ("#" + fragment)
    }

    return urlString
  }
}
