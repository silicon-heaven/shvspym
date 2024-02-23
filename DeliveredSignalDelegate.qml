import QtQuick

Column {
	id: root
	required property string shvPath
	required property string method
	required property date timestamp
	required property string valuestr
	Text {
		text: root.shvPath + ":" + root.method
		elide: Text.ElideLeft
		font.bold: true
		width: parent.width
	}
	Text {
		text: root.timestamp.toString()
		width: parent.width
	}
	Text {
		text: valuestr
		width: parent.width
	}
	Rectangle {
		width: parent.width
		height: 1
		color: "#658552"
		border.width: 0
	}
}
