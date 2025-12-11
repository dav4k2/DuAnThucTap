import WidgetKit
import SwiftUI
import ActivityKit

struct CookingWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var recipeName: String
        var stepName: String
        var remainingTime: Int  // Giây còn lại, dùng để tính timer
    }
    
    // Attributes cố định (không thay đổi)
    var name: String = "Cooking Timer"
}

struct CookingWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CookingWidgetAttributes.self) { context in
            // UI cho Lock Screen (hiển thị dưới dạng banner)
            VStack(alignment: .leading) {
                Text(context.state.recipeName)
                    .font(.headline)
                Text(context.state.stepName)
                    .font(.subheadline)
                Text(timerInterval: Date()...Date().addingTimeInterval(TimeInterval(context.state.remainingTime)), showsHours: false)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .monospacedDigit()
            }
            .padding()
            .activityBackgroundTint(Color.green)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            // UI cho Dynamic Island
            DynamicIsland {
                // Expanded state (khi mở rộng)
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.stepName)
                        .font(.caption)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: Date()...Date().addingTimeInterval(TimeInterval(context.state.remainingTime)), showsHours: false)
                        .font(.caption)
                        .monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.recipeName)
                        .font(.caption2)
                }
            } compactLeading: {
                // Compact state (leading)
                Image(systemName: "flame.fill")  // Icon lửa đại diện nấu ăn
                    .foregroundColor(.orange)
            } compactTrailing: {
                // Compact state (trailing)
                Text(timerInterval: Date()...Date().addingTimeInterval(TimeInterval(context.state.remainingTime)), showsHours: false)
                    .monospacedDigit()
                    .font(.caption2)
            } minimal: {
                // Minimal state
                Image(systemName: "timer")
                    .foregroundColor(.green)
            }
            .widgetURL(URL(string: "cookingapp://open"))  // URL để mở app khi tap
            .keylineTint(Color.green)
        }
    }
}

struct CookingWidget_Previews: PreviewProvider {
    static let attributes = CookingWidgetAttributes()
    static let contentState = CookingWidgetAttributes.ContentState(recipeName: "Đang nấu ăn", stepName: "Ninh nước dùng", remainingTime: 1800)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
    }
}
