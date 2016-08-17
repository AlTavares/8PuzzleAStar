//
//  Tests.swift
//  Tests
//
//  Created by Alexandre Mantovani Tavares on 8/12/16.
//  Copyright © 2016 Alexandre Mantovani Tavares. All rights reserved.
//

import XCTest

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testManhattan() {

    }

    func testAStar() {
        measureBlock {
            let path = AStar.solve(BoardStub.worst, goal: BoardStub.goal)
        }
    }

    func testChildrenPuzzles() {
        // print(BoardStub.blankInCenter.childrenBoards)
        // XCTAssertEqual(BoardStub.blankInCenter.childrenBoards.count, 4)
    }

    func testPositions() {
        let pos = BoardStub.goal.positions
        XCTAssertEqual(pos[0]!, Position(column: 1, line: 1))
        XCTAssertEqual(pos[1]!, Position(column: 0, line: 0))
        XCTAssertEqual(pos[2]!, Position(column: 1, line: 0))
        XCTAssertEqual(pos[3]!, Position(column: 2, line: 0))
        XCTAssertEqual(pos[4]!, Position(column: 2, line: 1))
        XCTAssertEqual(pos[5]!, Position(column: 2, line: 2))
        XCTAssertEqual(pos[6]!, Position(column: 1, line: 2))
        XCTAssertEqual(pos[7]!, Position(column: 0, line: 2))
        XCTAssertEqual(pos[8]!, Position(column: 0, line: 1))

    }
}

struct BoardStub {

    static let goal = Board(state: [
        [1, 2, 3],
        [8, 0, 4],
        [7, 6, 5]
        ], parent: nil, goal: nil)

    static let medium = Board(state: [
        [2, 8, 1],
        [0, 4, 3],
        [7, 6, 5]
        ], parent: nil, goal: BoardStub.goal)

    static let hard = Board(state: [
        [2, 8, 0],
        [4, 6, 3],
        [1, 7, 5]
        ], parent: nil, goal: BoardStub.goal)

    static let worst = Board(state: [
        [5, 6, 7],
        [4, 0, 8],
        [3, 2, 1]
        ], parent: nil, goal: BoardStub.goal)

}