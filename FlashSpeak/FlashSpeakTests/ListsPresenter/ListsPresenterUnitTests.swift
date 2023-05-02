//
//  ListsPresenter_UnitTests.swift
//  FlashSpeakTests
//
//  Created by Denis Dmitriev on 29.04.2023.
//
// swiftlint:disable all

import XCTest
@testable import FlashSpeak

final class ListsPresenterUnitTests: XCTestCase {
    
    var presenter: ListsPresenter!
    var mockViewController: MockLictsViewController!
    var router: ListsEvent!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        router = ListsRouter()
        presenter = ListsPresenter(
            fetchedListsResultController: CoreDataManager.instance.initListFetchedResultsController(),
            router: router
        )
        mockViewController = MockLictsViewController(presenter: presenter)
        presenter.viewController = mockViewController
    }
    
    override func tearDown() {
        presenter = nil
        mockViewController = nil
        router = nil
        super.tearDown()
    }
    
    func testView() {
        let expectation = self.expectation(description: "get lists")
        
        // Given
        // mock Study with list
        var mockStudy = Study(sourceLanguage: .russian, targerLanguage: .english)
        mockStudy.lists = [List(title: "Test", words: [], style: .grey, created: Date.now, addImageFlag: false, learns: [])]
        presenter.study = mockStudy
        
        // When
        // subscribe between presenter and view
        presenter.subscribe {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        // Then
        // count lists in presenter and view
        XCTAssertEqual(presenter.study.lists.count, mockViewController.listCellModels.count)
    }
    
    func testRouter() {
        let expectation = self.expectation(description: "router event")
        
        // Given
        var value: Bool? = nil
        presenter.router?.didSendEventClosure = { event in
            switch event {
            default:
                value = false
            }
        }
        router.didSendEventClosure = { event in
            switch event {
            default:
                value = true
                expectation.fulfill()
            }
        }
        
        // When
        presenter.newList()
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertTrue(value ?? false)
    }
    
    func testDidSelect() {
        let expectation = self.expectation(description: "select list")
        
        // Given
        let title = "Test"
        var mockStudy = Study(sourceLanguage: .russian, targerLanguage: .english)
        mockStudy.lists = [List(title: title, words: [], style: .grey, created: Date.now, addImageFlag: false, learns: [])]
        presenter.study = mockStudy
        var getMockList: List?
        router.didSendEventClosure = { event in
            switch event {
            case .lookList(let list):
                getMockList = list
                expectation.fulfill()
            default:
                return
            }
        }
        
        // When
        let indexPath = IndexPath(item: .zero, section: .zero)
        mockViewController.didSelectList(indexPath: indexPath)
        
        waitForExpectations(timeout: 1)
        
        // Then
        XCTAssertEqual(getMockList?.title, title)
    }

}

// swiftlint:enable all
