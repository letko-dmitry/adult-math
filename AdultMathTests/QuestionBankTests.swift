import Testing
import Foundation
@testable import AdultMath

@Suite("Question Bank")
struct QuestionBankTests {

    // MARK: - JSON Decoding & Accessibility

    @Test("Tips & Checks JSON loads and decodes")
    func tipsAndChecksLoads() {
        #expect(QuestionBank.tipsAndChecksQuestions.count == 40)
    }

    @Test("Food & Calories JSON loads and decodes")
    func foodAndCaloriesLoads() {
        #expect(QuestionBank.foodAndCaloriesQuestions.count == 40)
    }

    @Test("Shopping & Discounts JSON loads and decodes")
    func shoppingAndDiscountsLoads() {
        #expect(QuestionBank.shoppingAndDiscountsQuestions.count == 40)
    }

    // MARK: - Structural Validity

    @Test("All questions have valid correctAnswerIndex", arguments: allQuestions())
    func correctAnswerIndexInRange(question: Question) {
        #expect(
            question.correctAnswerIndex >= 0 && question.correctAnswerIndex < question.options.count,
            "\(question.id): correctAnswerIndex \(question.correctAnswerIndex) out of range for \(question.options.count) options"
        )
    }

    @Test("All questions have exactly 4 options", arguments: allQuestions())
    func fourOptions(question: Question) {
        #expect(question.options.count == 4, "\(question.id): expected 4 options, got \(question.options.count)")
    }

    @Test("All question IDs are unique across all topics")
    func uniqueIDs() {
        let all = Self.allQuestions()
        let ids = all.map(\.id)
        let unique = Set(ids)
        #expect(ids.count == unique.count, "Found duplicate IDs")
    }

    @Test("All questions have non-empty explanation", arguments: allQuestions())
    func nonEmptyExplanation(question: Question) {
        #expect(!question.explanation.isEmpty, "\(question.id): explanation should not be empty")
    }

    @Test("All options are unique within each question", arguments: allQuestions())
    func uniqueOptions(question: Question) {
        let unique = Set(question.options)
        #expect(
            question.options.count == unique.count,
            "\(question.id): has duplicate options"
        )
    }

    // MARK: - Math: Receipt line items sum to subtotal

    @Test("Receipt line items sum equals subtotal", arguments: QuestionBank.tipsAndChecksQuestions)
    func receiptSubtotalCorrect(question: Question) {
        guard case .receipt(let data) = question.scenarioData else { return }
        let itemSum = data.lineItems.reduce(0.0) { $0 + $1.price }
        #expect(
            abs(itemSum - data.subtotal) < 0.01,
            "\(question.id): line items sum \(itemSum.formatted(.number.precision(.fractionLength(2)))) ≠ subtotal \(data.subtotal.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    // MARK: - Math: Tip calculations

    @Test("Simple tip amount matches calculation", arguments: QuestionBank.tipsAndChecksQuestions)
    func simpleTipAmountCorrect(question: Question) {
        guard case .receipt(let data) = question.scenarioData,
              let tipPct = data.tipPercentage else { return }

        let q = question.questionText.lowercased()

        // Only verify simple "what's the X% tip" questions
        guard q.contains("tip"),
              !q.contains("split") && !q.contains("per person") && !q.contains("each") &&
              !q.contains("difference") && !q.contains("round") && !q.contains("coupon") &&
              !q.contains("comped") && !q.contains("free") && !q.contains("delivery") &&
              !q.contains("total") && !q.contains("including") else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerValue = Self.extractDollarValue(from: correctAnswer) else { return }

        let tipAmount = data.subtotal * Double(tipPct) / 100.0
        #expect(
            abs(answerValue - tipAmount) < 0.02,
            "\(question.id): \(tipPct)% of \(data.subtotal.formatted(.number.precision(.fractionLength(2)))) = \(tipAmount.formatted(.number.precision(.fractionLength(2)))) but answer says \(answerValue.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    @Test("Simple total-with-tip matches calculation", arguments: QuestionBank.tipsAndChecksQuestions)
    func simpleTotalWithTipCorrect(question: Question) {
        guard case .receipt(let data) = question.scenarioData,
              let tipPct = data.tipPercentage else { return }

        let q = question.questionText.lowercased()

        // Only verify simple "total including tip" questions (no splitting, rounding, tip-only, etc.)
        guard (q.contains("total") || q.contains("including")),
              !q.contains("split") && !q.contains("per person") && !q.contains("each") &&
              !q.contains("round") && !q.contains("coupon") && !q.contains("comped") &&
              !q.contains("how much tip") else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerValue = Self.extractDollarValue(from: correctAnswer) else { return }

        let totalWithTip = data.subtotal * (1.0 + Double(tipPct) / 100.0)
        #expect(
            abs(answerValue - totalWithTip) < 0.02,
            "\(question.id): total should be \(totalWithTip.formatted(.number.precision(.fractionLength(2)))) but answer says \(answerValue.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    @Test("Bill split per person matches calculation", arguments: QuestionBank.tipsAndChecksQuestions)
    func billSplitCorrect(question: Question) {
        guard case .receipt(let data) = question.scenarioData,
              let tipPct = data.tipPercentage else { return }

        let q = question.questionText.lowercased()
        guard q.contains("split") || q.contains("per person") || q.contains("each") else { return }

        // Extract number of people
        guard let people = Self.extractPeopleCount(from: question.questionText) else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerValue = Self.extractDollarValue(from: correctAnswer) else { return }

        let tipAmount = data.subtotal * Double(tipPct) / 100.0
        let totalWithTip = data.subtotal + tipAmount

        // "tip per person" → tipAmount / people, otherwise totalWithTip / people
        let isTipPerPerson = q.contains("tip per person") || q.contains("tip each")
        let expected = isTipPerPerson ? tipAmount / Double(people) : totalWithTip / Double(people)
        #expect(
            abs(answerValue - expected) < 0.02,
            "\(question.id): expected \(expected.formatted(.number.precision(.fractionLength(2)))) but answer says \(answerValue.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    // MARK: - Math: Nutrition ingredients sum to totalCalories

    @Test("Nutrition ingredients sum equals totalCalories", arguments: QuestionBank.foodAndCaloriesQuestions)
    func nutritionTotalCorrect(question: Question) {
        guard case .nutrition(let data) = question.scenarioData else { return }
        let ingredientSum = data.ingredients.reduce(0) { $0 + $1.calories }
        #expect(
            ingredientSum == data.totalCalories,
            "\(question.id): ingredients sum \(ingredientSum) ≠ totalCalories \(data.totalCalories)"
        )
    }

    // MARK: - Math: Calorie answer verification

    @Test("Simple total-calorie answer matches scenario data", arguments: QuestionBank.foodAndCaloriesQuestions)
    func calorieAnswerMatchesData(question: Question) {
        guard case .nutrition(let data) = question.scenarioData else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        let q = question.questionText.lowercased()

        // Only verify simple "what are the total calories" questions
        guard (q.contains("total calories") || q.contains("total cal")) &&
              !q.contains("skip") && !q.contains("replac") && !q.contains("save") &&
              !q.contains("week") && !q.contains("day") && !q.contains("prep") &&
              !q.contains("per serving") && !q.contains("serves") else { return }

        guard let answerCal = Self.extractCalorieValue(from: correctAnswer) else { return }

        #expect(
            answerCal == data.totalCalories,
            "\(question.id): answer says \(answerCal) cal but totalCalories is \(data.totalCalories)"
        )
    }

    @Test("Per-serving calorie answer matches calculation", arguments: QuestionBank.foodAndCaloriesQuestions)
    func perServingCalorieCorrect(question: Question) {
        guard case .nutrition(let data) = question.scenarioData else { return }

        let q = question.questionText.lowercased()
        guard q.contains("per serving") || (q.contains("serves") && q.contains("how many calories")) else { return }

        guard let servings = Self.extractServingCount(from: question.questionText) else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerCal = Self.extractCalorieValue(from: correctAnswer) else { return }

        let expected = data.totalCalories / servings
        #expect(
            answerCal == expected,
            "\(question.id): \(data.totalCalories) ÷ \(servings) = \(expected) but answer says \(answerCal)"
        )
    }

    // MARK: - Math: Shopping discount calculations

    @Test("Single-discount price matches calculation", arguments: QuestionBank.shoppingAndDiscountsQuestions)
    func singleDiscountCorrect(question: Question) {
        guard case .priceTag(let data) = question.scenarioData,
              let discountPercent = data.discountPercent,
              data.items.count == 1,
              let original = data.items[0].originalPrice else { return }

        let q = question.questionText.lowercased()
        guard q.contains("sale price") || q.contains("after") else { return }

        // Skip stacked discounts
        let label = data.discountLabel ?? ""
        if label.contains("+") || label.lowercased().contains("extra") { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerValue = Self.extractDollarValue(from: correctAnswer) else { return }

        let expectedSale = original * (1.0 - Double(discountPercent) / 100.0)
        #expect(
            abs(answerValue - expectedSale) < 0.02,
            "\(question.id): \(original.formatted(.number.precision(.fractionLength(2)))) - \(discountPercent)% = \(expectedSale.formatted(.number.precision(.fractionLength(2)))) but answer says \(answerValue.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    @Test("Total savings matches sum of discounts", arguments: QuestionBank.shoppingAndDiscountsQuestions)
    func totalSavingsCorrect(question: Question) {
        guard case .priceTag(let data) = question.scenarioData else { return }

        let q = question.questionText.lowercased()
        guard q.contains("save") && (q.contains("entire") || q.contains("total")) else { return }

        let correctAnswer = question.options[question.correctAnswerIndex]
        guard let answerValue = Self.extractDollarValue(from: correctAnswer) else { return }

        var totalSavings = 0.0
        for item in data.items {
            if let original = item.originalPrice {
                totalSavings += original - item.price
            }
        }
        guard totalSavings > 0 else { return }

        #expect(
            abs(answerValue - totalSavings) < 0.02,
            "\(question.id): total savings should be \(totalSavings.formatted(.number.precision(.fractionLength(2)))) but answer says \(answerValue.formatted(.number.precision(.fractionLength(2))))"
        )
    }

    // MARK: - Helpers

    static func allQuestions() -> [Question] {
        Array(QuestionBank.tipsAndChecksQuestions)
        + Array(QuestionBank.foodAndCaloriesQuestions)
        + Array(QuestionBank.shoppingAndDiscountsQuestions)
    }

    private static func extractDollarValue(from text: String) -> Double? {
        guard let match = text.firstMatch(of: /\$(\d+\.?\d*)/) else { return nil }
        return Double(match.1)
    }

    private static func extractCalorieValue(from text: String) -> Int? {
        if let match = text.firstMatch(of: /(\d+)\s*[Cc][Aa][Ll]/) {
            return Int(match.1)
        }
        guard let match = text.firstMatch(of: /(\d+)/) else { return nil }
        return Int(match.1)
    }

    private static func extractServingCount(from text: String) -> Int? {
        if let match = text.firstMatch(of: /[Ss]erves\s+(\d+)/) {
            return Int(match.1)
        }
        if let match = text.firstMatch(of: /(\d+)\s+[Ss]erving/) {
            return Int(match.1)
        }
        return nil
    }

    private static func extractPeopleCount(from text: String) -> Int? {
        // "among 3 friends", "3 friends", "3 people", "2 ways", "for 4 people", "for 6 people"
        let patterns: [Regex<(Substring, Substring)>] = [
            /among\s+(\d+)/,
            /(\d+)\s+(?:friend|people|person|way)/,
            /for\s+(\d+)\s+people/,
            /[Bb]runch for\s+(\d+)/,
        ]
        for pattern in patterns {
            if let match = text.firstMatch(of: pattern) {
                return Int(match.1)
            }
        }
        return nil
    }
}
