import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property bool showTempText: pluginApi?.pluginSettings?.showTempText || pluginApi?.manifest?.metadata?.defaultSettings?.showTempText
  property bool showConditionIcon: pluginApi?.pluginSettings?.showConditionIcon || pluginApi?.manifest?.metadata?.defaultSettings?.showConditionIcon
  property bool removeTempLetter: pluginApi?.pluginSettings?.removeTempLetter || pluginApi?.manifest?.metadata?.defaultSettings?.removeTempLetter

  spacing: Style.marginL

  Component.onCompleted: {
    Logger.i("WeatherIndicator", "Settings UI loaded");
  }

  NToggle {
    id: toggleIcon
    label: pluginApi?.tr("settings.showConditionIcon.label") || "showConditionIcon"
    description: pluginApi?.tr("settings.showConditionIcon.desc") || "Show the condition icon"
    checked: root.showConditionIcon
    onToggled: function (checked) {
      root.showConditionIcon = checked;
      root.showTempText = true;
    }
  }

  NToggle {
    id: toggleTempText
    label: pluginApi?.tr("settings.showTempText.label") || "showTempText"
    description: pluginApi?.tr("settings.showTempText.desc") || "Show the temperature"
    checked: root.showTempText
    onToggled: function (checked) {
      root.showTempText = checked;
      root.showConditionIcon = true;
    }
  }

  NToggle {
    id: toggleTempLetter
    label: pluginApi?.tr("settings.removeTempLetter.label") || "removeTempLetter"
    description: pluginApi?.tr("settings.removeTempLetter.desc") || "Remove temperature letter (F or C)"
    checked: root.removeTempLetter
    visible: root.showTempText
    onToggled: function (checked) {
      root.removeTempLetter = checked;
      root.showTempText = true;
    }
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("WeatherIndicator", "Cannot save settings: pluginApi is null");
      return;
    }

    pluginApi.pluginSettings.showTempText = root.showTempText;
    pluginApi.pluginSettings.showConditionIcon = root.showConditionIcon;
    pluginApi.pluginSettings.removeTempLetter = root.removeTempLetter;

    pluginApi.saveSettings();

    Logger.i("WeatherIndicator", "Settings saved successfully");
    pluginApi.closePanel(root.screen);
  }
}
