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

  component CloudShape: Rectangle {
    property int driftDur: 8000
    radius: height / 2
    color: root.tint(Color.muted, 0.5)
    y: parent.height * 0.5
    x: -width

    NumberAnimation on x {
      from: -width
      to: root.width
      duration: driftDur
      loops: Animation.Infinite
      running: root.active && root.popupShown
    }
  }

  CloudShape {
    width: 46
    height: 20
    y: 14
    driftDur: 9000
  }
  CloudShape {
    width: 34
    height: 16
    y: 34
    driftDur: 7000
  }
  CloudShape {
    width: 40
    height: 18
    y: 52
    driftDur: 11000
  }
}
