import QtQuick
import QtQuick.Controls

Rectangle {
	id: root

	required property string shvPath
	required property var nodes

	property int rowCount: 0

	ListView {
		id: nodeListView
		anchors.fill: parent

		model: ListModel {
			id: listModel
		}

		focus: true

		delegate: NodeDelegate {
			width: nodeListView.width;
		}
		ScrollIndicator.vertical: ScrollIndicator { }
	}
	Component.onCompleted: {
		let n = 0
		for(let nd of root.nodes) {
			console.log(nd);
			listModel.append({nodeName: nd, shvPath: root.shvPath});
			n++
		}
		root.rowCount = n
	}
}
