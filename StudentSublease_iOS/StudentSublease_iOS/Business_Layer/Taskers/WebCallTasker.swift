//
//  WebCallTasker.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import Foundation

class WebCallTasker: NSObject {
    
    override init() {
        super.init()
    }
    
    //Post Requests
    func makePostRequest(forURL: String, withParams: [String: Any], failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
        let urlParams = generateURLParams(params: withParams)
        self.makeUrlRequest(urlString: forURL, httpMethod: "POST", httpBody: urlParams, failure: failure, success: success)
    }
    
    //Get Requests
    func makeGetRequest(forBaseURL: String, withParams: [String: Any], failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
        let urlParams = generateURLParams(params: withParams)
        let urlString = forBaseURL + "?" + urlParams
        self.makeUrlRequest(urlString: urlString, httpMethod: "GET", httpBody: nil, failure: failure, success: success)
    }
    
    private func generateURLParams(params: [String: Any]) -> String {
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        return urlParams
    }
    
    //Overall URL Request
    private func makeUrlRequest(urlString: String, httpMethod: String, httpBody: String?, failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
        guard let url = URL(string: urlString) else {
            failure()
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let body = httpBody {
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else {
                failure()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                failure()
                return
            }
            success(data, httpResponse)
        }
        task.resume()
    }
    
}
