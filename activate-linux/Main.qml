import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Widgets

// Adapted from https://git.outfoxxed.me/quickshell/quickshell-examples/src/branch/master/activate_linux

Item {
  id: root
  property var pluginApi: null
  readonly property string osName:
  pluginApi?.pluginSettings?.osName ||
  pluginApi?.manifest?.metadata?.defaultSettings?.osName ||
  "Linux"

  Variants {
    model: Quickshell.screens // Display on all screens

    PanelWindow {

      anchors { right: true; bottom: true }
      margins { right: 50; bottom: 50 }

      implicitWidth: content.width
      implicitHeight: content.height

      color: "transparent"

      // Give the window an empty click mask so all clicks pass through it.
      mask: Region {}
      WlrLayershell.layer: WlrLayer.Overlay

      ColumnLayout {
        id: content

        NText {
          text: pluginApi?.tr("panel.activate", { osName: root.osName }) ||
          `Activate ${root.osName}`
          color: "#50ffffff"
          pointSize: 22
        }

        NText {
          text: pluginApi?.tr("panel.goto_settings", { osName: root.osName }) ||
          `Go to Settings to activate ${root.osName}.`
          color: "#50ffffff"
          pointSize: 14
        }
      }
    }
  }
}

