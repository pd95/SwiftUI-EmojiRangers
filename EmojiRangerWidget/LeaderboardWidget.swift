/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A widget that shows a leaderboard of all available characters.
*/

import WidgetKit
import SwiftUI

struct LeaderboardProvider: TimelineProvider {
    public typealias Entry = LeaderboardEntry

    func placeholder(in context: Context) -> LeaderboardEntry {
        LeaderboardEntry(date: Date(), characters: CharacterDetail.availableCharacters)
    }

    func getSnapshot(in context: Context, completion: @escaping (LeaderboardEntry) -> Void) {
        let entry = LeaderboardEntry(date: Date(), characters: CharacterDetail.availableCharacters)

        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        CharacterDetail.loadLeaderboardData { (characters, error) in
            guard let characters = characters else {
                let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), characters: CharacterDetail.availableCharacters)], policy: .atEnd)

                completion(timeline)

                return
            }
            let timeline = Timeline(entries: [LeaderboardEntry(date: Date(), characters: characters)], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct LeaderboardEntry: TimelineEntry {
    public let date: Date
    var characters: [CharacterDetail]?
}

struct LeaderboardPlaceholderView: View {
    var body: some View {
        LeaderboardWidgetEntryView(entry: LeaderboardEntry(date: Date(), characters: nil))
    }
}

struct LeaderboardWidgetEntryView: View {
    var entry: LeaderboardProvider.Entry

    var body: some View {
        ZStack {
            Color.gameBackground
            AllCharactersView(characters: entry.characters)
                .padding()
        }
    }
}

struct LeaderboardWidget: Widget {
    private let kind: String = "LeaderboardWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LeaderboardProvider()) { entry in
            LeaderboardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ranger Leaderboard")
        .description("See all the rangers.")
        .supportedFamilies([.systemLarge])
        .onBackgroundURLSessionEvents { (sessionIdentifier, completion) in
            print("background fetch done: \(sessionIdentifier)")
            completion()
        }
    }
}

struct LeaderboardWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeaderboardWidgetEntryView(entry: LeaderboardEntry(date: Date(), characters: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

@main
struct EmojiBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        EmojiRangerWidget()
        LeaderboardWidget()
    }
}
