import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
	id: root

	required property string shvPath
	required property var nodes

	signal back()
	signal goBack(levels: int)
	padding: 0

	Rectangle {
		id: header

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		height: cancelBt.height
		color: app.settings.headerColor

		MyButton {
			id: cancelBt
			color: "transparent"
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			iconMargin: 10
			iconSource: "../images/back.svg"
			width: header.height
			onTapped: root.back()
		}
		Rectangle {
			anchors.left: cancelBt.right
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
			color: header.color
			Text {
				color: app.settings.headerTextColor
				text: root.shvPath
				elide: Text.ElideLeft
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
				style: Text.Normal
				font.bold: true
			}
			ComboBox {
				anchors.fill: parent
				id: combo
				visible: false
				onActivated: (index) => {
					//console.log("activated:", index)
					combo.visible = false
					//let new_path = splitPath().slice(index).reverse().join('/')
					//console.log("new_path:", new_path)
					root.goBack(index)
				}
			}
			TapHandler {
				onTapped: {
					let paths = root.shvPath.split('/').reverse()
					if(paths.length > 1) {
						combo.model = paths
						combo.visible = true
						combo.popup.open()
					}
				}
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
		//console.log("Create:", root.shvPath, root)
		app.methodsLoaded.connect((shv_path, meths) => {
			if(/*root && */shv_path === root.shvPath) {
				methods.setMethods(meths);
			}
		})
		app.callDir(root.shvPath)
	}

	//Component.onDestruction: {
	//	console.log("Destroy:", root.shvPath, root)
	//}
}
