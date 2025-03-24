import QtQuick
import QtQuick.Controls
ApplicationWindow {
    visible: true
    width: 640
    height: 480

    VideoOutput {
        id: videoOutput
        anchors.fill: parent
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureViewfinder
        viewfinder.resolution: "640x480"
        videoOutput: videoOutput
    }
}
