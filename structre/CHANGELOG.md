## 1.0.0-rc-1

Remove unnecessary files that upload to pub.dev

## 1.0.0-beta-8+1

* Ignore test script

## 1.0.0-beta-8

* Set Dart version `2.14` as minimum version
* Added `.pubignore`

## 1.0.0-beta-7

* Create `convertHolidayOnlyListFromSource` and `convertEventsOnlyListFromSource` to convenient conversion process

## 1.0.0-beta-6

* Create `tools` library
* `DateRemind`, `DateRemindGenerator` and `DateRemindListConversion` now beloning to `tools` library

## 1.0.0-beta-5

* Add `indexWhere` in `YearMonthRange`

## 1.0.0-beta-4

* Hide `DateRemind` and it abstracted classes
* Add `DateRemindGenerator` for exporting `Events` and `Holiday` in existed class

## 1.0.0-beta-3

* Fix `YearMonthRange` incorrect sort order issue

## 1.0.0-beta-2+1

* Hide `getDString` in export

## 1.0.0-beta-2

* Add `SingleDateRemind` under `DateRemind`
* Allowing check ongoing remind with `isOngoingDate` in `DurationDateRemind`
* Fix some document spelling

## 1.0.0-beta-1+2

* Fix `YearMonth`'s hash code pointing issue

## 1.0.0-beta-1+1

* Add repository URL in pubspec

## 1.0.0-beta-1

Initial release version

**Contains:**

* Date
    * `YearMonth`
* Week
    * `FirstDayOfWeek`
* Date reminds
    * `DateRemind`
        * `DurationDateRemind`
            * `Events`
                * `AllDayEvents`
        * `Holiday`
