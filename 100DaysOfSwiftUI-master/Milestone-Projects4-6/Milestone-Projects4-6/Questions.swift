//
//  Questions.swift
//  Milestone-Projects4-6
//
//  Created by Boe Bogdin on 1/18/2023
//

import Foundation

struct Questions {
    var questions = [Question]()

    init(table: Int, numberOfQuestions: Int) {
        questions = generateQuestions(table: table, numberOfQuestions: numberOfQuestions)
    }

    func generateQuestions(table: Int, numberOfQuestions: Int) -> [Question] {
        var tmpQuestions = [Question]()

        for i in 1...table {
            for j in 1...12 {
                if j >= i {
                    let result = String(i * j)
                    tmpQuestions.append(Question(text: "\(i) x \(j) =", result: result))
                    if i != j {
                        tmpQuestions.append(Question(text: "\(j) x \(i) =", result: result))
                    }
                }
            }
        }

        tmpQuestions.shuffle()
        return Array(tmpQuestions[0..<numberOfQuestions])
    }

}
