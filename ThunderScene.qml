import Quickshell
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

  RainScene {
    anchors.fill: parent
    active: root.active && root.popupShown
    popupShown: root.popupShown
  }

  Rectangle {
    id: thunderCloud
    y: 12
    x: -width
    width: 60
    height: 24
    radius: 12
    color: root.tint(Color.muted, 0.9)

    NumberAnimation on x {
      from: -width
      to: root.width
      duration: 9000
      loops: Animation.Infinite
      running: root.active && root.popupShown
    }
  }

  Rectangle {
    id: flashOverlay
    anchors.fill: parent
    color: "white"
    opacity: 0
    z: 6

    Timer {
      id: lightningTimer
      interval: 3500
      running: root.active && root.popupShown
      repeat: true
      onTriggered: {
        flashAnim.restart()
        lightningTimer.interval = 2500 + Math.random() * 4000
      }
    }

    SequentialAnimation {
      id: flashAnim
      onStopped: flashOverlay.opacity = 0
      NumberAnimation {
        target: flashOverlay
        property: "opacity"
        from: 1
        to: 0.2
        duration: 60
      }
      NumberAnimation {
        target: flashOverlay
        property: "opacity"
        from: 0.2
        to: 0
        duration: 120
      }
    }
  }
}
