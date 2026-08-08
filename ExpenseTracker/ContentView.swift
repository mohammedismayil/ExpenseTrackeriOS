//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Mohammed Ismayil on 24/06/26.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var isShowingAddTransaction: Bool = false
    @State private var transactions: [MoneyTransaction] = MoneyTransaction.samples
    @State private var selectedMonth: String = "This month"

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.canvas
                .ignoresSafeArea()

            Group {
                switch selectedTab {
                case .home:
                    HomeView(
                        transactions: transactions,
                        selectedMonth: selectedMonth,
                        onAddTransaction: { isShowingAddTransaction = true },
                        onSeeAll: { selectedTab = .activity }
                    )
                case .budgets:
                    BudgetsView(onAddTransaction: { isShowingAddTransaction = true })
                case .activity:
                    ActivityView(
                        transactions: transactions,
                        onAddTransaction: { isShowingAddTransaction = true }
                    )
                case .insights:
                    InsightsView()
                }
            }
            .safeAreaPadding(.bottom, 76)

            AppTabBar(selectedTab: $selectedTab, onAddTransaction: { isShowingAddTransaction = true })
        }
        .sheet(isPresented: $isShowingAddTransaction) {
            AddTransactionView { transaction in
                transactions.insert(transaction, at: 0)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

private enum AppTab: String, CaseIterable, Identifiable {
    case home
    case budgets
    case activity
    case insights

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .budgets: return "Budgets"
        case .activity: return "Activity"
        case .insights: return "Insights"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .budgets: return "target"
        case .activity: return "list.bullet"
        case .insights: return "sparkles"
        }
    }
}

private struct MoneyTransaction: Identifiable {
    let id: UUID
    let merchant: String
    let category: SpendingCategory
    let amount: Double
    let date: String
    let icon: String
    let tint: Color
    let isIncome: Bool

    init(
        id: UUID = UUID(),
        merchant: String,
        category: SpendingCategory,
        amount: Double,
        date: String,
        icon: String,
        tint: Color,
        isIncome: Bool = false
    ) {
        self.id = id
        self.merchant = merchant
        self.category = category
        self.amount = amount
        self.date = date
        self.icon = icon
        self.tint = tint
        self.isIncome = isIncome
    }

    static let samples: [MoneyTransaction] = [
        MoneyTransaction(merchant: "Blue Bottle Coffee", category: .food, amount: 6.45, date: "Today, 9:42 AM", icon: "cup.and.saucer.fill", tint: AppColors.coral),
        MoneyTransaction(merchant: "MTA Metro", category: .transport, amount: 2.90, date: "Today, 8:10 AM", icon: "tram.fill", tint: AppColors.blue),
        MoneyTransaction(merchant: "Whole Foods Market", category: .groceries, amount: 84.22, date: "Yesterday", icon: "cart.fill", tint: AppColors.mintDeep),
        MoneyTransaction(merchant: "Lumen Studio", category: .entertainment, amount: 18.00, date: "Yesterday", icon: "music.note", tint: AppColors.lilac),
        MoneyTransaction(merchant: "Acme Corp · Paycheck", category: .income, amount: 3250.00, date: "Aug 1", icon: "arrow.down.left", tint: AppColors.mintDeep, isIncome: true)
    ]
}

private enum SpendingCategory: String, CaseIterable, Identifiable {
    case food = "Food & coffee"
    case groceries = "Groceries"
    case transport = "Transport"
    case entertainment = "Fun"
    case home = "Home"
    case income = "Income"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .groceries: return "cart.fill"
        case .transport: return "tram.fill"
        case .entertainment: return "popcorn.fill"
        case .home: return "house.fill"
        case .income: return "arrow.down.left"
        }
    }
}

private struct Budget: Identifiable {
    let id: UUID = UUID()
    let category: SpendingCategory
    let spent: Double
    let limit: Double
    let tint: Color

    var progress: Double {
        min(spent / max(limit, 1), 1)
    }

    static let samples: [Budget] = [
        Budget(category: .food, spent: 286, limit: 400, tint: AppColors.coral),
        Budget(category: .transport, spent: 142, limit: 250, tint: AppColors.blue),
        Budget(category: .entertainment, spent: 96, limit: 180, tint: AppColors.lilac),
        Budget(category: .home, spent: 720, limit: 900, tint: AppColors.mustard)
    ]
}

private enum AppColors {
    static let canvas: Color = Color(red: 0.95, green: 0.95, blue: 0.92)
    static let ink: Color = Color(red: 0.06, green: 0.12, blue: 0.17)
    static let inkSoft: Color = Color(red: 0.30, green: 0.35, blue: 0.37)
    static let line: Color = Color(red: 0.87, green: 0.87, blue: 0.83)
    static let card: Color = Color.white.opacity(0.78)
    static let mint: Color = Color(red: 0.69, green: 0.90, blue: 0.80)
    static let mintDeep: Color = Color(red: 0.20, green: 0.55, blue: 0.42)
    static let coral: Color = Color(red: 0.95, green: 0.40, blue: 0.34)
    static let blue: Color = Color(red: 0.28, green: 0.51, blue: 0.77)
    static let lilac: Color = Color(red: 0.53, green: 0.45, blue: 0.74)
    static let mustard: Color = Color(red: 0.82, green: 0.63, blue: 0.22)
}

private struct HomeView: View {
    let transactions: [MoneyTransaction]
    let selectedMonth: String
    let onAddTransaction: () -> Void
    let onSeeAll: () -> Void

    private var totalSpent: Double {
        transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                header
                balanceCard
                quickStats
                spendingSection
                recentSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Good morning, Alex")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.inkSoft)
                Text("Your money, made clear.")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                    .tracking(-0.6)
            }

            Spacer(minLength: 12)

            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(AppColors.ink)
                        .frame(width: 44, height: 44)
                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.mint)
                        .frame(width: 44, height: 44)
                    Circle()
                        .fill(AppColors.coral)
                        .frame(width: 9, height: 9)
                        .overlay(Circle().stroke(AppColors.canvas, lineWidth: 2))
                        .offset(x: -1, y: 1)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Notifications")
        }
        .padding(.bottom, 22)
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("TOTAL BALANCE")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(1.3)
                    .foregroundStyle(AppColors.ink.opacity(0.62))
                Spacer()
                Menu {
                    Button("This month") {}
                    Button("Last month") {}
                    Button("Year to date") {}
                } label: {
                    HStack(spacing: 5) {
                        Text(selectedMonth)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundStyle(AppColors.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(.white.opacity(0.68), in: Capsule())
                }
            }

            Text("$12,842.60")
                .font(.system(size: 39, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
                .tracking(-1.2)
                .padding(.top, 18)

            HStack(spacing: 6) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .bold))
                Text("8.4%")
                    .fontWeight(.bold)
                Text("from last month")
            }
            .font(.system(size: 13, design: .rounded))
            .foregroundStyle(AppColors.mintDeep)
            .padding(.top, 5)

            BalanceSparkline()
                .frame(height: 65)
                .padding(.top, 12)
        }
        .padding(20)
        .background(AppColors.mint, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Circle()
                .fill(.white.opacity(0.16))
                .frame(width: 115, height: 115)
                .offset(x: 34, y: -42)
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: AppColors.mintDeep.opacity(0.12), radius: 20, y: 10)
    }

    private var quickStats: some View {
        HStack(spacing: 10) {
            StatCard(title: "Spent", value: "$1,284", detail: "of $3,500", tint: AppColors.coral, icon: "arrow.up.right")
            StatCard(title: "Saved", value: "$620", detail: "+12% this month", tint: AppColors.mintDeep, icon: "leaf.fill")
        }
        .padding(.top, 13)
    }

    private var spendingSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Spending pulse", actionTitle: "See insights", action: {})

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .firstTextBaseline) {
                    Text("$\(totalSpent, specifier: "%.2f")")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.ink)
                    Text("spent this week")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.inkSoft)
                    Spacer()
                    Text("↓ 6.2%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.mintDeep)
                }

                WeeklyBars()
                    .frame(height: 94)
            }
            .padding(17)
            .background(AppColors.card, in: RoundedRectangle(cornerRadius: 21, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 21, style: .continuous).stroke(.white.opacity(0.75), lineWidth: 1))
        }
        .padding(.top, 27)
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Recent activity", actionTitle: "See all", action: onSeeAll)
            ForEach(Array(transactions.prefix(4))) { transaction in
                TransactionRow(transaction: transaction)
            }
        }
        .padding(.top, 27)
        .padding(.bottom, 14)
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let detail: String
    let tint: Color
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text(title.uppercased())
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(1.0)
                    .foregroundStyle(AppColors.inkSoft)
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(tint)
                    .frame(width: 26, height: 26)
                    .background(tint.opacity(0.14), in: Circle())
            }
            Text(value)
                .font(.system(size: 21, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
                .tracking(-0.5)
            Text(detail)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.inkSoft)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(AppColors.card, in: RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
}

private struct BudgetsView: View {
    let onAddTransaction: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                PageHeader(eyebrow: "A LITTLE STRUCTURE", title: "Your budgets", subtitle: "Spend with intention, not restriction.")

                budgetSummary
                    .padding(.top, 25)

                SectionHeader(title: "Monthly limits", actionTitle: "Edit", action: {})
                    .padding(.top, 30)

                VStack(spacing: 0) {
                    ForEach(Budget.samples) { budget in
                        BudgetRow(budget: budget)
                        if budget.id != Budget.samples.last?.id {
                            Divider().overlay(AppColors.line).padding(.leading, 55)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(AppColors.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))

                Button(action: {}) {
                    HStack(spacing: 9) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .bold))
                        Text("Create a new budget")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(AppColors.ink)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.mint, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.top, 16)

                insightCallout
                    .padding(.top, 28)
                    .padding(.bottom, 12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }

    private var budgetSummary: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .stroke(AppColors.line, lineWidth: 9)
                Circle()
                    .trim(from: 0, to: 0.64)
                    .stroke(AppColors.mintDeep, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text("64%")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.ink)
                    Text("used")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(AppColors.inkSoft)
                }
            }
            .frame(width: 93, height: 93)

            VStack(alignment: .leading, spacing: 7) {
                Text("$1,216 left")
                    .font(.system(size: 21, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                Text("You’re on track to stay\nunder budget this month.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.inkSoft)
                    .lineSpacing(2)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .background(AppColors.mint.opacity(0.48), in: RoundedRectangle(cornerRadius: 23, style: .continuous))
    }

    private var insightCallout: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppColors.mustard)
                .frame(width: 32, height: 32)
                .background(AppColors.mustard.opacity(0.14), in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text("A small win")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                Text("You’ve spent 18% less on eating out than last month.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(15)
        .background(.white.opacity(0.63), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct BudgetRow: View {
    let budget: Budget

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: budget.category.icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(budget.tint)
                .frame(width: 34, height: 34)
                .background(budget.tint.opacity(0.13), in: Circle())

            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(budget.category.rawValue)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.ink)
                    Spacer()
                    Text("$\(budget.spent, specifier: "%.0f") / $\(budget.limit, specifier: "%.0f")")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppColors.inkSoft)
                }
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(AppColors.line)
                        Capsule()
                            .fill(budget.tint)
                            .frame(width: proxy.size.width * budget.progress)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.vertical, 12)
    }
}

private struct ActivityView: View {
    let transactions: [MoneyTransaction]
    let onAddTransaction: () -> Void
    @State private var searchText: String = ""
    @State private var selectedFilter: ActivityFilter = .all

    private var filteredTransactions: [MoneyTransaction] {
        transactions.filter { transaction in
            let matchesSearch = searchText.isEmpty || transaction.merchant.localizedStandardContains(searchText) || transaction.category.rawValue.localizedStandardContains(searchText)
            let matchesFilter = selectedFilter == .all || (selectedFilter == .income && transaction.isIncome) || (selectedFilter == .spending && !transaction.isIncome)
            return matchesSearch && matchesFilter
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom) {
                    PageHeader(eyebrow: "EVERYTHING IN ONE PLACE", title: "Activity", subtitle: "A clear trail of where it went.")
                    Spacer()
                    Button(action: onAddTransaction) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(AppColors.ink)
                            .frame(width: 42, height: 42)
                            .background(AppColors.mint, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 2)
                }

                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.inkSoft)
                    TextField("Search transactions", text: $searchText)
                        .font(.system(size: 14, design: .rounded))
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.top, 23)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ActivityFilter.allCases) { filter in
                            Button {
                                selectedFilter = filter
                            } label: {
                                Text(filter.title)
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundStyle(selectedFilter == filter ? AppColors.ink : AppColors.inkSoft)
                                    .padding(.horizontal, 14)
                                    .frame(height: 34)
                                    .background(selectedFilter == filter ? AppColors.mint : .white.opacity(0.66), in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 13)

                VStack(spacing: 0) {
                    if filteredTransactions.isEmpty {
                        EmptyActivityView()
                            .padding(.vertical, 45)
                    } else {
                        ForEach(filteredTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                            if transaction.id != filteredTransactions.last?.id {
                                Divider().overlay(AppColors.line).padding(.leading, 55)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .background(AppColors.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .padding(.top, 18)
                .padding(.bottom, 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }
}

private enum ActivityFilter: String, CaseIterable, Identifiable {
    case all
    case spending
    case income

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All activity"
        case .spending: return "Spending"
        case .income: return "Income"
        }
    }
}

private struct EmptyActivityView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.system(size: 25, weight: .medium))
                .foregroundStyle(AppColors.inkSoft)
            Text("No matches yet")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
            Text("Try a different search or filter.")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.inkSoft)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct InsightsView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                PageHeader(eyebrow: "THE WHY BEHIND THE NUMBERS", title: "Your insights", subtitle: "Small patterns. Better decisions.")

                VStack(alignment: .leading, spacing: 17) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("MONTHLY MOMENTUM")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .tracking(1.1)
                                .foregroundStyle(AppColors.inkSoft)
                            Text("You’re building a\nhealthy rhythm.")
                                .font(.system(size: 23, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColors.ink)
                                .tracking(-0.5)
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundStyle(AppColors.mintDeep)
                            .frame(width: 57, height: 57)
                            .background(AppColors.mint, in: Circle())
                    }
                    InsightMiniChart()
                        .frame(height: 110)
                    HStack(spacing: 17) {
                        InsightMetric(value: "+12%", label: "saved", color: AppColors.mintDeep)
                        InsightMetric(value: "−18%", label: "dining out", color: AppColors.coral)
                        InsightMetric(value: "4 days", label: "on track", color: AppColors.blue)
                    }
                }
                .padding(20)
                .background(AppColors.mint.opacity(0.45), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.top, 24)

                SectionHeader(title: "Worth knowing", actionTitle: "This month", action: {})
                    .padding(.top, 30)

                VStack(spacing: 10) {
                    InsightCard(icon: "fork.knife", tint: AppColors.coral, title: "Your best trade-off", description: "Cooking at home twice more each week could free up $96 monthly.", action: "See how")
                    InsightCard(icon: "calendar", tint: AppColors.blue, title: "A recurring rhythm", description: "Subscriptions land mostly in the first week. We’ll keep an eye on them.", action: "Review")
                    InsightCard(icon: "sparkles", tint: AppColors.mustard, title: "You’re 2 days ahead", description: "Your spending pace is lower than your usual mid-month average.", action: "Nice")
                }
                .padding(.bottom, 14)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }
}

private struct InsightMetric: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.inkSoft)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct InsightCard: View {
    let icon: String
    let tint: Color
    let title: String
    let description: String
    let action: String

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 34, height: 34)
                .background(tint.opacity(0.13), in: Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                Text(description)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                Text(action)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                    .padding(.top, 3)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(AppColors.card, in: RoundedRectangle(cornerRadius: 19, style: .continuous))
    }
}

private struct TransactionRow: View {
    let transaction: MoneyTransaction

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(transaction.tint)
                .frame(width: 37, height: 37)
                .background(transaction.tint.opacity(0.13), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.merchant)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.ink)
                    .lineLimit(1)
                Text("\(transaction.category.rawValue) · \(transaction.date)")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(AppColors.inkSoft)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            Text("\(transaction.isIncome ? "+" : "−")$\(transaction.amount, specifier: "%.2f")")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(transaction.isIncome ? AppColors.mintDeep : AppColors.ink)
        }
        .padding(.vertical, 11)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(transaction.merchant), \(transaction.isIncome ? "income" : "expense") \(transaction.amount, specifier: "%.2f")")
    }
}

private struct SectionHeader: View {
    let title: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 19, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
                .tracking(-0.35)
            Spacer()
            Button(action: action) {
                HStack(spacing: 5) {
                    Text(actionTitle)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 9, weight: .bold))
                }
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.inkSoft)
            }
            .buttonStyle(.plain)
        }
    }
}

private struct PageHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(eyebrow)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .tracking(1.35)
                .foregroundStyle(AppColors.inkSoft)
            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.ink)
                .tracking(-0.7)
            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(AppColors.inkSoft)
        }
    }
}

private struct AppTabBar: View {
    @Binding var selectedTab: AppTab
    let onAddTransaction: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            tabButton(.budgets)
            addButton
            tabButton(.activity)
            tabButton(.insights)
        }
        .padding(.horizontal, 8)
        .padding(.top, 9)
        .padding(.bottom, 7)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Rectangle().fill(.white.opacity(0.48)).frame(height: 0.5)
        }
    }

    private var addButton: some View {
        Button(action: onAddTransaction) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppColors.ink)
                .frame(width: 48, height: 48)
                .background(AppColors.mint, in: Circle())
                .shadow(color: AppColors.mintDeep.opacity(0.22), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Add transaction")
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: selectedTab == tab ? .bold : .medium))
                Text(tab.title)
                    .font(.system(size: 10, weight: selectedTab == tab ? .bold : .medium, design: .rounded))
            }
            .foregroundStyle(selectedTab == tab ? AppColors.ink : AppColors.inkSoft.opacity(0.75))
            .frame(maxWidth: .infinity)
            .frame(height: 47)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
    }
}

private struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (MoneyTransaction) -> Void

    @State private var merchant: String = ""
    @State private var amount: String = ""
    @State private var category: SpendingCategory = .food
    @State private var isIncome: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("How much?")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.inkSoft)
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Text("$")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColors.inkSoft)
                            TextField("0.00", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColors.ink)
                        }
                        Rectangle()
                            .fill(AppColors.line)
                            .frame(height: 1)
                    }

                    VStack(alignment: .leading, spacing: 9) {
                        Text("Merchant")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.inkSoft)
                        TextField("e.g. Corner cafe", text: $merchant)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .padding(.horizontal, 15)
                            .frame(height: 49)
                            .background(AppColors.canvas, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 11) {
                        Text("Category")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.inkSoft)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                            ForEach(SpendingCategory.allCases.filter { $0 != .income }) { item in
                                Button {
                                    category = item
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: item.icon)
                                            .font(.system(size: 13, weight: .semibold))
                                        Text(item.rawValue)
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .lineLimit(1)
                                    }
                                    .foregroundStyle(category == item ? AppColors.ink : AppColors.inkSoft)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 12)
                                    .frame(height: 42)
                                    .background(category == item ? AppColors.mint : AppColors.canvas, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Toggle(isOn: $isIncome) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("This is income")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColors.ink)
                            Text("Adds money to your balance")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(AppColors.inkSoft)
                        }
                    }
                    .tint(AppColors.mintDeep)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
            .background(AppColors.canvas)
            .navigationTitle("New transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(AppColors.inkSoft)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.mintDeep)
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        guard let value = Double(amount.replacingOccurrences(of: ",", with: ".")) else { return false }
        return value > 0 && !merchant.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func save() {
        guard let value = Double(amount.replacingOccurrences(of: ",", with: ".")), canSave else { return }
        let newTransaction = MoneyTransaction(
            merchant: merchant.trimmingCharacters(in: .whitespacesAndNewlines),
            category: isIncome ? .income : category,
            amount: value,
            date: "Just now",
            icon: isIncome ? "arrow.down.left" : category.icon,
            tint: isIncome ? AppColors.mintDeep : AppColors.coral,
            isIncome: isIncome
        )
        onSave(newTransaction)
        dismiss()
    }
}

private struct BalanceSparkline: View {
    private let points: [CGFloat] = [0.80, 0.73, 0.78, 0.62, 0.65, 0.46, 0.52, 0.36, 0.42, 0.26, 0.31, 0.12]

    var body: some View {
        GeometryReader { proxy in
            Path { path in
                guard let first = points.first else { return }
                path.move(to: CGPoint(x: 0, y: proxy.size.height * first))
                for (index, point) in points.dropFirst().enumerated() {
                    let x = proxy.size.width * CGFloat(index + 1) / CGFloat(points.count - 1)
                    path.addLine(to: CGPoint(x: x, y: proxy.size.height * point))
                }
            }
            .stroke(AppColors.ink.opacity(0.72), style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(AppColors.ink)
                    .frame(width: 7, height: 7)
                    .offset(x: -1, y: -proxy.size.height * 0.12)
            }
        }
    }
}

private struct WeeklyBars: View {
    private let bars: [CGFloat] = [0.42, 0.55, 0.35, 0.76, 0.58, 0.88, 0.49]
    private let labels: [String] = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(Array(bars.enumerated()), id: \.offset) { index, value in
                VStack(spacing: 7) {
                    GeometryReader { proxy in
                        VStack {
                            Spacer(minLength: 0)
                            Capsule()
                                .fill(index == 5 ? AppColors.coral : AppColors.mint.opacity(0.75))
                                .frame(height: proxy.size.height * value)
                        }
                    }
                    Text(labels[index])
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.inkSoft)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct InsightMiniChart: View {
    private let points: [CGFloat] = [0.82, 0.78, 0.70, 0.74, 0.53, 0.58, 0.40, 0.44, 0.25, 0.19]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VStack(spacing: 0) {
                    Divider().overlay(AppColors.ink.opacity(0.10))
                    Spacer()
                    Divider().overlay(AppColors.ink.opacity(0.10))
                    Spacer()
                    Divider().overlay(AppColors.ink.opacity(0.10))
                }
                Path { path in
                    guard let first = points.first else { return }
                    path.move(to: CGPoint(x: 0, y: proxy.size.height * first))
                    for (index, point) in points.dropFirst().enumerated() {
                        let x = proxy.size.width * CGFloat(index + 1) / CGFloat(points.count - 1)
                        path.addLine(to: CGPoint(x: x, y: proxy.size.height * point))
                    }
                }
                .stroke(AppColors.mintDeep, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

#Preview {
    ContentView()
}
