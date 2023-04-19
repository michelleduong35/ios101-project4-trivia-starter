//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation
import UIKit

struct TriviaAPIResponse: Decodable {
    let response_code: Int
    let results: [TriviaQuestion]

    private enum CodingKeys: String, CodingKey {
        case response_code = "response_code"
        case results = "results"
    }
}

struct TriviaQuestion: Decodable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    private enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}
