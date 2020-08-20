//
//  EmojiRangerWidget.swift
//  EmojiRangerWidget
//
//  Created by Philipp on 20.08.20.
//  Copyright © 2020 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry

    typealias Intent = DynamicCharacterSelectionIntent

    func character(for configuration: DynamicCharacterSelectionIntent) -> CharacterDetail {
        CharacterDetail.characterFromName(name: configuration.hero?.identifier) ?? .panda
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), character: .panda, relevance: nil)
    }

    func getSnapshot(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), character: character(for: configuration), relevance: nil)
        completion(entry)
    }

    func getTimeline(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        let selectedCharacter = character(for: configuration)
        let endDate = selectedCharacter.fullHealthDate
        let oneMinute: TimeInterval = 60
        var currentDate = Date()
        var entries: [SimpleEntry] = []

        while currentDate < endDate {
            let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
            let entry = SimpleEntry(date: currentDate, character: selectedCharacter, relevance: relevance)

            currentDate += oneMinute
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let character: CharacterDetail
    let relevance: TimelineEntryRelevance?
}

struct EmojiRangerWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
            case .systemMedium:
                ZStack {
                    HStack(alignment: .top) {
                        AvatarView(entry.character)
                        Text(entry.character.bio)
                            .padding()
                    }
                    .padding()
                }
                .widgetURL(entry.character.url)
                .foregroundColor(.white)
                .background(Color.gameWidgetBackground)

            default:
                ZStack {
                    AvatarView(entry.character)
                }
                .widgetURL(entry.character.url)
                .foregroundColor(.white)
                .background(Color.gameWidgetBackground)
        }
    }
}

struct EmojiRangerWidget: Widget {
    let kind: String = "EmojiRangerWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicCharacterSelectionIntent.self, provider: Provider()) { entry in
            EmojiRangerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ranger Detail")
        .description("See your favorite ranger.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct EmojiRangerWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .panda, relevance: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))

            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), character: .egghead, relevance: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
