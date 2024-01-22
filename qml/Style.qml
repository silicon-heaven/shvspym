pragma Singleton
import QtQuick

QtObject {
	property int lineHeight: fontPixelSize * 100 / 150
	property int fontPixelSize: 15
	property color backgroundColor: "white"
	property color headerColor: "#3f8716"
	property color headerTextColor: backgroundColor
	property color buttonColor: Qt.lighter(headerColor)
	property color buttonBorderColor: backgroundColor
	property color delegateColor: Qt.lighter(Qt.lighter(headerColor))
	property color delegateAltColor: backgroundColor
	property color delegateColor2: "cornflowerblue"
	property color delegateAltColor2: delegateAltColor
}
