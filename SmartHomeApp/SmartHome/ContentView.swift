import SwiftUI

struct ContentView: View {
    @State private var bulbState = 0
    
    func sendRequest(state: Int) {
        let url = URL(string: "http://192.168.178.60:8080/state")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpBody = "\(state)".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let response = String(data: data, encoding: .utf8) {
                print("Response: \(response)")
            }
        }
        task.resume()
    }
    
    func fetchState() {
        let url = URL(string: "http://192.168.178.60:8080/")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let response = String(data: data, encoding: .utf8) {
                if let state = Int(response) {
                    self.bulbState = state
                    print("Bulb State: \(state)")
                }
            }
        }
        task.resume()
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.bulbState = self.bulbState == 1 ? 0 : 1
                self.sendRequest(state: self.bulbState)
            }) {
                Image(systemName: bulbState == 1 ? "lightbulb.fill" : "lightbulb")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(bulbState == 1 ? .yellow : .black)
            }
            Text("Bulb State: \(bulbState)")
        }
        .onAppear {
            self.fetchState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
