import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../code/eth.js" as Eth

Item {
	id: root
	
	Layout.fillHeight: true
	
	property string ethRate: '...'
	property bool showIcon: plasmoid.configuration.showIcon
	property bool showText: plasmoid.configuration.showText

	property bool updatingRate: false
	
	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.toolTipTextFormat: Text.RichText
	
	Plasmoid.compactRepresentation: Item {
		property int textMargin: ethIcon.height * 0.25
		property int minWidth: {
			if(root.showIcon && root.showText) {
				return ethValue.paintedWidth + ethIcon.width + textMargin;
			}
			else if(root.showIcon) {
				return ethIcon.width;
			} else {
				return ethValue.paintedWidth
			}
		}
		
		Layout.fillWidth: false
		Layout.minimumWidth: minWidth

		MouseArea {
			id: mouseArea
			anchors.fill: parent
			hoverEnabled: true
			onClicked: {
				action_refresh();
			}
		}
		
		BusyIndicator {
			width: parent.height
			height: parent.height
			anchors.horizontalCenter: root.showIcon ? ethIcon.horizontalCenter : ethValue.horizontalCenter
			running: updatingRate
			visible: updatingRate
		}
		
		Image {
			id: ethIcon
			width: parent.height * 0.9
			height: parent.height * 0.9
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.topMargin: parent.height * 0.05
			anchors.leftMargin: root.showText ? parent.height * 0.05 : 0
			
			source: "../images/eth.png"
			visible: root.showIcon
			opacity: root.updatingRate ? 0.2 : mouseArea.containsMouse ? 0.8 : 1.0
		}
		
		PlasmaComponents.Label {
			id: ethValue
			height: parent.height
			anchors.left: root.showIcon ? ethIcon.right : parent.left
			anchors.right: parent.right
			anchors.leftMargin: root.showIcon ? textMargin : 0
			
			horizontalAlignment: root.showIcon ? Text.AlignLeft : Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			
			visible: root.showText
			opacity: root.updatingRate ? 0.2 : mouseArea.containsMouse ? 0.8 : 1.0
			
			fontSizeMode: Text.Fit
			minimumPixelSize: ethIcon.width * 0.45
			text: root.ethRate
		}
	}
	
	Connections {
		target: plasmoid.configuration

		onRefreshRateChanged: function() {
			ethTimer.restart();
		}

		onShowDecimalsChanged: function() {
			ethTimer.restart();
		}
	}	
	

	Timer {
		id: ethTimer
		interval: plasmoid.configuration.refreshRate * 60 * 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			root.updatingRate = true;
			
			var result = Eth.getRate(function(rate) {
				if(!plasmoid.configuration.showDecimals) rate = Math.floor(rate);
				
				var rateText = Number(rate).toLocaleCurrencyString(Qt.locale(), "€");
				
				if(!plasmoid.configuration.showDecimals) rateText = rateText.replace(Qt.locale().decimalPoint + '00', '');
				
				root.ethRate = rateText;
				
				var toolTipSubText = '<b>' + root.ethRate + '</b>';
				toolTipSubText += '<br />';
				toolTipSubText += i18n('Market:') + ' Binance';
				
				plasmoid.toolTipSubText = toolTipSubText;
				
				root.updatingRate = false;
			});
		}
	}
	
	function action_refresh() {
		ethTimer.restart();
	}
}
