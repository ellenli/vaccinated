//
//  VaccinatedWidget.swift
//  VaccinatedWidget
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LeaderCardWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
//                Text("Recent Doses")
//                    .font(Font.system(size:12, design: .default).weight(.semibold))
                
                Spacer()
                
                Image("Virus")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
            }
            
            Spacer()

            Text("Moderna")
                .font(Font.system(size:14, design: .rounded).weight(.semibold))
            
            Text("July 8, 2021")
                .font(.caption)
                .foregroundColor(.secondary)

            
            Spacer()
                .frame(height: 8)

            Text("Pfizer-BioNTech")
                .font(Font.system(size:14, design: .rounded).weight(.semibold))
            
            Text("May 15, 2021")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .cornerRadius(0)
    }
}

@main
struct LeaderCardWidget: Widget {
    let kind: String = "LeaderCardWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LeaderCardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Vaccinated")
        .description("Your COVID-19 vaccines at a glance.")
    }
}

struct LeaderCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        LeaderCardWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
