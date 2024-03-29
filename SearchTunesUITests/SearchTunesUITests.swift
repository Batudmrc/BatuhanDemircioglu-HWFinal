//
//  SearchTunesUITests.swift
//  SearchTunesUITests
//
//  Created by Batuhan Demircioğlu on 5.06.2023.
//

import XCTest

final class SearchTunesUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        //app.launchArguments.append("----UI TEST----")
        app.launchArguments = ["ResetDefaults", "NoAnimations", "UserHasRegistered"]
        app.launch()
    }
    // Test to check the cells count
    func test_SearchTextField()   {
        app.launch()
        
        XCTAssertTrue(app.searchTextField.isHittable)
        XCTAssertTrue(app.isTableViewDisplayed)
        app.searchTextField.tap()
        // Making a search that returns 50 cells
        app.searchTextField.typeText("Ezhel")
        // Sleep 1 Seconds for debounce time
        sleep(1)
        // Checking if we get 50 cells
        XCTAssertEqual(app.cellCount, 50)
    }
    //  UIView.animate kullandığım için 140-210 saniye sürüyor hocam 
    func test_PlayAudio() {
        app.launch()
        
        // Tap the textfield and type "Tarkan"
        app.searchTextField.tap()
        app.searchTextField.typeText("Tarkan")
        sleep(1)
        // Get an example cell. This code I get second cell.
        let cell = app.tableView.cells.element(boundBy: 1)
        cell.tap()
        // Now test is in the DetailPage, wait 2seconds for navigation. Also wait for audio to load ( It takes approximately 70 seconds )
        sleep(2)
//   ( Hocam müziğin yüklenmesi bazen 70 saniye bazen 140 sürüyor ama sonra çalıyor çaldıktan sonra bi 70 saniye daha testin sonuçlanması için bekleniyor hocam :) )
        app.playButton.tap()
        // waitForExistance
        //sleep(1)
        
        XCTAssertNotEqual(app.remainingTimeLabel.label, "00:00")
    }
    // UIView.animate kullandığım için bu da 70-80 saniye sürüyor hocam
    func test_FavButtonTapped() {
        app.launch()
        // Tap the textfield and type "Tarkan"
        app.searchTextField.tap()
        app.searchTextField.typeText("Tarkan")
        sleep(1)
        // Get an example cell. This code second cell.
        let cell = app.tableView.cells.element(boundBy: 1)
        cell.tap()
        // Now test is in the DetailPage, wait 2seconds for navigation. Also wait for audio to load ( It takes approximately 70 seconds )
        app.favButton.tap()
    }
}

extension XCUIApplication {
    
    var searchTextField: XCUIElement {
        searchFields["searchTextField"]
    }
    
    var isTextFieldDisplayed: Bool {
        searchTextField.exists
    }
    
    var tableView: XCUIElement {
        tables["tableView"]
    }
    
    var isTableViewDisplayed: Bool {
        tableView.exists
    }
    
    var cellCount: Int {
        tableView.cells.count
    }

    var playButton: XCUIElement {
        images["playButton"]
    }
    
    var favButton: XCUIElement {
        images["favoriteButton"]
    }
    
    var remainingTimeLabel: XCUIElement {
        staticTexts["remainingTimeLabel"]
    }
    
    var elapsedTimeLabel: XCUIElement {
        staticTexts["remainingTimeLabel"]
    }
    
}
