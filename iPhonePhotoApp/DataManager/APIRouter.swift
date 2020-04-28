//
//  APIRouter.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: [String: Any] { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: Any] { get }
}

enum APIRouter: APIConfiguration {

    case getVideos

    internal var method: HTTPMethod {
        switch self {
        case .getVideos:
            return .get
        }
    }

    internal var path: String {
        switch self {
        case .getVideos:
            return "https://iphonephotographyschool.com/test-api/videos"
        }
    }

    internal var parameters: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }

    internal var body: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }

    internal var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: path)!
        var queryItems: [URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if !(queryItems.isEmpty) {
            urlComponents.queryItems = queryItems
        }
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary

        if !(body.isEmpty) {
            urlRequest = try URLEncoding().encode(urlRequest, with: body)

            let jsonData1 = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            urlRequest.httpBody = jsonData1
        }

        return urlRequest

    }
}
