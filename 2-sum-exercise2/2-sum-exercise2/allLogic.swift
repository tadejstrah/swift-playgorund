//
//  allLogic.swift
//  2-sum-exercise2
//
//  Created by Tadej Strah on 18/05/2018.
//  Copyright © 2018 Tadej Strah. All rights reserved.
//

import Foundation
//: Playground - noun: a place where people can play

var array = [Int]()

func sortArray(with inputArray:[Int]) -> [Int]{
    if inputArray.count <= 1{
        return inputArray
    }
    
    let pivot = inputArray[0]
    //print(pivot)
    //print(inputArray)
    var biggerValues:[Int] = []
    var smallerValues:[Int] = []
    
    for x in inputArray[1...]{
        //print(x)
        if (x <= pivot){
            //print("manjši")
            smallerValues.append(x)
        }
        else {
            //print("vwčji")
            biggerValues.append(x)
        }
    }
    return (sortArray(with: smallerValues) + [pivot] + sortArray(with: biggerValues))
}

func bruteForce(_ array1: Array<Int>,_ wantedSum: Int) -> Array<String>{
    var solutions = [String]()
    for x in array1.indices{
        for y in array1[x...]{
            if (array1[x] + y == wantedSum){
                solutions.append(String(array1[x])+"+"+String(y))
            }
        }
    }
    return solutions
}


func twoPointers(_ inputArray:[Int], wantedSum: Int) -> [(Int,Int)]{
    var solutions: [(Int,Int)] = []
    var left:Int = 0
    var right:Int = inputArray.count-1
    var sortedArray = sortArray(with: inputArray)
    while (left < right){
        if (sortedArray[left] + sortedArray[right] == wantedSum){
            solutions.append((sortedArray[left],sortedArray[right]))
            right -= 1
        }
        else if (sortedArray[left] + sortedArray[right] > wantedSum){
            right -= 1
        }
        else {
            left += 1
        }
    }
    return solutions
}

