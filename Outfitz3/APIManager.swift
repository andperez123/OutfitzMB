import Foundation

class APIManager {
    static let shared = APIManager()
    
    private var apiKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OPENAI_API_KEY not set in environment variables")
        }
        return apiKey               
    }
    
    func fetchChatResponse(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
            let urlString = "https://api.openai.com/v1/chat/completions"
            guard let url = URL(string: urlString) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let parameters: [String: Any] = [
                "model": "gpt-3.5-turbo",
                "messages": [["role": "user", "content": prompt]],
                "max_tokens": 100
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                self.handleApiResponse(data: data, response: response, error: error, completion: completion)
            }
            task.resume()
        }
        
        private func handleApiResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from API"])
                completion(.failure(error))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(jsonResponse)")
                
                if let json = jsonResponse as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else if let json = jsonResponse as? [String: Any],
                          let error = json["error"] as? [String: Any],
                          let message = error["message"] as? String {
                    let apiError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    completion(.failure(apiError))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from API"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
