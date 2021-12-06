//
//  WebCallTasker.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import Foundation
import UIKit
class WebCallTasker: NSObject {
    
    public typealias Headers = Dictionary<String, String>
    public typealias RequestData = Dictionary<String,Any>
    public typealias SuccessHandler = (Any?, Int) -> Void
    public typealias FailureHandler = (NSError?) -> Void
    
    var urlRequest: NSMutableURLRequest? = nil
    var priority:Operation.QueuePriority = Operation.QueuePriority.normal
    var timeoutInterval:TimeInterval = 30.0
    
    struct HeaderConstants {
        static var CONTENT_TYPE = "Content-Type"
    }
    
    struct MimeConstants {
        static var APPLICATION_JSON = "application/json"
    }
    
    /**
    *  Instance initialization
    */
  
    
    override init() {
        super.init()
    }
    
    //Post Requests
    func makePostRequest(forURL: String, withParams: [String: Any], failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
        let urlParams = generateURLParams(params: withParams)
        self.makeUrlRequest(urlString: forURL, httpMethod: "POST", httpBody: urlParams, failure: failure, success: success)
    }
    
    //Post Requests Images
    func makePostRequestImage(image: Array<UIImage> , forURL: String, withParams: [String: Any], failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
           let urlParams = generateURLParams(params: withParams)
        var myArr = [Data]()
        for i in image{
            myArr.append(i.jpegData(compressionQuality: 100)!)
        }
        
        self.makeUrlRequest2(image: myArr, param: withParams, urlString: forURL, httpMethod: "POST", httpBody: urlParams, failure: failure, success: success)
        
        
      
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
        print("URL PARAMS::::: " , urlParams)
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
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
       
    private func makeUrlRequest2(image: [Data] , param: [String:Any], urlString: String, httpMethod: String, httpBody: String?, failure: @escaping () -> Void, success: @escaping (_ data: Data, _ response: HTTPURLResponse) -> Void) {
        guard let url = URL(string: urlString) else {
            failure()
            return
        }
        let boundary = generateBoundaryString()

        var request = URLRequest(url: url)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //let fileURL = Bundle.main.url(forResource: "image1", withExtension: "png")!
        
        
        
        
        request.httpMethod = httpMethod
        
        if let body = httpBody {
            print("paramammama: " , param)
            request.httpBody = try! createBody(body1: body , parameters: param , filePathKey: "file", urls: image, boundary: boundary)
            //request.httpBody = body.data(using: String.Encoding.utf8)
            print("request.httpBody: " , request)
            
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
    private func createBody(body1:String , parameters: [String: Any]?, filePathKey: String, urls: [Data], boundary: String) throws -> Data {
        var body = Data()
        print("paramamama: ",  parameters)
        
        parameters?.forEach { (key, value) in
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
            print("keyy: " , key)
            print("valuee: " , key)
            
        }
        //body.append("--\(boundary)\r\n")
        //body.append(body1)
        
        /*for url in urls {
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }*/
        for i in urls{
                      body.append("--\(boundary)\r\n")
                      body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(Int64(NSDate().timeIntervalSince1970*1000)).jpg\"\r\n")
                      body.append("Content-Type: image/jpeg\r\n\r\n")
                      body.append(i)
                      body.append("\r\n")
                  }
        print("bodyyyyyy123456: " , body)
        
        
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    

   public func data1(image:[Data], fieldName:String, data:RequestData?) -> WebCallTasker {


              var postBody:NSMutableData = NSMutableData()
              var postData:String = String()
              var boundary:String = "------WebKitFormBoundary\(UUID().uuidString)"

              self.urlRequest?.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField:"Content-Type")
       
       
              if(data != nil && data!.count > 0) {
                   postData += "--\(boundary)\r\n"
               for i in data! {
                   if let value = i.value as? String {
                           postData += "--\(boundary)\r\n"
                       postData += "Content-Disposition: form-data; name=\"\(i.key)\"\r\n\r\n"
                           postData += "\(value)\r\n"
                       }
                   }
               }
          for i in image{
              postData += "--\(boundary)\r\n"
              postData += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(Int64(NSDate().timeIntervalSince1970*1000)).jpg\"\r\n"
              postData += "Content-Type: image/jpeg\r\n\r\n"
              postBody.append(postData.data(using: String.Encoding.utf8)!)
              postBody.append(i)
              postData = String()
              postData += "\r\n"
              postData += "\r\n--\(boundary)--\r\n"
              postBody.append(postData.data(using: String.Encoding.utf8)!)

          }


          self.urlRequest!.httpBody = Data(referencing: postBody)

          return self
      }

    
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
