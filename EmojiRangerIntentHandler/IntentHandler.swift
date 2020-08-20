//
//  IntentHandler.swift
//  EmojiRangerIntentHandler
//
//  Created by Philipp on 20.08.20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Intents

class IntentHandler: INExtension, DynamicCharacterSelectionIntentHandling {

    func provideHeroOptionsCollection(for intent: DynamicCharacterSelectionIntent,
                                      with completion: @escaping (INObjectCollection<Hero>?, Error?) -> Void) {
        let characters: [Hero] = CharacterDetail.availableCharacters.map { character in
            let hero = Hero(identifier: character.name, display: character.name)

            return hero
        }

        let remoteCharacters: [Hero] = CharacterDetail.remoteCharacters.map { character in
            let hero = Hero(identifier: character.name, display: character.name)

            return hero
        }

        let collection = INObjectCollection(items: characters + remoteCharacters)

        completion(collection, nil)
    }

    func defaultHero(for intent: DynamicCharacterSelectionIntent) -> Hero? {
        let character = CharacterDetail.egghead
        return Hero(identifier: character.identifier, display: character.name)
    }

    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
