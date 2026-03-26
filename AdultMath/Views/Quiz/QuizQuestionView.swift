import SwiftUI

struct QuizQuestionView: View {
    @State private var viewModel: QuizQuestionViewModel
    let onAnswer: (Bool) -> Void
    let onContinue: () -> Void

    init(question: Question, onAnswer: @escaping (Bool) -> Void, onContinue: @escaping () -> Void) {
        _viewModel = State(initialValue: QuizQuestionViewModel(question: question))
        self.onAnswer = onAnswer
        self.onContinue = onContinue
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.spacingContent) {
                scenarioCard
                    .padding(.horizontal, AppTheme.paddingMedium)

                Text(viewModel.question.questionText)
                    .font(AppTheme.questionTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.paddingLarge)

                VStack(spacing: 10) {
                    ForEach(viewModel.shuffledIndices, id: \.self) { originalIndex in
                        VStack(alignment: .leading, spacing: 8) {
                            if viewModel.showsNegativeFeedback(for: originalIndex) {
                                FeedbackView(isCorrect: false, explanation: viewModel.question.explanation)
                                    .padding(.leading, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }

                            OptionButton(
                                text: viewModel.question.options[originalIndex],
                                state: viewModel.optionState(for: originalIndex),
                                action: { selectAnswer(originalIndex) }
                            )
                            .overlay(alignment: .topTrailing) {
                                if viewModel.showsPositiveFeedback(for: originalIndex) {
                                    FeedbackView(isCorrect: true, explanation: viewModel.question.explanation)
                                        .offset(x: 8, y: -12)
                                        .transition(.opacity.combined(with: .scale(scale: 0.92)))
                                        .zIndex(1)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, AppTheme.paddingMedium)
            }
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("Continue", action: onContinue)
                .disabled(!viewModel.canContinue)
                .padding(.horizontal, AppTheme.paddingMedium)
                .padding(.bottom, AppTheme.bottomScreenCTAInset)
                .animation(.easeInOut(duration: 0.25), value: viewModel.canContinue)
        }
    }

    @ViewBuilder
    private var scenarioCard: some View {
        switch viewModel.question.scenarioData {
        case .receipt(let data):
            ReceiptCardView(data: data)
        case .nutrition(let data):
            NutritionLabelView(data: data, hideTotal: true)
        case .priceTag(let data):
            PriceTagCardView(data: data)
        }
    }

    private func selectAnswer(_ index: Int) {
        guard let correct = viewModel.selectAnswer(index) else { return }
        onAnswer(correct)
        withAnimation(.easeInOut(duration: 0.3)) {
            viewModel.revealFeedback()
        }
    }
}
