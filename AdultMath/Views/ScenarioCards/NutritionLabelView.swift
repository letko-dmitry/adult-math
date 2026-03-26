import SwiftUI

struct NutritionLabelView: View {
    let data: NutritionData
    var hideTotal: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 2) {
                Text(data.title)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Nutrition Facts")
                    .font(.system(size: 28, weight: .black))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 4)

            // Thick divider
            Rectangle()
                .fill(.primary)
                .frame(height: 8)
                .padding(.horizontal, 16)

            // Ingredients list
            VStack(spacing: 0) {
                ForEach(Array(data.ingredients.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 0) {
                        HStack {
                            Text(item.name)
                                .font(.system(size: 15, weight: .medium))
                            Spacer()
                            Text("\(item.calories) cal")
                                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        }
                        .padding(.vertical, 8)

                        if index < data.ingredients.count - 1 {
                            Rectangle()
                                .fill(.secondary.opacity(0.3))
                                .frame(height: 0.5)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)

            // Thick divider before total
            Rectangle()
                .fill(.primary)
                .frame(height: 4)
                .padding(.horizontal, 16)
                .padding(.top, 4)

            // Total calories
            HStack {
                Text("Total Calories")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                if hideTotal {
                    Text("? cal")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundStyle(Color.accentColor)
                } else {
                    Text("\(data.totalCalories) cal")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Calorie limit indicator
            if let limit = data.calorieLimit {
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.horizontal, 16)

                HStack {
                    Image(systemName: "target")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                    Text("Daily limit: \(limit) cal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .padding(.bottom, 4)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .stroke(.primary, lineWidth: 2.5)
        }
    }
}
