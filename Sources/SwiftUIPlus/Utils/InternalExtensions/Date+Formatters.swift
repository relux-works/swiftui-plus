import Foundation

extension Date {
    enum DateFormat: String {
        case defaultDate = "dd/MM/yy"
        case midDate = "dd MMM yyyy"
        case defaultTime = "HH:mm:ss"
        case defaultTimeMillis = "HH:mm:ss.SSS"
        case rfc1123 = "EEE',' dd MMM yyyy HH':'mm':'ss z"
        case avatarDate = "yyy-MM-dd'T'HH:mm:ss'Z'"
        case dateDashed = "yyyy-MM-dd'T'HH:mm:ss z"
        case dateAsDDMMMM = "dd MMMM"
        case dateAsDDMMMMYYYY = "dd MMMM yyyy"
        case dateAsMMMDDYYYY = "MMM dd, yyyy"
        case dateAsMMMDD = "MMM dd"
        case dateAsDayOfWeek = "EEEE"
        case dateAsDayOfWeekShort = "EEE"
        case dateAsHHmm = "HH:mm"
        case dateAsDDMM = "dd.MM"
        case dateAsDDMMYYY = "dd.MM.yyy"
        case dateNoYear = "MMMdd"
        case dateAsEEEMMMDYYYY = "EEE',' MMM d',' yyyy"
    }
}


extension Date {
    var toMillis: Int64 {
        Int64(timeIntervalSince1970 * 1000)
    }

    var toSeconds: Int64 {
        Int64(timeIntervalSince1970)
    }

    static func from(millis: Int64?) -> Date? {
        millis.map { number in Date(timeIntervalSince1970: Double(number) / 1000)}
    }

    static func from(millis: Int64) -> Date {
        Date(timeIntervalSince1970: Double(millis) / 1000)
    }

    static func from(seconds: Int64?) -> Date? {
        seconds.map() { number in Date(timeIntervalSince1970: Double(number))}
    }

    static var currentTimeInMillis: Int64 {
        Date().toMillis
    }

    init(fromMillis timeIntervalSince1970inMillis: Int64) {
        let timeIntervalSince1970inMillis = Double(timeIntervalSince1970inMillis)/1000
        self.init(timeIntervalSince1970: timeIntervalSince1970inMillis)
    }

    var timeWithMillis: String {
        "\(self.toString(as: "HH:mm:ss.SSS", timezone: .current))"
    }

    var timeWithNanos: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = .current

        let base = formatter.string(from: self)

        let nanos = Calendar.current.component(.nanosecond, from: self)
            // форматируем с ведущими нулями до 9 знаков
        let nanosStr = String(format: "%09d", nanos)

        return "\(base).\(nanosStr)"
    }
}


extension Int64 {
    var date: Date {
        Date.from(millis: self)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
}

extension Date {
    func add(
            years: Int = 0,
            months: Int = 0,
            days: Int = 0,
            hours: Int = 0,
            minutes: Int = 0,
            seconds: Int = 0
    ) -> Date {
        var dateComponent = DateComponents()
        dateComponent.year = years
        dateComponent.month = months
        dateComponent.day = days
        dateComponent.hour = hours
        dateComponent.minute = minutes
        dateComponent.second = seconds

        return
                Calendar.current.date(byAdding: dateComponent, to: self)
                        ?? self
    }
}

extension Date {
    func years(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }

    func months(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }

    func days(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }

    func hours(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }

    func minutes(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }

    func seconds(sinceDate: Date) -> Int? {
        Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
}


extension Date {
    func formatted(
            dateStyle: DateFormatter.Style = .none,
            dateFormat: DateFormat? = nil,
            timeStyle: DateFormatter.Style = .none,
            locale: Locale = .current,
            calendar: Calendar = .current
    ) -> String {
        let formatter = DateFormatter()

        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle

        if let dateFormat = dateFormat {
            formatter.setLocalizedDateFormatFromTemplate(dateFormat.rawValue) //"MMMdd"
        }

        return formatter.string(from: self)
    }

    func formatted(
            dateStyle: DateFormatter.Style = .none,
            timeStyle: DateFormatter.Style = .none,
            locale: Locale = .current,
            calendar: Calendar = .current
    ) -> String {
        let formatter = DateFormatter()

        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle

        return formatter.string(from: self)
    }

    func toString(as format: DateFormat, timezone: TimeZone = .current, locale: Locale = .current) -> String {
        return toString(as: format.rawValue, timezone: timezone, locale: locale)
    }

    func toString(as format: DateFormat, timezone: String, locale: Locale = .current) -> String {
        if let tzone = TimeZone(identifier: timezone) {
            return toString(as: format, timezone: tzone, locale: locale)
        }

        return toString(as: format, locale: locale)
    }

    func toStringIgnoreTimezone(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.timeZone = .current

        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func toString(as format: String, timezone: TimeZone? = .init(secondsFromGMT: 0), locale: Locale = .current) -> String {
        let formatter = DateFormatter()

        formatter.timeZone = timezone
        formatter.locale = locale

        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    /// Returns date formatted in 'user-friendly' manner.
    ///
    /// - For today and yesterday cases returns corresponding keys (use them as initializers for e.g. LocalizedStringKey);
    /// - If date is within current week of year, returns date in EEEE format (spelled day of week, e.g. Monday) localized and formatted in accordance with passed Locale and Calendar instances;
    /// - If date is within current year, returns date in MMMdd format (day + month) localized and formatted in accordance with passed Locale and Calendar instances;
    /// - If date is from last year (and for all other cases) returns full date in .medium DateFormatter style localized and formatted in accordance with passed Locale and Calendar instances;
    /// - parameter locale: Locale to use for formatting; Defaults to current user locale.
    /// - parameter calendar: Locale to use for formatting; Defaults to current user calendar.
    func userFriendlyFormatted(locale: Locale = .current, calendar: Calendar = .current) -> DateInPast {

        let calendar = calendar
        if(calendar.isDateInToday(self)){

            if calendar.isDate(Date(), equalTo: self, toGranularity: .minute) {
                return .justNow
            } else if calendar.isDate(Date(), equalTo: self, toGranularity: .hour) {
                let minutes = Date().get(.minute) - self.get(.minute)
                return .someMinutesAgo(minutes)
            } else {
                let hours =  Date().get(.hour) - self.get(.hour)
                return .someHoursAgo(hours)
            }
        } else if (calendar.isDateInYesterday(self)){

            return .yesterday
        } else {

            if calendar.isDate(Date(), equalTo: self, toGranularity: .weekOfMonth) {
                let dateStr = "\(formatted(dateStyle: .short, dateFormat: .dateAsDayOfWeek, locale: locale, calendar: calendar))"

                return .currentWeekLocalized(dateStr)
            } else if calendar.isDate(Date(), equalTo: self, toGranularity: .year) {
                let dateStr = "\(formatted(dateStyle: .short, dateFormat: .dateNoYear, locale: locale, calendar: calendar))"

                return .currentYearLocalized(dateStr)
            } else {
                let dateStr = "\(formatted(dateStyle: .medium, timeStyle: .none, locale: locale, calendar: calendar))"

                return .moreThanYearLocalized(dateStr)
            }
        }
    }
}


extension Date {
    enum DateInPast {
        case justNow
        case someMinutesAgo(Int)
        case someHoursAgo(Int)
        case yesterday
        case currentWeekLocalized(String)
        case currentYearLocalized(String)
        case moreThanYearLocalized(String)
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var startOfWeek: Date? {
        Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
