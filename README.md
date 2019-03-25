# iCharts

The solution for Telegram "March Coding Competition".
Completely implemented using [Core Animation](https://developer.apple.com/documentation/quartzcore) and Auto Layout ([NSLayoutAnchor](https://developer.apple.com/documentation/uikit/nslayoutanchor)).

You may take part in beta testing on [TestFlight](https://testflight.apple.com/join/oV32hPvi).


## Telegram "March Coding Competition" tasks

- [x] Use date from [chart_data.json](https://github.com/specialfor/iCharts/blob/master/Shared/Resources/chart_data.json) as input for your charts
- [x] Show all 5 charts on one screen
- [x] Implement **Day/Night** mode
- [x] Add pan gesture on chart in order to highlight points at `x` and watch detailed information
- [x] Show `date` labels bellow `x` axis
- [x] Show `value` labels before `y` axis
- [x] Create `expandable slider control` in order to select visible part of chart and its scale.
- [x] Show visible part of [Xi, Xj] in [minY, maxY] segment with vertical insets at top and bottom, where minY = {y | y <= f(x), x in [Xi, Xj]}, maxY = {y | y >= f(x), x in [Xi, Xj]}
- [ ] Animate `value` labels changing
- [ ] Animate `date` labels changing
- [x] Animate appearance/dissappearance of lines on chart


## Workspace structure
- `iChartsDemo` is an iOS single view application project which demonstrates usage of `iCharts` framework
- `iCharts` is a framework which contains chart view source code
- `Utils` is a static library which contains some useful structs and typealiases such as `Result`, `Variable`, etc.


## Architecture
The implementation of `iCharts` framework is highly motivated by `Core Animaton` capabilities and classes composition instead of inheritance in order to have flexible, extendable and easy-maintainable code base with SRP principle in the head.

**Note:** of course in competition situation with time boundaries it is very hard to find trade offs between speed and quality, that's why some principles of SOLID are violated sometime.

### Views & Layers

- `ChartView` is a core view which is responsible for rendering all chart layers: 
![ChartView](https://i.ibb.co/SwVLZvF/Simulator-Screen-Shot-i-Phone-X-2019-03-25-at-13-02-41.png)
![Layer Hierarchy of `ChartView`](https://i.ibb.co/2MkdS2q/2019-03-25-12-56-28.jpg)
  - `GridLayer` draws horizontal lines of grid
  - `LineChartLayer` contains `LineLayer`s and `VerticalLineLayer`
    - LineLayer draws line based on `CGPoint` vector (if `VerticalLineLayer` is also appeared, it will also draw circle in order to show highlighted point)
    - `VerticalLineLayer` draws vertical line through highlighted points
  - `YLabelsLayer` draws labels above horizontal lines of `GridLayer` (`y` values of each line)
  - `XLabelsLayer` draws labels below `LinearChartLayer` or `x` axis in a nutshell (dates in "MMM dd" format)
- `PannableChartView` is a subclass of `UIControl` which implements behaviour similar to `UIPanGestureRecognizer`. It tells `ChartView` to show highlighted points and shows `ChartInfoView` with details of the points above chart.
- `ChartScrollView` contains instance of `PannableChartView` and `ExpandableSliderView` which allows user to choose visible part of chart and its scale.
- `DetailedChartView` contains instance of `ChartScrollView` and `UITableView` with names and colors of lines and capability to show/hide them.
  
### Normalizer

- `Normalizer` is a protocol which defines method for line normalization based on target rect size of layer.
- `SizeNormalizer` is a class which normalize lines based on:
  - [minY, maxY] segment with `verticalInses` (depends on `isInFullSize` and `verticalInset` properties)
  - [0, maxY] segment (full-sized)
  
**Note about minY, maxY:** 
- **Formal case:** minY, maxY are in {y | y in Y1 || Y2 || ... || Yn}, where `||` means union (set operation), Yi is a set of `y` values of the `i`th line 
- **Informal case:** minY, maxY are selected among each y of each line in chart
  