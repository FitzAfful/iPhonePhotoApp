//
//  APIManagerTests.swift
//  iPhonePhotoAppTests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest
@testable import iPhonePhotoApp
@testable import Alamofire
@testable import Mocker

class APIManagerTests: XCTestCase {

    private var sut: APIManager!

    override func setUpWithError() throws {
        let sessionManager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
                return configuration
            }()
            return Session(configuration: configuration)
        }()
        sut = APIManager(manager: sessionManager)
    }

    func testFetchVideos() {

        let apiEndpoint = URL(string: APIRouter.getVideos.path)!
        let requestExpectation = expectation(description: "Request should finish with Employees")
        let responseFile = "videoResponse"
        guard let mockedData = dataFromTestBundleFile(fileName: responseFile, withExtension: "json") else {
            XCTFail("Error from JSON DeSerialization.jsonObject")
            return
        }
        guard let mockResponse = try? JSONDecoder().decode(VideoResponse.self, from: mockedData) else {
            XCTFail("Error from JSON DeSerialization.jsonObject")
            return
        }

        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        sut.fetchVideos { (result) in
            XCTAssertEqual(result.success!, mockResponse)
            XCTAssertNil(result.failure)
            requestExpectation.fulfill()
        }

        wait(for: [requestExpectation], timeout: 10.0)
    }

    func dataFromTestBundleFile(fileName: String, withExtension fileExtension: String) -> Data? {

        let testBundle = Bundle(for: APIManagerTests.self)
        let resourceUrl = testBundle.url(forResource: fileName, withExtension: fileExtension)!
        do {
            let data = try Data(contentsOf: resourceUrl)
            return data
        } catch {
            XCTFail("Error reading data from resource file \(fileName).\(fileExtension)")
            return nil
        }
    }

}
