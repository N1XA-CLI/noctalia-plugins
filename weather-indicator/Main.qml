import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root

 property var pluginApi: null

  IpcHandler {
    target: "plugin:weather-indicator"
  }

}
