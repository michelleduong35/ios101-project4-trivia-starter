//
//  TriviaService.swift
//  Trivia
//
//  Created by Michelle Duong on 3/14/24.
//

import Foundation

class TriviaService {
    static func fetchTrivia(completion: @escaping ([TriviaQuestion]) -> Void) {
        let categories = ["9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"] // Example categories
        let randomCategory = categories.randomElement() ?? "9"
        let difficulties = ["easy","medium","hard"]
        let randomDifficulty = difficulties.randomElement() ?? "easy"
        let url = URL(string: "https://opentdb.com/api.php?amount=10&category=\(randomCategory)&difficulty=\(randomDifficulty)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // this closure is fired when the response is received
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results)
                }
            } catch let error as DecodingError {
                print("Decoding error: \(error)")
                // Handle the decoding error, e.g., log it or show an alert to the user
            } catch {
                print("General error: \(error)")
                // Handle other types of errors
            }
            // at this point, `data` contains the data received from the response
        }
            task.resume()
        }
    private static func parse(data: Data) -> TriviaQuestion? {
        do {
            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let currentTrivia = jsonDictionary?["current_trivia"] as? [String: Any],
                  let category = currentTrivia["category"] as? String,
                  let question = currentTrivia["question"] as? String,
                  let type = currentTrivia["type"] as? String,
                  let difficulty = currentTrivia["difficulty"] as? String,
                  let correctAnswer = currentTrivia["correctAnswer"] as? String,
                  let incorrectAnswers = currentTrivia["incorrectAnswers"] as? [String] else {
                return nil
            }
            return TriviaQuestion(category: category,
                                  type: type,
                                  difficulty: difficulty,
                                  question: question,
                                  correctAnswer: correctAnswer,
                                  incorrectAnswers: incorrectAnswers)
        } catch {
            print("Error parsing data: \(error)")
            return nil
        }
    }
}
