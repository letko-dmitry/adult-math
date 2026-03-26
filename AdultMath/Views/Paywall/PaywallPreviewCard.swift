import SwiftUI

/// Topic-specific preview card for the paywall illustration.
/// Each locked topic gets a contextually appropriate mini-card.
struct PaywallPreviewCard: View {
    let topic: Topic

    var body: some View {
        switch topic {
        case .homeBudget: budgetCard
        case .travelTime: travelCard
        case .cookingPortions: cookingCard
        case .timeManagement: timeCard
        case .fitnessGoals: fitnessCard
        default: budgetCard
        }
    }

    // MARK: - Home Budget

    private var budgetCard: some View {
        cardContainer {
            Label("Monthly Budget", systemImage: "house.fill")
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)

            Divider().overlay(Color(.separator).opacity(0.22))

            expenseRow("Rent", "$1,200")
            expenseRow("Groceries", "$340")
            expenseRow("Utilities", "$85")

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("Remaining")
                    .font(AppTheme.bodySemibold)
                Spacer()
                Text("?")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.accentGreen)
            }
        }
    }

    // MARK: - Travel Time

    private var travelCard: some View {
        cardContainer {
            Label("Road Trip", systemImage: "car.fill")
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)

            Divider().overlay(Color(.separator).opacity(0.22))

            infoRow("Distance", "245 mi")
            infoRow("Speed", "60 mph")
            infoRow("Gas price", "$3.45/gal")

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("Trip cost")
                    .font(AppTheme.bodySemibold)
                Spacer()
                Text("?")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.accentGreen)
            }
        }
    }

    // MARK: - Cooking Portions

    private var cookingCard: some View {
        cardContainer {
            Label("Scale Recipe", systemImage: "frying.pan.fill")
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("Serves 4")
                    .font(AppTheme.caption)
                    .foregroundStyle(.secondary)
                Image(systemName: "arrow.right")
                    .font(.system(size: 12))
                    .foregroundStyle(AppTheme.accentGreen)
                Text("Serves 6")
                    .font(AppTheme.captionMedium)
            }
            .padding(.vertical, 2)

            infoRow("Flour", "2 cups")
            infoRow("Sugar", "¾ cup")
            infoRow("Butter", "4 tbsp")

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("New amounts")
                    .font(AppTheme.bodySemibold)
                Spacer()
                Text("?")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.accentGreen)
            }
        }
    }

    // MARK: - Time Management

    private var timeCard: some View {
        cardContainer {
            Label("Daily Plan", systemImage: "clock.fill")
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)

            Divider().overlay(Color(.separator).opacity(0.22))

            taskRow("Meeting", "45 min")
            taskRow("Lunch break", "30 min")
            taskRow("Code review", "1.5 hr")

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("Free time left")
                    .font(AppTheme.bodySemibold)
                Spacer()
                Text("?")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.accentGreen)
            }
        }
    }

    // MARK: - Fitness Goals

    private var fitnessCard: some View {
        cardContainer {
            Label("Workout", systemImage: "figure.run")
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)

            Divider().overlay(Color(.separator).opacity(0.22))

            infoRow("Running", "320 cal")
            infoRow("Cycling", "280 cal")
            infoRow("Meal", "+450 cal")

            Divider().overlay(Color(.separator).opacity(0.22))

            HStack {
                Text("Net calories")
                    .font(AppTheme.bodySemibold)
                Spacer()
                Text("?")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.accentGreen)
            }
        }
    }

    // MARK: - Shared Components

    private func cardContainer<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            content()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .stroke(Color(.separator).opacity(0.18), lineWidth: 0.8)
        }
    }

    private func expenseRow(_ name: String, _ amount: String) -> some View {
        HStack {
            Text(name)
                .font(AppTheme.caption)
            Spacer()
            Text(amount)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(AppTheme.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(AppTheme.captionMedium)
        }
    }

    private func taskRow(_ task: String, _ duration: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(AppTheme.accentGreen.opacity(0.2))
                .frame(width: 8, height: 8)
            Text(task)
                .font(AppTheme.caption)
            Spacer()
            Text(duration)
                .font(AppTheme.captionMedium)
                .foregroundStyle(.secondary)
        }
    }
}
