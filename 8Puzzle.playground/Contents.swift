//
//  Node.swift
//  8PuzleAStar
//
//  Created by Alexandre Mantovani Tavares on 8/11/16.
//  Copyright © 2016 Alexandre Mantovani Tavares. All rights reserved.
//

import Foundation

class AStar {
    class func solve<T: Node>(initialNode: T, goal: T) -> [T]? {
        var frontier = PriorityQueue.init(ascending: true, startingValues: [initialNode])
        var explored = Dictionary<T, Float>()
        explored[initialNode] = 0
        var nodesSearched: Int = 0

        while !frontier.isEmpty {
            nodesSearched += 1
            let currentNode = frontier.pop()! // we know if there are still items, we can pop one

            if currentNode.isGoal {
                print("Searched \(nodesSearched) nodes.")
                return currentNode.backtrack()
            }

            for child in currentNode.children {
                let newcost = currentNode.cost + 1 // 1 assumes a grid, there should be a cost function
                if explored[child] == nil || (explored[child] > newcost) {
                    explored[child] = newcost
                    frontier.push(child)
                }
            }
        }

        return nil
    }

}

struct Position: Equatable {
    let column: Int
    let line: Int
}

func == (lhs: Position, rhs: Position) -> Bool {
    return lhs.column == rhs.column && lhs.line == rhs.line
}

protocol Node: class, Comparable, Hashable { // , Comparable, Hashable {
    associatedtype State
    var state: State { get }
    var parent: Self? { get }
    var cost: Float { get }
    var heuristic: Float! { get }
    var children: [Self] { get }
    var isGoal: Bool { get }
    func backtrack() -> [Self]
}

typealias Pieces = [[Int]]

func == (lhs: Board, rhs: Board) -> Bool {
    return lhs === rhs
}

func < (lhs: Board, rhs: Board) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

final class Board: Node {
    let state: Pieces
    let parent: Board?
    let cost: Float
    var heuristic: Float!
    var positions = [Int: Position]()
    var blank: Position!
    let goal: Board?

    init(state: Pieces, parent: Board?, goal: Board?) {
        self.state = state
        self.parent = parent
        self.cost = parent != nil ? parent!.cost : 0
        self.goal = goal
        self.calculatePositions()
        self.heuristic = Float(manhattan())
    }

    var hashValue: Int { return (Int)(self.cost + self.heuristic) }

    // heuristic func for the AStar
    func manhattan() -> Int {
        var count = 0
        guard let goal = goal else { return count }
        for (node, position) in self.positions {
            let goalNode = goal.positions[node]!
            count += abs(position.column - goalNode.column)
            count += abs(position.line - goalNode.line)
        }

        return count
    }

    var isGoal: Bool {
        return self.positions == goal!.positions
    }

    var children: [Board] {
        return [moveUp(), moveRight(), moveDown(), moveLeft()].flatMap { $0 }
    }

    private func moveUp() -> Board? {
        if blank.column == 0 { return nil }
        let childNodes = swapNodes(position1: blank, position2: Position(column: blank.column, line: blank.line - 1))
        return Board(state: childNodes, parent: self, goal: goal)
    }
    private func moveRight() -> Board? {
        if blank.column == state[blank.column].count - 1 { return nil }
        let childNodes = swapNodes(position1: blank, position2: Position(column: blank.column + 1, line: blank.line))
        return Board(state: childNodes, parent: self, goal: goal)
    }
    private func moveDown() -> Board? {
        if blank.line == state.count - 1 { return nil }
        let childNodes = swapNodes(position1: blank, position2: Position(column: blank.column, line: blank.line + 1))
        return Board(state: childNodes, parent: self, goal: goal)
    }
    private func moveLeft() -> Board? {
        if blank.line == 0 { return nil }
        let childNodes = swapNodes(position1: blank, position2: Position(column: blank.column - 1, line: blank.line))
        return Board(state: childNodes, parent: self, goal: goal)
    }

    private func swapNodes(position1 position1: Position, position2: Position) -> Pieces {
        var childrenNodes = state
        swap(&childrenNodes[position1.line][position1.column], &childrenNodes[position2.line][position2.column])
        return childrenNodes
    }

    private func calculatePositions() -> Int {
        for (line, row) in state.enumerate() {
            for (column, node) in row.enumerate() {
                positions[node] = Position(column: column, line: line)
            }
        }
        self.blank = positions[0]!
        return positions.count
    }

    func backtrack() -> [Board] {
        var sol: [Board] = []
        var node = parent!
        sol.append(self)

        while (node.parent != nil) {
            sol.append(node)
            node = node.parent!
        }

        sol.append(node)

        return sol
    }
}

struct BoardStub {
    static let goal = Board(state: [
        [1, 2, 3],
        [8, 0, 4],
        [7, 6, 5]
        ], parent: nil, goal: nil)

    static let puzzle =
        Board(state: [
            [1, 3, 4],
            [8, 6, 2],
            [0, 7, 5]
            ], parent: nil, goal: BoardStub.goal)

}


//let result = AStar.solve(BoardStub.puzzle, goal: BoardStub.goal)

