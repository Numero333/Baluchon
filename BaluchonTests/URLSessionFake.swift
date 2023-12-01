//
//  URLSessionFake.swift
//  BaluchonTests
//
//  Created by François-Xavier on 23/11/2023.
//

import Foundation

class FakeURLSessionProtocol: URLProtocol {
    
    static var loadingData: (() -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let handler = FakeURLSessionProtocol.loadingData!
        let (response, data) = handler()
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}
