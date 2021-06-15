//////  TriggerBarGraph :: Yet Anoter Label by JackV
//////  Based on : 'solarBarGraph.qml' 'Graph BY OEPI-LOEPI for TOON'
//////  So many thanks to OEPIE-LOEPI for 'solarBarGraph.qml'/*
/*
JackV changes :
added 
    rotateValuesOnBar
        value , bottom text  : 0,down ; 90,left ; 180,up ; 270,right
        a value of 315 gives an angle of 45 degrees with text going up to the right

    barWidthFactor1 and 2
        multiply bar width by this factor
        bars from array dataValues2 are in front and may hide bars of array dataValues so 'barWidthFactor1 : 2' shows them again
        
    toggleValuesOnBar
        clicking on a graph will show/hide values on the bar
        
    triggerMode and trigger
    reason example : when paging between air conditioners on my report screen I need quick changes of the graphs
        triggerMode
            when false : the graph updates itself every 30 seconds like in original by Oepi Loepi
            when true  : no automatic updates, you trigger the update yourself by setting the trigger true
        trigger
            given 1 screen with 3 TriggerBarGraphs with ids myGraph1, myGraph2 and myGraph3
            in a function xyz you first prepare data by calculations and after the calculations you trigger like :
                'some calculations'
                myGraph1.trigger = true
                myGraph2.trigger = true
                myGraph3.trigger = true
            this will trigger each graph to update and reset its trigger so you may trigger again
            now add prev and next buttons to go to other devices and call your function xyz again
            
*/

import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Item {
	id: solarBarGraph
//
    property int rotateValuesOnBar : 0
    property int barWidthFactor1 : 1
    property int barWidthFactor2 : 1
    property bool toggleValuesOnBar : false

    property bool triggerMode : false
    property bool trigger : false
    
//
	width: 400
	height: 200
	property bool   isAreaGraph: false
	property string hourGridColor:"red"
	property bool   isManualMax: false
	property int 	manualMax:2000
	
	property bool 	isRolling : false
	property string rollingMinX : ""
	property string rollingCenterX : ""
    property string rollingMaxX : ""
    	
	property string titleText:"Text"
	property string titleFont: qfont.bold.name
	property int    titleSize: isNxt ? 16 : 12
	property bool   showTitle : true
	property string titleTextColor : "black"
	property string backgroundcolor : "white"
	property string axisColor : "black"
    property string barColor : "blue"
	property bool   lineXaxisvisible : true
 	property string textXaxisColor : "red"
	property int    stepXtext: 5
	property string valueFont: qfont.bold.name
	property int 	valueSize: isNxt ? 16 : 12
	property string valueTextColor : "blue"
	property bool   showValuesOnBar : true
	property string levelColor :"red"
	property string levelTextColor : "blue"
	property bool   showLevels  : true
	property bool   showValuesOnLevel : true
	property string specialBarColor :"red"
	property int   	specialBarIndex  : 0
	property bool   showSpecialBar : false	
	property variant dataValues: []
	
	//second bar should have lower values than the first.
//JackV or make use of barWidthFactor1, barWidthFactor2
	property bool   isStacked : true
	property string specialBarColor2 :"green"
	property int   	specialBarIndex2  : 0
	property bool   showSpecialBar2 : false
	property string barColor2 : "purple"
	
	property bool   showSunbars : false
	property string sunBarColor : "purple"
	property int   	sunrisePerc  : 0
	property int   	sunsetPerc  : 0

	property variant dataValues2: []
	
    property int iMin
    property int iMax
    property int mMin
    property int mMax
	property int maxFormatted
	property int barWidthAdjust

	signal clicked()

    function doClick(){
//JackV 1 add property toggleValuesOnBar
        showValuesOnBar = toggleValuesOnBar && !showValuesOnBar
		calculateValues()
        clicked()
    }
    
	Timer {
        id: openTimer   //when opening screen
        interval: 1000
		repeat: false
        running: true
        triggeredOnStart: true
        onTriggered: calculateValues()
    }

//JackV Timer trigger mechanism

	Timer {
        id: intervalTimer   //when opening screen
        interval: 30000
		repeat: true
        running: (triggerMode) ? trigger : true
//JackV triggerMode        triggeredOnStart: false
        triggeredOnStart: triggerMode
        onTriggered:  { 
            if (triggerMode) {
                calculateValues()
                trigger=false
            } else {
                calculateValues()
            }
        }
    }
    
    
	

	function calculateValues(){
		if(!isManualMax){
			iMax = 1
			if (typeof dataValues[0] != 'undefined' && typeof dataValues[0] != 'null' && !isNaN(dataValues[0])){
				iMin = dataValues[0]
				if(isAreaGraph) iMax = 100
				for (var i in dataValues){
				  if (dataValues[i] < iMin)iMin = dataValues[i]
				  if (dataValues[i] > iMax)iMax = dataValues[i]
				}
			}else{
				iMin = 0
				iMax = 10
			}
		}
		
		if(isManualMax) iMax = Math.round(manualMax)
		//console.log("*****************************************8solarbar iMax: " + iMax)
		if(iMax >= 0 & iMax < 1) maxFormatted = 1
		if(iMax >= 1 & iMax < 2) maxFormatted = 2
		if(iMax >= 2 & iMax < 3) maxFormatted = 3
		if(iMax >= 2 & iMax < 5) maxFormatted = 5
		if(iMax >= 5 & iMax < 11) maxFormatted = 10
		if(iMax >= 11 & iMax < 21) maxFormatted = 20
		if(iMax >= 21 & iMax < 31) maxFormatted = 30
		if(iMax >= 31 & iMax < 51) maxFormatted = 50
		if(iMax >= 51 & iMax < 101)	maxFormatted = 100
		if(iMax >= 101 & iMax < 151)  maxFormatted = 150
		if(iMax >= 151 & iMax < 201)  maxFormatted = 200
		if(iMax >= 201 & iMax < 251)  maxFormatted = 250
		if(iMax >= 251 & iMax < 301)  maxFormatted = 300
		if(iMax >= 301 & iMax < 501) maxFormatted = 500
		if(iMax >= 501 & iMax < 801) maxFormatted = 800
		if(iMax >= 801 & iMax < 1001) maxFormatted = 1000
		if(iMax >= 1001 & iMax < 1501) maxFormatted = 1500
		if(iMax >= 1501 & iMax < 2001) maxFormatted = 2000
		if(iMax >= 2001 & iMax < 2501) maxFormatted = 2500
		if(iMax >= 2501 & iMax < 3001) maxFormatted = 3000
		if(iMax >= 3001 & iMax < 5001) maxFormatted = 5000
		if(iMax >= 5001 & iMax < 8001) maxFormatted = 8000
		if(iMax >= 8001 & iMax < 10001) maxFormatted = 10000
		if(iMax >= 10001 & iMax < 15001) maxFormatted = 15000
		if(iMax >= 15001 & iMax < 20001) maxFormatted = 20000
		if(iMax >= 20001 & iMax < 25001) maxFormatted = 25000
		if(iMax >= 25001 & iMax < 30001) maxFormatted = 30000
		if(iMax >= 30001 & iMax < 50001) maxFormatted = 50000
		if(iMax >= 50001 & iMax < 100001) maxFormatted = 100000
		if(iMax >= 100001 & iMax < 200001) maxFormatted = 200000
		if(iMax >= 200001 & iMax < 500001) maxFormatted = 500000
		if(iMax >= 500001 & iMax < 1000001) maxFormatted = 1000000
		if(iMax >= 1000001) maxFormatted = Math.round(iMax)
		//console.log("*****************************************8solarbar maxFormatted: " + maxFormatted)
		if(dataValues.length >= 0 & dataValues.length < 1) barWidthAdjust = 1
		if(dataValues.length >= 1 & dataValues.length < 2) barWidthAdjust = 2
		if(dataValues.length >= 2 & dataValues.length < 5) barWidthAdjust = 5
		if(dataValues.length >= 5 & dataValues.length < 11) barWidthAdjust = 7
		if(dataValues.length >= 11 & dataValues.length < 51) barWidthAdjust = 10
		if(dataValues.length >= 51 & dataValues.length < 101)	barWidthAdjust = 50
		if(dataValues.length >= 101 & dataValues.length < 251)  barWidthAdjust = 100
		if(dataValues.length >= 251 & dataValues.length < 501) barWidthAdjust = 200
		if(dataValues.length >= 501 & dataValues.length < 1001) barWidthAdjust = 500
		if(dataValues.length >= 1001 & dataValues.length < 2001) barWidthAdjust = 1000
		if(dataValues.length >= 2001 & dataValues.length < 5001) barWidthAdjust = 2000
		if(dataValues.length >= 5001) barWidthAdjust = 5000
	}

	Component.onCompleted: {
		calculateValues()
    }
	
	Rectangle {
        id: barGraphRect
		width: showLevels?  (showValuesOnLevel? parent.width-(valueSize*3) : 0):parent.width
		height: showTitle? parent.height-(titleSize*2) : parent.height
        anchors {
			left:parent.left
			leftMargin: showLevels?  (showValuesOnLevel? valueSize*3 : 0):0
			top:parent.top
			topMargin: showTitle? titleSize*2 : 0
        }
        color : backgroundcolor
    }

    Text{
        id: titleTextHolder
        color: titleTextColor
        font.pixelSize: titleSize
        font.family: titleFont
        text: titleText
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
		visible: showTitle
    }

	Column {
		id: levels
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		Repeater {
			id: levelRepeater
			model: 5
			Item {
				height: (barGraphRect.height/1)/4
				width: barGraphRect.width
				Rectangle {
					id: level
//JackV force redraw on Toon 1					color: index==0? "transparent" : levelColor
					color: (trigger) ? "transparent" : index==0? "transparent" : levelColor
					height: 1
					width: barGraphRect.width
				}
				Text{
					id: levelValueText
					color: index==0? "transparent" : levelTextColor
					text: (maxFormatted/4)*(5-index)
					font.pixelSize: valueSize
					font.family: valueFont
					anchors {
						verticalCenter: level.verticalCenter
						right: level.left
						rightMargin:5
					}
				}
				visible: showValuesOnLevel
			}
		visible: showLevels
		}
	}

	
	Row {
		id: barGraph
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		Repeater {
			id: barRepeater
			model: dataValues.length
			Item {
				height: isNxt? 8 :6
				width: barGraphRect.width / dataValues.length
				Rectangle {
					id: bar
					color: ((index==specialBarIndex)&showSpecialBar)? specialBarColor : barColor
//JackV trigger bar height 1				height: dataValues[index]*barGraphRect.height/(maxFormatted*1)
					height: (trigger) ? 0 : dataValues[index]*barGraphRect.height/(maxFormatted*1)
//JackV bar width 1				width: barGraphRect.width / (8*barWidthAdjust)
					width: barGraphRect.width / (8*barWidthAdjust) * barWidthFactor1
					anchors {
						bottom: parent.bottom
						left: parent.left
					}
				}
				Text{
					id: linexaxisText
					color: textXaxisColor
					font.pixelSize: valueSize
					font.family: valueFont
					text: (index%stepXtext == 0)? index!=0? index: "" : index==1? "1" : ""
					anchors {
						top: bar.bottom
						topMargin: isNxt ? 10:8
						horizontalCenter: bar.horizontalCenter
					}
					visible: lineXaxisvisible
				}
				Rectangle{
					id: dash
					color: axisColor
					height: isNxt? 3:2
					width: 1
					anchors {
						baseline: bar.bottom
						horizontalCenter: bar.horizontalCenter
					}
					visible: !isAreaGraph
				}				
				Text{
					id: valueText
					color: valueTextColor
//JackV trigger labels				text: (dataValues[index] > 0 )? dataValues[index]:""
					text: (trigger) ? "" : (dataValues[index] > 0 )? dataValues[index]:""
					font.pixelSize: valueSize
					font.family: valueFont
					anchors {
                        bottom: bar.top
//JackV label margin move by 500 avoids Toon 1 to eat parts of the bars bottomMargin: isNxt ? 5:4
						bottomMargin: showValuesOnBar ? isNxt ? 10:8 : 500
//						bottomMargin: isNxt ? 10:8
						horizontalCenter: index>0? bar.horizontalCenter: bar.horizontalCenter
					}
//JackV rotateValuesOnBar
                    rotation : rotateValuesOnBar
					visible: showValuesOnBar
				}
			}
		}
		visible: !isAreaGraph
	}

	Row {
		id: barGraph2
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		Repeater {
			id: barRepeater2
			model: dataValues.length
			Item {
				height: isNxt? 8 :6
				width: barGraphRect.width / dataValues.length
				Rectangle {
					id: bar2
					color: ((index==specialBarIndex2)&showSpecialBar2)? specialBarColor2 : barColor2

//JackV trigger bar height 2					height: dataValues2[index]*barGraphRect.height/(maxFormatted*1)
					height: (trigger) ? 0 : dataValues2[index]*barGraphRect.height/(maxFormatted*1)
//JackV bar width 2					width: barGraphRect.width / (8*barWidthAdjust)
					width: barGraphRect.width / (8*barWidthAdjust) * barWidthFactor2
					anchors {
						bottom: parent.bottom
						left: parent.left
					}
				}			
			}
		}
		visible: !isAreaGraph & isStacked
	}



    Rectangle {
		id: lineYaxis
		color: axisColor
		height: barGraphRect.height
		width: isNxt? 2:1
		anchors {
			bottom: barGraphRect.bottom
			left: barGraphRect.left
		}
	}

	Rectangle {
		id: lineYaxisTopMarker1
		color: axisColor
		height: isNxt? 2:1
		width: isNxt? 10:8
		anchors {
			bottom: lineYaxis.top
			left: barGraphRect.left
		}
	}

	Rectangle {
		id: lineXaxis
		color: axisColor
		height: isNxt? 2:1
		width: barGraphRect.width
		anchors {
			bottom: barGraphRect.bottom
			left: barGraphRect.left
		}
	}
		

	
	Row {
		id: barHourGraph
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		Repeater {
			id: barHourRepeater
			model: !isRolling? 7 : 7
			Item {
				height: isNxt? 8:6
				width: !isRolling?  (barGraphRect.width / 6) : (barGraphRect.width / 6)
				Rectangle {
					id: hourbar
					color: hourGridColor
					height: barGraphRect.height
					width: 1
					anchors {
						bottom: parent.bottom
						left: parent.left
					}
				}
				Text{
					id: linexaxisHourText
					color: textXaxisColor
					font.pixelSize: valueSize
					font.family: valueFont
					text: ((index*3)+5) + ".00"
					anchors {
						top: hourbar.bottom
						topMargin: isNxt ? 10:8
						horizontalCenter: hourbar.horizontalCenter
					}
					visible: !isRolling
				}
				
				Text{
					id: linexaxisRollingText
					color: textXaxisColor
					font.pixelSize: valueSize
					font.family: valueFont
					text: index==0? rollingMinX : index==3? rollingCenterX : index==6? rollingMaxX : ""
					anchors {
						top: hourbar.bottom
						topMargin: isNxt ? 10:8
						horizontalCenter: hourbar.horizontalCenter
					}
					visible: isRolling
				}
			}
		}
		visible: isAreaGraph
	}
	
	Item {
		id: brgraphItem
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		height: barGraphRect.height
		AreaGraphControl {
			id: areaGraph
			width: parent.width
			height: parent.height
			color: barColor
			yScale: height /maxFormatted
			showNaN: false
			values: dataValues
		}
		visible: isAreaGraph
	}
	
	
	Item {
		id: brgraphItem2
		anchors.bottom: barGraphRect.bottom
		anchors.left: barGraphRect.left
		width: barGraphRect.width
		height: barGraphRect.height
		AreaGraphControl {
			id: areaGraph2
			width: parent.width
			height: parent.height
			color: barColor2
			yScale: height /maxFormatted
			showNaN: false
			values: dataValues2
		}
		visible: isAreaGraph & isStacked
	}
	
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: doClick()
        cursorShape: Qt.PointingHandCursor
    }

	
	Rectangle {
		id: sunriseBar
		color: sunBarColor
		height: barGraphRect.height - 40
		width: 3
		anchors {
			bottom: barGraphRect.bottom
			left: barGraphRect.left
			leftMargin : (sunrisePerc/100)*barGraphRect.width
		}
		visible: showSunbars & sunrisePerc>1
	}

	Text{
		id: sunriseText
		color: sunBarColor
		font.pixelSize: valueSize
		font.family: valueFont
		text: "zon op"
		anchors {
			bottom: sunriseBar.top
			horizontalCenter: sunriseBar.horizontalCenter
		}
		visible: sunriseBar.visible
	}

	
	Rectangle {
		id: sunsetBar
		color: sunBarColor
		height: barGraphRect.height - 40
		width: 3
		anchors {
			bottom: barGraphRect.bottom
			left: barGraphRect.left
			leftMargin : (sunsetPerc/100)*barGraphRect.width
		}
		visible: showSunbars & sunsetPerc>1
	}
	
	Text{
		id: sunsetText
		color: sunBarColor
		font.pixelSize: valueSize
		font.family: valueFont
		text: "zon onder"
		anchors {
			bottom: sunsetBar.top
			horizontalCenter: sunsetBar.horizontalCenter
		}
		visible: sunsetBar.visible
	}
	
}
