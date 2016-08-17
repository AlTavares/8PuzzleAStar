//
//  Node.swift
//  8PuzleAStar
//
//  Created by Alexandre Mantovani Tavares on 8/11/16.
//  Copyright © 2016 Alexandre Mantovani Tavares. All rights reserved.
//

import Foundation

class AStar {
    class func solve<T: Node>(initialNode: T) {
        var frontier = PriorityQueue.init(ascending: true, startingValues: [initialNode])
        var explored = Dictionary<T, Float>()
        explored[initialNode] = 0
        var nodesSearched: Int = 0

        while !frontier.isEmpty {
            nodesSearched += 1
            print(nodesSearched)
            let currentNode = frontier.pop()! // we know if there are still items, we can pop one

            if currentNode.isGoal {
                currentNode.backtrack()
                print("Searched \(nodesSearched) nodes.")
                return
            }

            for child in currentNode.children {
                if explored[child] == nil || (explored[child] > child.cost) {
                    explored[child] = child.cost
                    frontier.push(child)
                }
            }
        }
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
    func backtrack()
}

typealias Pieces = [[Int]]

func == (lhs: Board, rhs: Board) -> Bool {
    return lhs.heuristic != rhs.heuristic ? false : lhs.positions == rhs.positions
}

func < (lhs: Board, rhs: Board) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

final class Board: Node, CustomStringConvertible {
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
        self.cost = parent != nil ? parent!.cost + 1: 0
        self.goal = goal
        self.calculatePositions()
        self.heuristic = Float(manhattan())
    }

    var hashValue: Int { return (Int)(self.cost + self.heuristic) }

    var description: String {
        var string = "\n" + state.map { $0.description }.joinWithSeparator("\n")
        string += "\nheuristic: \(heuristic)"
        string += "\ncost: \(cost)"
        return string
    }

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
        return self == goal
    }

    var children: [Board] {
        return [moveUp(), moveRight(), moveDown(), moveLeft()].flatMap { $0 }
    }

    private func moveUp() -> Board? {
        if blank.line == 0 { return nil }
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
        if blank.column == 0 { return nil }
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

    func backtrack() {
        print(self)
        var node = parent!

        while (node.parent != nil) {
            print(node)
            node = node.parent!
        }

    }

}

