//
//  main.swift
//  8PuzleAStar
//
//  Created by Alexandre Mantovani Tavares on 8/9/16.
//  Copyright © 2016 Alexandre Mantovani Tavares. All rights reserved.
//

import Foundation

//Goal:    Easy:      Medium:  Hard:     Worst:

//1 2 3    1 3 4       2 8 1       2 8 1       5 6 7
//8   4    8 6 2         4 3       4 6 3       4   8
//7 6 5      7 5       7 6 5         7 5       3 2 1

let goal = Board(state: [
    [1, 2, 3],
    [8, 0, 4],
    [7, 6, 5]
    ], parent: nil, goal: nil)

let medium = Board(state: [
    [2, 8, 1],
    [0, 4, 3],
    [7, 6, 5]
    ], parent: nil, goal: goal)

let hard = Board(state: [
    [0, 5, 7],
    [4, 6, 8],
    [3, 2, 1]
    ], parent: nil, goal: goal)

let worst = Board(state: [
    [5, 6, 7],
    [4, 0, 8],
    [3, 2, 1]
    ], parent: nil, goal: goal)

AStar.solve(hard, goal: goal)
