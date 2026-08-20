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

  component SunRay: Rectangle {
    anchors.centerIn: parent
    width: 4
    height: 32
    radius: 2
    color: root.tint(Color.accent, 0.9)
  }

  Item {
    id: sunGroup
    anchors.centerIn: parent
    width: 80
    height: 80
    opacity: 0.95

    RotationAnimation on rotation {
      from: 0
      to: 360
      duration: 12000
      loops: Animation.Infinite
      running: root.active && root.popupShown
    }

    SunRay {}
    SunRay { rotation: 60 }
    SunRay { rotation: 120 }

    Rectangle {
      anchors.centerIn: parent
      width: 20
      height: 20
      radius: 10
      color: root.tint(Color.accent, 1)

      SequentialAnimation on scale {
        loops: Animation.Infinite
        running: root.active && root.popupShown
        NumberAnimation {
          from: 1.0
          to: 1.15
          duration: 1200
          easing.type: Easing.InOutSine
        }
        NumberAnimation {
          from: 1.15
          to: 1.0
          duration: 1200
          easing.type: Easing.InOutSine
        }
      }
    }
  }
}
