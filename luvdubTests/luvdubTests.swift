//
//  luvdubTests.swift
//  luvdubTests
//
//  Created by moon on 2023/09/09.
//

import XCTest

final class luvdubTests: XCTestCase {
    
    let FIREBASEUID = "NXkfsqsdkcZHpBoLzeG9qi9ktmJ2"
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func createRequest()-> URLRequest {
        let url = URL(string: "https://asia-northeast3-loveduk-539e3.cloudfunctions.net/fcm")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = [
            "deviceToken": FIREBASEUID
        ]
        let jsonBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonBody
        
        return request
    }
    
    func test_http_post() throws {
        // given
        var req = createRequest()
        let expectation = XCTestExpectation(description: "HTTP request")
        // when
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error{
                XCTFail("error가 발생함")
                return
            }
            
            guard let data = data else {
                XCTFail("Data가 없음")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                XCTFail("response.statusCode is not 200")
            }
            do {
                let decodedData = try JSONDecoder().decode(HttpResult.self, from: data)
                print(decodedData.status_code)
            } catch {
                print("decoding has problem")
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                XCTAssertEqual(httpStatus.statusCode, 200, "http statuscode should be 200")
            }
            
        }
        task.resume()
        
//        wait(for: [expectation], timeout: 10.0)
        sleep(10)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

struct HttpResult: Codable {
    let status_code: Int
    let body: String
}
