import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
	id: root
	required property string shvPath
	required property string method
	required property bool isActive
	//height: 50
	width: 500
	Text {
		text: shvPath + ":" + method + "()"
		Layout.fillWidth: true
	}

	Switch {
		id: switchDelegate
		//text: qsTr("Switch Delegate")
		checked: root.isActive
		onToggled: {
			app.subscriptionModel.subscribeSignal(root.shvPath, root.method, checked)
		}
	}
}
