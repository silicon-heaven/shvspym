import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Dialog {
	id: root
	modal: true
	standardButtons: Dialog.Ok
	anchors.centerIn: Overlay.overlay
	ColumnLayout {
		anchors.fill: parent
		Text {
			text: "ShvSpy " + app.appVersion
		}
		Text {
			property string link: "https://github.com/silicon-heaven/shvspym";
			text: '<html><style type="text/css"></style><a href="' + link + '">github</a></html>'
			onLinkActivated: Qt.openUrlExternally(link)
		}
	}

}
