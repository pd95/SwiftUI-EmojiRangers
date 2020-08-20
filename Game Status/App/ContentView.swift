/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays the list of available characters.
*/
import SwiftUI
import Intents

struct ContentView: View {

    let characters: [CharacterDetail] = [.panda, .spouty, .egghead]

    @State var currentSelection: CharacterDetail?

    var body: some View {
        NavigationView {
            List {
                ForEach(characters) { character in
                    NavigationLink(destination: DetailView(character: character)
                                    .onAppear(perform: donateIntent),
                                   tag: character,
                                   selection: $currentSelection) {
                        TableRow(character: character)
                    }
                }
            }
            .onAppear {
                // Check for the last selected character.
                if let character = CharacterDetail.getLastSelectedCharacter() {
                    print("Last character selection: \(character)")
                }
            }
            .navigationBarTitle("Your Characters")
            .onOpenURL(perform: { url in
                if let hero = CharacterDetail.characterFromURL(url: url) {
                    selectCharacter(hero)
                }
            })
            .onContinueUserActivity("DynamicCharacterSelectionIntent", perform: { userActivity in
                if let _ = userActivity.interaction {
                    if let heroName = (userActivity.interaction?.intent as? DynamicCharacterSelectionIntent)?.hero?.identifier,
                       let hero = CharacterDetail.characterFromName(name: heroName) {
                        selectCharacter(hero)
                    }
                }
            })
        }
    }

    func selectCharacter(_ character: CharacterDetail) {
        guard currentSelection != character else {
            return
        }
        if currentSelection != nil {
            currentSelection = nil
            // Workaround SwiftUI Navigation Bug
            // Without this artificial delay, the navigation would not work!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                currentSelection = character
            }
        }
        else {
            currentSelection = character
        }
    }

    func donateIntent() {
        guard let character = currentSelection else {
            return
        }
        let intent = DynamicCharacterSelectionIntent()
        intent.hero = Hero(identifier: character.name, display: character.name)
        let interaction = INInteraction(intent: intent, response: nil)
        print("donating: \(interaction.identifier) with intent: \(interaction.intent.identifier ?? "-")")
        interaction.donate { (error) in
            if let error = error {
                print("Donation failed with \(error.localizedDescription)")
            }
            else {
                print("intent donated")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TableRow: View {
    let character: CharacterDetail
    var body: some View {
        HStack {
            Avatar(character: character)
            CharacterNameView(character)
                .padding()
        }
    }
}
