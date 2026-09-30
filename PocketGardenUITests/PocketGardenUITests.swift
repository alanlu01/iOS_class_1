import XCTest

final class PocketGardenUITests: XCTestCase {
    func testCareLibraryNotesAndPersistence() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetGardenState"]
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["植物圖鑑"].waitForExistence(timeout: 5))
        capture(app, name: "01-我的花園")

        app.swipeUp()
        let waterButton = app.buttons["waterButton"]
        XCTAssertTrue(waterButton.waitForExistence(timeout: 8))
        waterButton.tap()
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["繼續照顧"].tap()

        let noteButton = app.buttons["addNoteButton"]
        if !noteButton.isHittable { app.swipeUp() }
        XCTAssertTrue(noteButton.waitForExistence(timeout: 5))
        noteButton.tap()
        let editor = app.textViews["noteTextEditor"]
        XCTAssertTrue(editor.waitForExistence(timeout: 5))
        editor.tap()
        editor.typeText("今天看到一片新葉，真開心！")
        app.buttons["saveNoteButton"].tap()

        app.tabBars.buttons["植物圖鑑"].tap()
        XCTAssertTrue(app.staticTexts["龜背芋"].waitForExistence(timeout: 5))
        capture(app, name: "02-植物圖鑑")

        app.swipeUp()
        let pothosCard = app.buttons["plantCard_pothos"]
        XCTAssertTrue(pothosCard.waitForExistence(timeout: 5))
        pothosCard.tap()
        XCTAssertTrue(app.staticTexts["黃金葛"].waitForExistence(timeout: 5))
        capture(app, name: "03-植物介紹")
        app.swipeUp()
        app.buttons["selectPlantButton"].tap()

        app.tabBars.buttons["照顧日誌"].tap()
        XCTAssertTrue(app.staticTexts["龜背芋 · 澆水"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["今天看到一片新葉，真開心！"].exists)
        capture(app, name: "04-照顧日誌")

        app.terminate()
        app.launchArguments = []
        app.launch()
        XCTAssertTrue(app.staticTexts["黃金葛"].waitForExistence(timeout: 5))
        app.tabBars.buttons["照顧日誌"].tap()
        XCTAssertTrue(app.staticTexts["龜背芋 · 澆水"].waitForExistence(timeout: 5))
    }

    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
