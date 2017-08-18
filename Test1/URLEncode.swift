//
//  URLEncode.swift
//  Test1
//
//  Created by bigyelow on 18/08/2017.
//  Copyright © 2017 huangduyu. All rights reserved.
//

import Foundation

/// 目前只考虑 path 和 query 是否 encode 的情况，`originalString` 的 baseURL 的合法性依赖外部调用者。
public class URLStringEncoder: NSObject {
  let pathEncoded: Bool
  let queryEncoded: Bool
  let originalString: String

  fileprivate(set) var baseURLString: String?
  fileprivate(set) var pathString: String?
  fileprivate(set) var queryString: String?
  fileprivate(set) var url: URL?

  /// 如果 `originalString` 的 baseURLString 是不合法的，将无法得到正确的解析。
  init?(originalString: String?, pathEncoded: Bool = true, queryEncoded: Bool = true) {
    guard let originalString = originalString else { return nil }
    self.pathEncoded = pathEncoded
    self.queryEncoded = queryEncoded
    self.originalString = originalString
    url = nil
    super.init()

    parse()
  }
}

public extension URLStringEncoder {
  fileprivate func parse() {
    var mainURLString: String?
    (mainURLString, queryString) = parseStringToMainURLAndQuery(string: originalString)
    (baseURLString, pathString) = parseMainURLToBaseURLAndPath(mainURL: mainURLString)

    guard let baseURLString = baseURLString,
    var comps = URLComponents(string: baseURLString),
    comps.url != nil else {
      assert(false, "BaseURL 不正确，请确认后端返回或者本地输入没有问题!")
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
        comps.percentEncodedQuery = URLStringEncoder.string(from: queryDict)
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

  private func parseStringToMainURLAndQuery(string: String?) -> (String?, String?) {
    guard let string = string else { return (nil, nil)}

    var mainURLString: String?
    var queryString: String?
    if let range = string.range(of: "?") {
      mainURLString = string.substring(to: range.lowerBound)
      queryString = string.substring(from: string.index(after: range.lowerBound))
    } else {
      mainURLString = string
    }

    return (mainURLString, queryString)
  }


  /// - Parameter query: should not be percent encoded
  private func parseQueryStringToDictionary(queryString query: String?) -> [String: String]? {
    guard let query = query else { return nil }

    let comps = query.components(separatedBy: "&")
    guard comps.count > 0 else { return nil }

    var dict = [String: String]()
    for comp in comps {
      let keyValue = comp.components(separatedBy: "=")
      guard keyValue.count >= 2 else { continue }

      let key = keyValue[0]
      let value = keyValue[1]
      dict[key] = value
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
