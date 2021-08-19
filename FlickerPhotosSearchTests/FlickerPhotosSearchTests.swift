//
//  FlickerPhotosSearchTests.swift
//  FlickerPhotosSearchTests
//
//  Created by D MacBook Pro on 09/08/2021.
//

import XCTest
@testable import FlickerPhotosSearch

private let photoModel = PhotoModel(server: "959", id: "41886638322", secret: "9e692e7e1d", isSavedPhoto: true, savedPhotoPath: "")
private let resultsModel = PhotosResultsModel(photo: [photoModel])
private let searchResultsModel = SearchResultsModel(photos: resultsModel, stat: "ok")

class FlickerPhotosSearchTests: XCTestCase {
    
    fileprivate class MockPhotosServiceCall: APIManager {
        var searchData: SearchResultsModel?
        
        override func photosSearchService(parameters: [String : String], success: @escaping ((SearchResultsModel) -> Void), failed: @escaping ((String) -> Void)) {
            if let data = searchData {
                success(data)
            } else {
                failed("No Photos Data")
            }
        }
    }
    
    var photoData: PhotoModel?
    var viewModel: HomePhotosViewModel?
    weak var dataSource: HomePhotosDataSource<HomePhotosCell, [PhotoModel]>?
    
    fileprivate var service: MockPhotosServiceCall?
    
    override func setUp() {
        super.setUp()
        
        self.service = MockPhotosServiceCall()
        self.viewModel = HomePhotosViewModel(searchText: "")
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.dataSource = nil
        self.service = nil
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // TODO: Need to develop code for below cases
    // Test case #1: Provide wrong cell ID for collection view
    // Test case #2: Provide empty search string to flicker service
    // Test case #3: Provide wrong API key to flicker service
    // Test case #4: Provide empty data source for collection view
    

}
