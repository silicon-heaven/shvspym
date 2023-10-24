import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
	id: root

	required property string shvPath
	required property var nodes

	signal back()
	signal gotoRoot()
	padding: 0

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: cancelBt.height
		color: app.settings.headerColor

		Row {
			anchors.left: parent.left
			anchors.right: parent.right
			spacing: 5
			MyButton {
				id: cancelBt
				color: "transparent"
				iconMargin: 10
				iconSource: "../images/back.svg"
				width: header.height
				onTapped: root.back()
			}
			MyButton {
				id: rootBt
				color: cancelBt.color
				border.color: cancelBt.border.color
				iconMargin: 10
				iconSource: "../images/goto-root.svg"
				width: header.height
				onTapped: root.gotoRoot()
			}
			Text {
				color: app.settings.headerTextColor
				text: root.shvPath? root.shvPath: "shv path"
				anchors.verticalCenter: parent.verticalCenter
				horizontalAlignment: Text.AlignHCenter
				style: Text.Normal
				font.bold: true
			}
		}
	}
	Column {
		id: column
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: header.bottom
		anchors.bottom: parent.bottom

		function section_height(section) {
			let h = column.height - spacer.height
			if(nodes.rowCount == 0 && methods.rowCount == 0)
				return h / 2
			if(section.rowCount === 0)
				return 0
			if(section.rowCount === nodes.rowCount + methods.rowCount)
				return h
			return h * section.rowCount / (nodes.rowCount + methods.rowCount)
		}

		NodesRect {
			id: nodes
			anchors.left: parent.left
			anchors.right: parent.right
			height: column.section_height(nodes)
			//color: "#d8f2fb"
			nodes: root.nodes
			shvPath: root.shvPath
		}
		Rectangle {
			id: spacer
			anchors.left: parent.left
			anchors.right: parent.right
			height: 10
			color: app.settings.buttonBorderColor
		}
		MethodsRect {
			id: methods
			anchors.left: parent.left
			anchors.right: parent.right
			height: column.section_height(methods)
			stackView: root.parent
			//color: "#f6efd3"
			shvPath: root.shvPath
		}
	}
	Component.onCompleted: {
		app.methodsLoaded.connect((shv_path, meths) => {
			if(shv_path === root.shvPath) {
				methods.setMethods(meths);
			}
		})
		app.callDir(root.shvPath)
	}
}
