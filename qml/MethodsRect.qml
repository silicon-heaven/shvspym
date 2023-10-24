import QtQuick
import QtQuick.Controls

Rectangle {
	id: root

	required property StackView stackView
	required property string shvPath

	property int rowCount: 0

	function setMethods(methods) {
		let n = 0
		for(let method of methods) {
			method.shvPath = root.shvPath;
			console.log("method description:", JSON.stringify(method));
			listModel.append(method);
			n++
		}
		root.rowCount = n
	}

	ListView {
		id: listView
		anchors.fill: parent

		model: ListModel {
			id: listModel
		}

		focus: true

		delegate: MethodDelegate {
			width: listView.width;
			stackView: root.stackView
		}
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	Component.onCompleted: {
	}
}
