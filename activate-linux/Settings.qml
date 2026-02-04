import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: settingsScreen

  property var pluginApi: null

  property string osName:
    pluginApi?.pluginSettings?.osName ||
    pluginApi?.manifest?.metadata?.defaultSettings?.osName ||
    "Linux"

  spacing: Style.marginM

  NTextInput {
    Layout.fillWidth: true
    label: "Operating System Name"
    description: "Name of the Operating System to display in the message"
    placeholderText: "Linux, Windows, BSD, ..."
    text: settingsScreen.osName
    onTextChanged: settingsScreen.osName = text
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("MyPlugin", "Cannot save: pluginApi is null")
      return
    }
    pluginApi.pluginSettings.osName = settingsScreen.osName
    pluginApi.saveSettings()
  }
}
