//
//  Node.swift
//  8PuzleAStar
//
//  Created by Alexandre Mantovani Tavares on 8/11/16.
//  Copyright © 2016 Alexandre Mantovani Tavares. All rights reserved.
//

import Foundation

struct Position: Equatable {
    let column: Int
    let line: Int
}

func == (lhs: Position, rhs: Position) -> Bool {
    return lhs.column == rhs.column && lhs.line == rhs.line
}

typealias Nodes = [[Int]]

class Board: CustomStringConvertible {
    var parent: Board?
    var step = 0
    var nodes: Nodes
    var positions = [Int: Position]()
    var blank: Position!
    var cost = 0
    var goal: Board?
    let isGoal: Bool

    var childrenBoards: [Board] {
        return [moveUp()!, moveRight(), moveDown(), moveLeft()].flatMap { $0 }
    }

    init(parent: Board? = nil, nodes: Nodes, goal: Board? = nil, isGoal: Bool = false) {
        precondition(nodes.count == nodes[0].count, "Invalid nodes")
        self.nodes = nodes
        if let p = parent {
            self.step = p.step + 1
            self.parent = p
        }
        if let goal = goal {
            self.goal = goal
        } else if !isGoal {
            self.goal = parent!.goal
        }
        self.isGoal = isGoal

        precondition(calculatePositions() == nodes.reduce(0) { $0 + $1.count }, "There are repeated values in the board")

    }

    private func moveUp() -> Board? {
        if blank.column == 0 { return nil }
        let childNodes = swapNodes(blank, position2: Position(column: blank.column, line: blank.line - 1))
        return Board(parent: self, nodes: childNodes)
    }
    private func moveRight() -> Board? {
        if blank.column == nodes[blank.column].count - 1 { return nil }
        let childNodes = swapNodes(blank, position2: Position(column: blank.column + 1, line: blank.line))
        return Board(parent: self, nodes: childNodes)
    }
    private func moveDown() -> Board? {
        if blank.line == nodes.count - 1 { return nil }
        let childNodes = swapNodes(blank, position2: Position(column: blank.column, line: blank.line + 1))
        return Board(parent: self, nodes: childNodes)
    }
    private func moveLeft() -> Board? {
        if blank.line == 0 { return nil }
        let childNodes = swapNodes(blank, position2: Position(column: blank.column - 1, line: blank.line))
        return Board(parent: self, nodes: childNodes)
    }

    private func swapNodes(position1: Position, position2: Position) -> Nodes {
        var childrenNodes = nodes
        swap(&childrenNodes[position1.line][position1.column], &childrenNodes[position2.line][position2.column])
        return childrenNodes
    }

    private func calculatePositions() -> Int {
        for (line, row) in nodes.enumerate() {
            for (column, node) in row.enumerate() {
                positions[node] = Position(column: column, line: line)
            }
        }
        self.blank = positions[0]!
        return positions.count
    }

    private func manhattan() -> Int {
        var count = 0
        if isGoal { return count }
        for (node, position) in positions {
            let goalNode = goal!.positions[node]!
            count += abs(position.column - goalNode.column)
            count += abs(position.line - goalNode.line)
        }

        return count
    }

    private func calculateCost() -> Int {
        self.cost = step + manhattan()
        return self.cost
    }

    var description: String {
        var string = "\n" + nodes.map { $0.description }.joinWithSeparator("\n")
        string += "\nstep: \(step)"
        string += "\ncost: \(cost)"
        return string
    }

}
