import QtQuick
import qs.Commons

Item {
  id: root
  property bool active: false
  property bool popupShown: false
  visible: root.active
  anchors.fill: parent

  function tint(c, a) {
    return Qt.rgba(c.r, c.g, c.b, a)
  }

  component FogBar: Rectangle {
    property int driftDur: 12000
    width: 90
    height: 10
    radius: 5
    color: root.tint(Color.foreground, 0.12)
    x: -width
    y: parent.height * 0.4

    NumberAnimation on x {
      from: -width
      to: root.width
      duration: driftDur
      loops: Animation.Infinite
      running: root.active && root.popupShown
    }

    SequentialAnimation on opacity {
      loops: Animation.Infinite
      running: root.active && root.popupShown
      NumberAnimation {
        from: 0.3
        to: 1.0
        duration: 4000
        easing.type: Easing.InOutSine
      }
      NumberAnimation {
        from: 1.0
        to: 0.3
        duration: 4000
        easing.type: Easing.InOutSine
      }
    }
  }

  FogBar {
    y: 14
    driftDur: 14000
  }
  FogBar {
    y: 34
    driftDur: 10000
  }
  FogBar {
    y: 52
    driftDur: 18000
  }
}
