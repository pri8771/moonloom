import Foundation

/// Formats the very large numbers common in idle games into compact, readable
/// strings (e.g. `1K`, `1.5M`, `1T`).
///
/// Design decisions (consistent with `TECHNICAL_PRD.md` §4 and the
/// `MOONLOOM-PROMPT-001` acceptance criteria):
/// - Round magnitudes render without trailing decimals: `1000 → "1K"`,
///   `1_000_000 → "1M"`, `1e12 → "1T"`.
/// - Non-round values render with up to two significant decimals, trimmed:
///   `1234 → "1.23K"`, `1_500_000 → "1.5M"`.
/// - Named suffixes run K, M, B, T, Qa, Qi, Sx, Sp, Oc, No, Dc; beyond that we
///   fall back to scientific notation (`1.23e45`).
/// - Values below 1000 render as plain integers.
///
/// The type is a stateless value (`Sendable`) so it is safe to share.
struct NumberAbbreviator: Sendable {

    /// Suffixes for successive powers of one thousand, starting at 10^3.
    static let suffixes = ["K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc"]

    /// Maximum number of fractional digits shown for abbreviated values.
    let maximumFractionDigits: Int

    init(maximumFractionDigits: Int = 2) {
        self.maximumFractionDigits = max(0, maximumFractionDigits)
    }

    /// Format a value into its abbreviated string representation.
    func string(from value: Double) -> String {
        guard value.isFinite else { return "∞" }
        if value < 0 { return "-" + string(from: -value) }
        if value < 1 {
            // Small fractional values (e.g. early CPS like 0.1) keep one digit.
            return value == 0 ? "0" : trimmed(value, fractionDigits: max(1, maximumFractionDigits))
        }
        if value < 1_000 {
            // Whole-ish small numbers: show as integers.
            return trimmed(value.rounded(.toNearestOrEven), fractionDigits: 0)
        }

        // Determine the thousands-grouping index (1 = K, 2 = M, ...).
        var magnitude = Int(floor(log10(value) / 3))
        var scaled = value / pow(1_000, Double(magnitude))
        // Guard against rounding pushing the mantissa to 1000 (e.g. 999_999 →
        // "1000K"): roll up to the next suffix instead.
        if scaled >= 1_000 && magnitude < Self.suffixes.count {
            magnitude += 1
            scaled = value / pow(1_000, Double(magnitude))
        }
        if magnitude >= 1 && magnitude <= Self.suffixes.count {
            let suffix = Self.suffixes[magnitude - 1]
            return trimmed(scaled, fractionDigits: maximumFractionDigits) + suffix
        }

        // Beyond the named suffixes, fall back to scientific notation.
        return scientific(value)
    }

    // MARK: - Helpers

    /// Render `value` with up to `fractionDigits` decimals, trimming trailing
    /// zeros and any dangling decimal separator. Always uses a `.` separator so
    /// output is locale-stable and matches the acceptance tests.
    private func trimmed(_ value: Double, fractionDigits: Int) -> String {
        var text = String(format: "%.\(fractionDigits)f", value)
        if text.contains(".") {
            while text.hasSuffix("0") { text.removeLast() }
            if text.hasSuffix(".") { text.removeLast() }
        }
        return text
    }

    private func scientific(_ value: Double) -> String {
        let formatted = String(format: "%.2e", value)
        // Normalise "1.23e+45" → "1.23e45" and strip leading exponent zeros.
        return formatted
            .replacingOccurrences(of: "e+0", with: "e")
            .replacingOccurrences(of: "e+", with: "e")
            .replacingOccurrences(of: "e-0", with: "e-")
    }
}

extension Double {
    /// Convenience for abbreviating a value with the default formatter.
    var abbreviated: String {
        NumberAbbreviator().string(from: self)
    }
}
