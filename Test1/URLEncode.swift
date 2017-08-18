//
//  URLEncode.swift
//  Test1
//
//  Created by bigyelow on 18/08/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Foundation

/// 只有在明确知道 url 哪些部分没有 encode 的情况下才适合使用这个类。
/// 大部分情况我们拿到的 url string 应该都是后端返回并且 encode 过的，这时候应该使用 URL(string:), URLComponent(string:) 来得到 URL 实例，
/// 如果从后端返回的 url string 没有 encode，应该首先让后端 encode。
/// 目前只考虑 path, query, fragment 是否 encode 的情况，`originalString` 的 baseURL 的合法性依赖外部调用者。
public class URLStringEncoder: NSObject {
  let pathEncoded: Bool
  let queryEncoded: Bool
  let fragmentEncoded: Bool

  let originalString: String

  fileprivate(set) var baseURLString: String?
  fileprivate(set) var pathString: String?
  fileprivate(set) var queryString: String?
  fileprivate(set) var fragmentString: String?
  fileprivate(set) var url: URL?

  /// 如果 `originalString` 的 baseURLString 是不合法的，将无法得到正确的解析。
  ///
  /// - Note: For `URLCompnonents`: attempting to set an incorrectly percent encoded string will cause a fatalError, so the
  /// default value of `pathEncoded` and `queryEncoded` is false.
  init?(originalString: String?, pathEncoded: Bool = false, queryEncoded: Bool = false, fragmentEncoded: Bool = false) {
    guard let originalString = originalString else { return nil }
    self.pathEncoded = pathEncoded
    self.queryEncoded = queryEncoded
    self.originalString = originalString
    self.fragmentEncoded = fragmentEncoded
    url = nil
    super.init()

    parse()
  }
}

fileprivate extension URLStringEncoder {
  func parse() {
    var mainURLString: String?
    (mainURLString, queryString, fragmentString) = parseStringToMainURLQueryAndFragment(string: originalString)
    (baseURLString, pathString) = parseMainURLToBaseURLAndPath(mainURL: mainURLString)

    guard let baseURLString = baseURLString,
    var comps = URLComponents(string: baseURLString),
    comps.url != nil else {
      return
    }

    if let path = pathString {
      if pathEncoded {
        comps.percentEncodedPath = path
      } else {
        comps.path = path
      }
    }

    if let query = queryString {
      if queryEncoded {
        comps.percentEncodedQuery = query
      } else if let queryDict = parseQueryStringToDictionary(queryString: query){
        // 对于一个没有 encode 过的 query，客户端 encode query 的算法和后端不一定完全一样, 这里采用 APIKit 中的算法。
        comps.percentEncodedQuery = URLStringEncoder.string(from: queryDict)
      }
    }

    if let fragment = fragmentString {
      if fragmentEncoded {
        comps.percentEncodedFragment = fragment
      } else {
        comps.fragment = fragment
      }
    }

    url = comps.url
  }

  /// - Parameter mainURL: url without query, sample: http://foobar:nicate@example.com:8080/some/path/file.html;params-here
  private func parseMainURLToBaseURLAndPath(mainURL: String?) -> (String?, String?) {
    guard let mainURL = mainURL else { return (nil, nil) }

    let comps = mainURL.components(separatedBy: "://")
    guard comps.count == 2 && comps[0].characters.count > 0 && comps[1].characters.count > 0 else { return (nil, nil) }

    // comps[0]: http
    // comps[1]: foobar:nicate@example.com:8080/some/path/file.html;params-here
    if let range = comps[1].range(of: "/") {
      baseURLString = comps[0] + "://" + comps[1].substring(to: range.lowerBound)
      pathString = comps[1].substring(from: range.lowerBound) // include first "/"
    } else {
      baseURLString = comps[0] + "://" + comps[1]
    }

    return (baseURLString, pathString)
  }

  private func parseStringToMainURLQueryAndFragment(string: String?) -> (String?, String?, String?) {
    guard var string = string else { return (nil, nil, nil)}

    var mainURLString: String?
    var queryString: String?
    var fragmentString: String?

    if let anchorRange = string.range(of: "#") {
      fragmentString = string.substring(from: string.index(after: anchorRange.lowerBound))
      string = string.substring(to: anchorRange.lowerBound)
    }

    if let range = string.range(of: "?") {
      mainURLString = string.substring(to: range.lowerBound)
      queryString = string.substring(from: string.index(after: range.lowerBound))
    } else {
      mainURLString = string
    }

    return (mainURLString, queryString, fragmentString)
  }

  /// - Parameter query: should not be percent encoded
  /// sample: target=https://class.hujiang.com/classtopic/detail/92093?ch_campaign=cls14412&ch_source=oad_ydapplm_2_db2
  private func parseQueryStringToDictionary(queryString query: String?) -> [String: String]? {
    guard let query = query else { return nil }

    let comps = query.components(separatedBy: "&")
    guard comps.count > 0 else { return nil }

    var dict = [String: String]()
    for comp in comps {
      let keyValue = comp.components(separatedBy: "=")
      if keyValue.count >= 3 {
        // Note: 对于 target=https://class.hujiang.com/classtopic/detail/92093?ch_campaign=cls14412&ch_source=oad_ydapplm_2_db2 的形式，
        // key 为 target, 对应的 value(redirect url) 为 https://class.hujiang.com/classtopic/detail/92093?ch_campaign=cls14412 ，
        // 而 ch_source=oad_ydapplm_2_db2  无法判别是 redirect url 的 query 还是原始 url 的 query，目前认为是原始 url 的 query。
        // 这导致的结果是 redirect url 中的第一个 "=" 会被 query encoding，其他的 "=" 会被保留
        // （ "=" 保留逻辑: https://github.com/ishkawa/APIKit/blob/master/Sources/APIKit/Serializations/URLEncodedSerialization.swift#L98）
        let key = keyValue[0]
        if let range = comp.range(of: key + "=") {
          let value = comp.substring(from: range.upperBound)
          dict[key] = value
        }
      } else if keyValue.count == 2 {
        let key = keyValue[0]
        let value = keyValue[1]
        dict[key] = value
      } else {
        continue
      }
    }

    return dict
  }

  /// Copy from APIKit: https://github.com/ishkawa/APIKit/blob/master/Sources/APIKit/Serializations/URLEncodedSerialization.swift#L91
  private static func string(from dictionary: [String: Any]) -> String {
    let pairs = dictionary.map { key, value -> String in
      if value is NSNull {
        return "\(escape(key))"
      }

      let valueAsString = (value as? String) ?? "\(value)"
      return "\(escape(key))=\(escape(valueAsString))"
    }

    return pairs.joined(separator: "&")
  }

  /// Copy from APIKit: https://github.com/ishkawa/APIKit/blob/master/Sources/APIKit/Serializations/URLEncodedSerialization.swift#L3
  private static func escape(_ string: String) -> String {
    // Reserved characters defined by RFC 3986
    // Reference: https://www.ietf.org/rfc/rfc3986.txt
    let generalDelimiters = ":#[]@"
    let subDelimiters = "!$&'()*+,;="
    let reservedCharacters = generalDelimiters + subDelimiters

    var allowedCharacterSet = CharacterSet()
    allowedCharacterSet.formUnion(.urlQueryAllowed)
    allowedCharacterSet.remove(charactersIn: reservedCharacters)

    // Crashes due to internal bug in iOS 7 ~ iOS 8.2.
    // References:
    //   - https://github.com/Alamofire/Alamofire/issues/206
    //   - https://github.com/AFNetworking/AFNetworking/issues/3028
    // return string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string

    let batchSize = 50
    var index = string.startIndex

    var escaped = ""

    while index != string.endIndex {
      let startIndex = index
      let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
      let range = startIndex..<endIndex

      let substring = string.substring(with: range)

      escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring

      index = endIndex
    }
    
    return escaped
  }
}
