//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentJoke: DadJoke = DadJoke(id: "", joke: "Knock, knock...", status: 0)
    
    @State var favourites: [DadJoke] = []
    
    
    @State var currentJokeAddedToFavourites: Bool = false
    var body: some View {
        VStack {
            
            Text(currentJoke.joke)
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(30)
                .minimumScaleFactor(0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 4)
                )
                .padding(10)
            
            
            Image(systemName: "heart.circle")
                .resizable()
                .foregroundColor(currentJokeAddedToFavourites == true ? .red : .secondary)
                .frame(width: 35, height: 35, alignment: .center)
                .onTapGesture {
                    if currentJokeAddedToFavourites == false {
                        favourites.append(currentJoke)
                        
                        currentJokeAddedToFavourites == true
                    }
                }
            
            
            Button(action: {
                //MARK: call the function that will get us a new joke
                Task {
                    await loadNewJoke()
                }
                
            }, label: {
                Text("Another One!")
            })
                .buttonStyle(.bordered)
                .padding()
            
            
            HStack {
                Text("Favoutites")
                    .bold()
                
                Spacer()
            }
            
            
            List(favourites, id: \.self）{ currentFavourite in
                Text(currentFavourite.joke)
            }
                 
                 Spacer()
                 
                 }
                 // When the app opens, get a new joke from the web service
                    .task {
                
                //MARK: load joke from the endpoint!
                //We are calling or invoking the function
                //Named loadNewJoke
                //A term for this is the call site of a funciton
                //this just means that we, as the programmer are aware that this function is asyncrhonus
                //result might come right away, or , take some time to complete.
                //ALSO: any code below the call will run before the function call completes
                await loadNewJoke()
                
            }
                    .navigationTitle("icanhazdadjoke?")
                    .padding()
                 }
                 
                 //MARK: functions
                 
                 //Define function loadNewJoke
                 //Teaching app to do new thing
                 func loadNewJoke()async{
                // Assemble the URL that points to the endpoint
                let url = URL(string: "https://icanhazdadjoke.com/")!
                
                // Define the type of data we want from the endpoint
                // Configure the request to the web site
                var request = URLRequest(url: url)
                // Ask for JSON data
                request.setValue("application/json",
                                 forHTTPHeaderField: "Accept")
                
                // Start a session to interact (talk with) the endpoint
                let urlSession = URLSession.shared
                
                // Try to fetch a new joke
                // It might not work, so we use a do-catch block
                do {
                    
                    // Get the raw data from the endpoint
                    let (data, _) = try await urlSession.data(for: request)
                    
                    // Attempt to decode the raw data into a Swift structure
                    // Takes what is in "data" and tries to put it into "currentJoke"
                    //                                 DATA TYPE TO DECODE TO
                    //                                         |
                    //                                         V
                    currentJoke = try JSONDecoder().decode(DadJoke.self, from: data)
                    
                    currentJokeAddedToFavourites = false
                    
                } catch {
                    print("Could not retrieve or decode the JSON from endpoint.")
                    // Print the contents of the "error" constant that the do-catch block
                    // populates
                    print(error)
                }
                
            }
                 
                 }
                 
                 struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    NavigationView {
                        ContentView()
                    }
                }
            }
