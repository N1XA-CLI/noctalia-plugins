import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Widgets
import qs.Services.Location

Item {
  id: root

  readonly property bool weatherReady: Settings.data.location.weatherEnabled && (LocationService.data.weather !== null)

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property bool hovered: false

  readonly property bool showTempText: pluginApi?.pluginSettings?.showTempText ?? false
  readonly property bool showConditionIcon: pluginApi?.pluginSettings?.showConditionIcon ?? false
  readonly property bool removeTempLetter: pluginApi?.pluginSettings?.removeTempLetter ?? false

  readonly property string barPosition: Settings.data.bar.position
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"

  visible: root.weatherReady
  opacity: root.weatherReady ? 1.0 : 0.0

  readonly property real contentWidth: isVertical ? Style.capsuleHeight : layout.implicitWidth + Style.marginS * 2
  readonly property real contentHeight: isVertical ? layout.implicitHeight + Style.marginS * 2 : Style.capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    color: root.hovered ? Color.mHover : Style.capsuleColor
    radius: Style.radiusM
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Item {
      id: layout
      anchors.centerIn: parent

      implicitWidth: grid.implicitWidth
      implicitHeight: grid.implicitHeight

      GridLayout {
        id: grid
        columns: root.isVertical ? 1 : 2
        rowSpacing: Style.marginS
        columnSpacing: Style.marginS

        NIcon {
          Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
          icon: weatherReady ? LocationService.weatherSymbolFromCode(LocationService.data.weather.current_weather.weathercode, LocationService.data.weather.current_weather.is_day) : "weather-cloud-off"
          color: root.hovered ? Color.mOnHover : Color.mOnSurface
          visible: root.showConditionIcon
        }

        NText {
          Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: {
            if (!weatherReady || !root.showTempText) {
                return "";
            }
            var temp = LocationService.data.weather.current_weather.temperature;
            var suffix = "C";
            if (Settings.data.location.useFahrenheit) {
                temp = LocationService.celsiusToFahrenheit(temp);
                var suffix = "F";
            }
            temp = Math.round(temp);
            if (!root.removeTempLetter) {
                suffix = "";
            }
            return `${temp}°${suffix}`;
            }
          color: root.hovered ? Color.mOnHover : Color.mOnSurface
          pointSize: Style.barFontSize
          visible: root.showTempText
        }
      }
    }
    }
}
